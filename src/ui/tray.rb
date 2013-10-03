require "singleton"
class Tray
  include Singleton

  attr_reader :menu, :shell, :dialog, :watching_dir

  def initialize()
    @http_server = nil
    @compass_thread = nil
    @watching_dir = nil
    @history_dirs  = App.get_history
    @shell    = App.create_shell(Swt::SWT::ON_TOP | Swt::SWT::MODELESS)

    if org.jruby.platform.Platform::IS_MAC
      @standby_icon = App.create_image("icon/16_dark@2x.png")
      @watching_icon = App.create_image("icon/16@2x.png")
    else 
      @standby_icon = App.create_image("icon/16_dark.png")
      @watching_icon = App.create_image("icon/16.png")
    end

    @tray_item = Swt::Widgets::TrayItem.new( App.display.system_tray, Swt::SWT::NONE)
    @tray_item.image = @standby_icon
    @tray_item.tool_tip_text = "Compass.app"
    @tray_item.addListener(Swt::SWT::Selection,  update_menu_position_handler) unless org.jruby.platform.Platform::IS_MAC
    @tray_item.addListener(Swt::SWT::MenuDetect, update_menu_position_handler)

    @menu = Swt::Widgets::Menu.new(@shell, Swt::SWT::POP_UP)

    @watch_item = add_menu_item( "Watch a Folder...", open_dir_handler)

    add_menu_separator

    @history_item = add_menu_item( "History:")

    build_history_menuitem

    add_menu_separator
    item =  add_menu_item( "Create Compass Project", create_project_handler, Swt::SWT::CASCADE)

    item.menu = Swt::Widgets::Menu.new( @menu )
    build_compass_framework_menuitem( item.menu, create_project_handler )

    item =  add_menu_item( "Open Extensions Folder", open_extensions_folder_handler, Swt::SWT::PUSH)
    item =  add_menu_item( "Preference...", preference_handler, Swt::SWT::PUSH)

    item =  add_menu_item( "About", open_about_link_handler, Swt::SWT::CASCADE)
    item.menu = Swt::Widgets::Menu.new( @menu )
    add_menu_item( 'Homepage',                      open_about_link_handler,   Swt::SWT::PUSH, item.menu)
    add_menu_item( 'Compass ' + Compass::VERSION, open_compass_link_handler, Swt::SWT::PUSH, item.menu)
    add_menu_item( 'Sass ' + Sass::VERSION,       open_sass_link_handler,    Swt::SWT::PUSH, item.menu)
    add_menu_item( 'LiveReload.js',       open_livereloadjs_link_handler,    Swt::SWT::PUSH, item.menu)
    add_menu_separator( item.menu )

    add_menu_item( "App Version: #{App.version}",                          nil, Swt::SWT::PUSH, item.menu)
    add_menu_item( App.compile_version, nil, Swt::SWT::PUSH, item.menu)

    add_menu_item( "Quit",      exit_handler)
  end

  def shell 
    @shell
  end

  def run
    puts 'tray OK, spend '+(Time.now.to_f - Main.init_at.to_f).to_s
    
    SplashWindow.instance.dispose

    while(!@shell.is_disposed) do
      App.display.sleep if(!App.display.read_and_dispatch) 
      App.show_and_clean_notifications
    end

    App.display.dispose

  end

  def rewatch
    if @watching_dir
      dir = @watching_dir
      stop_watch
      watch(dir)
    end
  end

  def add_menu_separator(menu=nil, index=nil)
    menu = @menu unless menu
    if index
      Swt::Widgets::MenuItem.new(menu, Swt::SWT::SEPARATOR, index)
    else
      Swt::Widgets::MenuItem.new(menu, Swt::SWT::SEPARATOR)
    end
  end

  def add_menu_item(label, selection_handler = nil, item_type =  Swt::SWT::PUSH, menu = nil, index = nil)
    menu = @menu unless menu
    if index
      menuitem = Swt::Widgets::MenuItem.new(menu, item_type, index)
    else
      menuitem = Swt::Widgets::MenuItem.new(menu, item_type)
    end

    menuitem.text = label
    if selection_handler
      menuitem.addListener(Swt::SWT::Selection, selection_handler ) 
    else
      menuitem.enabled = false
    end
    menuitem
  end

  def add_compass_item(dir)
    if File.exists?(dir)
      menuitem = Swt::Widgets::MenuItem.new(@menu , Swt::SWT::PUSH, @menu.indexOf(@history_item) + 1 )
      menuitem.text = "#{dir}"
      menuitem.addListener(Swt::SWT::Selection, compass_switch_handler)
      menuitem
    end
  end

  def empty_handler
    Swt::Widgets::Listener.impl do |method, evt|

    end
  end

  def clear_history
    @menu.items.each do |item|
      item.dispose if @history_dirs.include?(item.text)
    end
    @history_dirs = []
    App.clear_histoy
    build_history_menuitem
  end

  def compass_switch_handler
    Swt::Widgets::Listener.impl do |method, evt|
      if @compass_thread
        stop_watch
      end
      watch(evt.widget.text)
    end
  end

  def open_dir_handler
    Swt::Widgets::Listener.impl do |method, evt|
      if @compass_thread
        stop_watch
      else
        @dialog = Swt::Widgets::DirectoryDialog.new(@shell)
        dir = @dialog.open
        watch(dir) if dir 
      end
    end
  end
  
  def open_extensions_folder_handler
    Swt::Widgets::Listener.impl do |method, evt|
      if !File.exists?(App.shared_extensions_path)
        FileUtils.mkdir_p(App.shared_extensions_path)
        FileUtils.cp(File.join(Main.lib_path, "documents", "extensions_readme.txt"), File.join(App.shared_extensions_path, "readme.txt") )
      end

      Swt::Program.launch(App.shared_extensions_path)
    end 
  end 

  def open_project_handler
    Swt::Widgets::Listener.impl do |method, evt|
        Swt::Program.launch(@watching_dir)
    end
  end

  def compass_project_config
    file_name = Compass.detect_configuration_file(@watching_dir)
    Compass.add_project_configuration(file_name)
  end

  def build_change_options_panel( index )
    @changeoptions_item = add_menu_item( "Change Options...", change_options_handler , Swt::SWT::PUSH, @menu, index)
    
  end

  def build_compass_framework_menuitem( submenu, handler )
    Compass::Frameworks::ALL.each do | framework |
      next if framework.name =~ /^_/
      next if framework.template_directories.empty?

      # get default compass extension name from folder name
      if framework.templates_directory =~ /lib[\/\\]ruby[\/\\]compass_extensions[\/\\]([^\/\\]+)/
         framework_name = $1
      else
         framework_name = framework.name
      end

      item = add_menu_item( framework_name, handler, Swt::SWT::CASCADE, submenu)
      framework_submenu = Swt::Widgets::Menu.new( submenu )
      item.menu = framework_submenu
      framework.template_directories.each do | dir |
      add_menu_item( dir, handler, Swt::SWT::PUSH, framework_submenu)
    end
    end
  end

  def build_history_menuitem
    @history_dirs.reverse.each do | dir |
      add_compass_item(dir)
    end
    App.set_histoy(@history_dirs[0, App::CONFIG["num_of_history"]])
  end

  def create_project_handler
    Swt::Widgets::Listener.impl do |method, evt|
      @dialog = Swt::Widgets::FileDialog.new(@shell,Swt::SWT::SAVE)
      dir = @dialog.open
      if dir
        dir.gsub!('\\','/') if org.jruby.platform.Platform::IS_WINDOWS

        # if select a pattern
        if framework = Compass::Frameworks::ALL.find{ | f| 
          f.name == evt.widget.getParent.getParentItem.text || f.templates_directory =~ %r{compass_extensions[\/\\]#{evt.widget.getParent.getParentItem.text}}
        }
          framework_name = framework.name
          pattern = evt.widget.text
        else
          framework_name = evt.widget.txt
          pattern = 'project'
        end

        App.try do 
          actual = App.get_stdout do
            Compass::Commands::CreateProject.new( dir, 
                                                 { :framework        => framework_name, 
                                                   :pattern          => pattern, 
                                                   :preferred_syntax => App::CONFIG["preferred_syntax"].to_sym 
            }).execute
          end
          App.report( actual) do
            Swt::Program.launch(dir)
          end

        end

        watch(dir)
      end
    end
  end

  def install_project_handler
    Swt::Widgets::Listener.impl do |method, evt|
      # if select a pattern
      if framework = Compass::Frameworks::ALL.find{ | f| 
        f.name == evt.widget.getParent.getParentItem.text || f.templates_directory =~ %r{compass_extensions[\/\\]#{evt.widget.getParent.getParentItem.text}}
      }
        framework_name = framework.name
        pattern = evt.widget.text
      else
        framework_name = evt.widget.txt
        pattern = 'project'
      end


      App.try do 
        actual = App.get_stdout do
          Compass::Commands::StampPattern.new( @watching_dir, 
                                              { :framework => framework_name, 
                                                :pattern => pattern,
                                                :preferred_syntax => App::CONFIG["preferred_syntax"].to_sym 
          } ).execute
        end
        App.report( actual)
      end

    end
  end

  def change_options_handler 
    Swt::Widgets::Listener.impl do |method, evt|
      ChangeOptionsPanel.instance.open
    end
  end

  def preference_handler 
    Swt::Widgets::Listener.impl do |method, evt|
      PreferencePanel.instance.open
    end
  end

  def open_about_link_handler 
    Swt::Widgets::Listener.impl do |method, evt|
      Swt::Program.launch('http://compass.kkbox.com')
    end
  end

  def open_compass_link_handler
    Swt::Widgets::Listener.impl do |method, evt|
      Swt::Program.launch('http://compass-style.org/')
    end
  end

  def open_sass_link_handler
    Swt::Widgets::Listener.impl do |method, evt|
      Swt::Program.launch('http://sass-lang.com/')
    end
  end
  
  def open_livereloadjs_link_handler
    Swt::Widgets::Listener.impl do |method, evt|
      Swt::Program.launch('https://github.com/livereload/livereload-js')
    end
  end

  def exit_handler
    Swt::Widgets::Listener.impl do |method, evt|
      stop_watch
      App.set_histoy(@history_dirs[0, App::CONFIG["num_of_history"]])
      @shell.close
    end
  end

  def update_menu_position_handler 
    Swt::Widgets::Listener.impl do |method, evt|
      @menu.visible = true
    end
  end


  def clean_project_handler
    Swt::Widgets::Listener.impl do |method, evt|
      clean_project(true)
    end
  end

  def clean_project(show_report = false)
    dir = @watching_dir
    stop_watch
    App.try do 
      actual = App.get_stdout do
        logger = Compass::Logger.new({ :display => App.display,:log_dir => dir}) 
        Compass::Commands::CleanProject.new(dir, {:logger => logger}).perform
        Compass.reset_configuration!
        Compass::Commands::UpdateProject.new( dir, {:logger => logger}).perform
        Compass.reset_configuration!
      end
      App.report( actual ) if show_report
    end
    watch(dir)
  end

  def update_config(need_clean_attr, value)
    new_config_str = "\n#{need_clean_attr} = #{value} # by Compass.app "

    file_name = Compass.detect_configuration_file

    if file_name
      new_config = ''
      last_is_blank = false
      config_file = File.new(file_name,'r').each do | x | 
        next if last_is_blank && x.strip.empty?
      new_config += x unless x =~ /by Compass\.app/ && x =~ Regexp.new(need_clean_attr)
      last_is_blank = x.strip.empty?
      end
      config_file.close
      new_config += new_config_str
      File.open(file_name, 'w'){ |f| f.write(new_config) }
    else

      config_filename = File.join(Compass.configuration.project_path, 'config.rb')

      if File.exists?(config_filename) #file "config.rb" exists!
        App.alert("can't create #{config_filename}")
        return
      end

      File.open( config_filename, 'w'){ |f| f.write(new_config_str) }
    end
  end

  def watch(dir)
    dir.gsub!('\\','/') if org.jruby.platform.Platform::IS_WINDOWS
    App.try do 
      Compass.reset_configuration!
      Dir.chdir(dir)

      logger = Compass::Logger.new({ :display => App.display,:log_dir => dir}) 
      x = Compass::Commands::UpdateProject.new( dir, { :logger => logger })
        
      stop_watch

      if App::CONFIG['services'].include?( :http )
        SimpleHTTPServer.instance.start(Compass.configuration.project_path, :Port =>  App::CONFIG['services_http_port'])
      end

      if App::CONFIG['services'].include?( :livereload )
        SimpleLivereload.instance.watch(Compass.configuration.project_path, { :port => App::CONFIG["services_livereload_port"] }) 
      end

      current_display = App.display

      Thread.abort_on_exception = true
      @compass_thread = Thread.new do
         Thread.current[:watcher]=Compass::Watcher::AppWatcher.new(dir, Compass.configuration.watches, {:logger => logger})
         Thread.current[:watcher].watch!
      end

      @watching_dir = dir
      @menu.items.each do |item|
        item.dispose if @history_dirs.include?(item.text)
      end
      @history_dirs.delete_if { |x| x == dir }
      @history_dirs.unshift(dir)
      build_history_menuitem


      @watch_item.text="Stop watching " + dir
      @open_project_item =  add_menu_item( "Open Project Folder", 
                                          open_project_handler, 
                                          Swt::SWT::PUSH,
                                          @menu, 
                                          @menu.indexOf(@watch_item) +1 )

      @install_item =  add_menu_item( "Install...", 
                                     install_project_handler, 
                                     Swt::SWT::CASCADE,
                                     @menu, 
                                     @menu.indexOf(@open_project_item) +1 )

      @install_item.menu = Swt::Widgets::Menu.new( @menu )
      build_compass_framework_menuitem( @install_item.menu, install_project_handler )
      
      build_change_options_panel(@menu.indexOf(@install_item) +1 )

      @clean_item =  add_menu_item( "Clean && Compile", 
                                   clean_project_handler, 
                                   Swt::SWT::PUSH,
                                   @menu, 
                                   @menu.indexOf(@changeoptions_item) +1 )


      if @menu.items[ @menu.indexOf(@clean_item)+1 ].getStyle != Swt::SWT::SEPARATOR
        add_menu_separator(@menu, @menu.indexOf(@clean_item) + 1 )
      end
      @tray_item.image = @watching_icon


      return true

    end

    return false
  end

  def stop_watch
    if @compass_thread && @compass_thread.alive?
      @compass_thread[:watcher].stop
      @compass_thread.kill 
    end

    @compass_thread = nil
    @watch_item.text="Watch a Folder..."
    @open_project_item.dispose()   if @open_project_item && !@open_project_item.isDisposed
    @install_item.dispose() if @install_item && !@install_item.isDisposed
    @clean_item.dispose()   if @clean_item && !@clean_item.isDisposed
    @changeoptions_item.dispose()   if @changeoptions_item && !@changeoptions_item.isDisposed
    @watching_dir = nil
    @tray_item.image = @standby_icon
    SimpleLivereload.instance.unwatch
    SimpleHTTPServer.instance.stop
    FSEvent.stop_all_instances if Object.const_defined?("FSEvent") && FSEvent.methods.map{|x| x.to_sym}.include?(:stop_all_instances)
  end

end

