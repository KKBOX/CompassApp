class Tray
  def initialize()
    @compass_thread = nil
    @watching_dir = nil
    @history_dirs  = App.get_history
    @shell    = App.create_shell(Swt::SWT::ON_TOP | Swt::SWT::MODELESS)
    tray = App.display.system_tray
    item = Swt::Widgets::TrayItem.new(tray, Swt::SWT::NONE)
    item.image = App.create_image("icon/16_dark.png")
    item.tool_tip_text = "Compass.app"
    item.addListener(Swt::SWT::Selection,  update_menu_position_handler) unless org.jruby.platform.Platform::IS_MAC
    item.addListener(Swt::SWT::MenuDetect, update_menu_position_handler)

    @menu = Swt::Widgets::Menu.new(@shell, Swt::SWT::POP_UP)
    
    add_menu_item( "Watch a Folder...", open_dir_handler)
    add_menu_separator

    add_menu_item( "History:")
    
    @history_dirs.reverse.each do | dir |
      add_compass_item(dir)
    end

    add_menu_separator

    item =  add_menu_item( "Create Compass Project", create_project_handler, Swt::SWT::CASCADE)

    item.menu = Swt::Widgets::Menu.new( @menu )
    build_compass_framework_menuitem( item.menu, create_project_handler )
    
    item =  add_menu_item( "Preference...", preference_handler, Swt::SWT::PUSH)

    item =  add_menu_item( "About", open_about_link_handler, Swt::SWT::CASCADE)
    item.menu = Swt::Widgets::Menu.new( @menu )
    add_menu_item( 'Homepage',                      open_about_link_handler,   Swt::SWT::PUSH, item.menu)
    add_menu_item( 'Compass v.' + Compass::VERSION, open_compass_link_handler, Swt::SWT::PUSH, item.menu)
    add_menu_item( 'Sass v.' + Sass::VERSION,       open_sass_link_handler,    Swt::SWT::PUSH, item.menu)
    add_menu_separator( item.menu )
    
    add_menu_item( "App Version: #{App.version}",                          nil, Swt::SWT::PUSH, item.menu)
    add_menu_item( App.compile_version, nil, Swt::SWT::PUSH, item.menu)

    add_menu_item( "Quit",      exit_handler)
  end

  def run
    while(!@shell.is_disposed) do
      App.display.sleep if(!App.display.read_and_dispatch) 
    end

    App.display.dispose

  end


  private 
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
      index =0
      @menu.items.each_with_index do | item, index |
	break if item.text =~ /History/
      end
      menuitem = Swt::Widgets::MenuItem.new(@menu , Swt::SWT::PUSH, index+1)
      menuitem.text = "#{dir}"
      menuitem.addListener(Swt::SWT::Selection, compass_switch_handler)
      menuitem
    end
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
        dia = Swt::Widgets::DirectoryDialog.new(@shell)
        dir = dia.open
        watch(dir) if dir 
      end
    end
  end

  def build_compass_framework_menuitem( submenu, handler )
    Compass::Frameworks::ALL.each do | framework |
      next if framework.name =~ /^_/
      item = add_menu_item( framework.name, handler, Swt::SWT::CASCADE, submenu)
      framework_submenu = Swt::Widgets::Menu.new( submenu )
      item.menu = framework_submenu
      framework.template_directories.each do | dir |
        add_menu_item( dir, handler, Swt::SWT::PUSH, framework_submenu)
      end
    end
  end

  def create_project_handler
    Swt::Widgets::Listener.impl do |method, evt|
      dia = Swt::Widgets::FileDialog.new(@shell,Swt::SWT::SAVE)
      dir = dia.open
      if dir
        
        # if select a pattern
        if Compass::Frameworks::ALL.any?{ | f| f.name == evt.widget.getParent.getParentItem.text }
          framework = evt.widget.getParent.getParentItem.text
          pattern = evt.widget.text
        else
          framework = evt.widget.txt
          pattern = 'project'
        end
        
        App.try do 
          actual = App.get_stdout do
            Compass::Commands::CreateProject.new( dir, {:framework => framework, :pattern => pattern } ).execute
          end
          App.report( actual)
        end

        watch(dir)
      end
    end
  end
 
  def install_project_handler
    Swt::Widgets::Listener.impl do |method, evt|
        # if select a pattern
        if Compass::Frameworks::ALL.any?{ | f| f.name == evt.widget.getParent.getParentItem.text }
          framework = evt.widget.getParent.getParentItem.text
          pattern = evt.widget.text
        else
          framework = evt.widget.txt
          pattern = 'project'
        end

        App.try do 
          actual = App.get_stdout do
            Compass::Commands::StampPattern.new( @watching_dir, {:framework => framework, :pattern => pattern } ).execute
          end
          App.report( actual)
        end

      end
  end

  def preference_handler 
    Swt::Widgets::Listener.impl do |method, evt|
      PreferencePanel.instance.open
    end
  end

  def open_about_link_handler 
    Swt::Widgets::Listener.impl do |method, evt|
      Swt::Program.launch('http://compass.handlino.com')
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
  
  def exit_handler
    Swt::Widgets::Listener.impl do |method, evt|
      App.set_histoy(@history_dirs[0,10])
      @shell.close
    end
  end

  def update_menu_position_handler 
    Swt::Widgets::Listener.impl do |method, evt|
      @menu.visible = true
    end
  end

  def watch(dir)
    App.try do 
      x = Compass::Commands::UpdateProject.new( dir, {})
      if !x.new_compiler_instance.sass_files.empty?
        stop_watch
        current_display = App.display
        @compass_thread = Thread.new do
          Compass::Commands::WatchProject.new( dir, { :logger => Compass::Logger.new({ :display => current_display,
                                                                                     :log_dir => dir}) }).execute
        end
        @watching_dir = dir
        @history_dirs.delete_if { |x| x == dir }
        @history_dirs.unshift(dir)
        @menu.items.each do |item|
          item.dispose if item.text == dir 
        end
        menuitem = add_compass_item(dir)

        @menu.items[0].text="Watching " + dir

        item =  add_menu_item( "Install Compass Project", install_project_handler, Swt::SWT::CASCADE, @menu, 1)
        item.menu = Swt::Widgets::Menu.new( @menu )
        build_compass_framework_menuitem( item.menu, install_project_handler )
        add_menu_separator(@menu, 2) if @menu.items[2].getStyle != Swt::SWT::SEPARATOR
        return true

      else
        App.notify( dir +' Not A Compass Directory')
      end
    end

    return false
  end

  def stop_watch
    @compass_thread.kill if @compass_thread && @compass_thread.alive?
    @compass_thread = nil
    @menu.items[0].text="Watch a Folder..."
    @menu.items[1].dispose()
    @watching_dir = nil
  end

end

