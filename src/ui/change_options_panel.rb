require 'singleton'

class ChangeOptionsPanel
  include Singleton


  def initialize()
    @display = Swt::Widgets::Display.get_current
  end

  def open
    self.create_window if !@shell || @shell.isDisposed
    m=@display.getPrimaryMonitor().getBounds()
    rect = @shell.getClientArea()
    @shell.setLocation((m.width-rect.width) /2, (m.height-rect.height) /2) 
    @shell.open
    @shell.forceActive

    @isChanged = false
  end

  def close
    @shell.dispose if @shell and !@shell.isDisposed
  end

  def close
    @shell.dispose if @shell and !@shell.isDisposed
  end

  def config
    Tray.instance.compass_project_config
  end

  def create_window
    @shell = Swt::Widgets::Shell.new(@display, Swt::SWT::DIALOG_TRIM)
    @shell.setText("Change Options")
    @shell.setBackgroundMode(Swt::SWT::INHERIT_DEFAULT)
   
    layout = Swt::Layout::FormLayout.new
    layout.marginWidth = layout.marginHeight = 15
    @shell.layout = layout

    # -- panel title label --
    panel_title_label = Swt::Widgets::Label.new(@shell, Swt::SWT::LEFT)
    font_data=panel_title_label.getFont().getFontData()
    font_data.each do |fd|
      fd.setStyle(Swt::SWT::BOLD)
      fd.setHeight(14)
    end
    font=Swt::Graphics::Font.new(@display, font_data)
    panel_title_label.setFont(font)
    panel_title_label.setText("Project Options")
    layoutdata = Swt::Layout::FormData.new(800, Swt::SWT::DEFAULT)
    panel_title_label.setLayoutData( layoutdata )

    # -- horizontal separator --
    horizontal_separator = build_separator(panel_title_label)


    # -- context group --
    @general_group = build_general_group(horizontal_separator)
    @coffeescript_group = build_coffeescript_group(@general_group)
    @livescript_group = build_livescript_group(@coffeescript_group)
    @buildoption_group = build_buildoption_group(@livescript_group)

    # -- right --
    @sass_group = build_sass_group(@general_group)
    #@less_group = build_less_group(@sass_group)
    #@thehold_group = build_thehold_group(@less_group)

    horizontal_separator = build_separator(@buildoption_group)
    # -- control button --
    build_control_button(horizontal_separator)
    #build_control_button(@less_group)
    
    
    @shell.pack
  end

  def build_separator(align)
    horizontal_separator = Swt::Widgets::Label.new(@shell, Swt::SWT::SEPARATOR | Swt::SWT::HORIZONTAL)
    layoutdata = Swt::Layout::FormData.new(800, Swt::SWT::DEFAULT)
    layoutdata.left = Swt::Layout::FormAttachment.new( align, 0, Swt::SWT::LEFT )
    layoutdata.top  = Swt::Layout::FormAttachment.new( align, 10, Swt::SWT::BOTTOM)
    horizontal_separator.setLayoutData( layoutdata )
    horizontal_separator
  end

  def build_basic_group(text, align, to = 'bottom')
    group = Swt::Widgets::Group.new(@shell, Swt::SWT::SHADOW_ETCHED_OUT)
    group.setText(text)

    layoutdata = Swt::Layout::FormData.new(380, Swt::SWT::DEFAULT)
    if to == 'bottom'
      layoutdata.left = Swt::Layout::FormAttachment.new( align, 0, Swt::SWT::LEFT )
      layoutdata.top  = Swt::Layout::FormAttachment.new( align, 10, Swt::SWT::BOTTOM)
    elsif to == 'right'
      layoutdata.left = Swt::Layout::FormAttachment.new( align, 8, Swt::SWT::RIGHT )
      layoutdata.top  = Swt::Layout::FormAttachment.new( align, 0, Swt::SWT::TOP)
    end
    group.setLayoutData( layoutdata )

    layout = Swt::Layout::FormLayout.new
    layout.marginWidth = layout.marginHeight = 5
    group.setLayout( layout )
    group

  end

  def build_dir_label_on_general_group(group, text, align)
    dir_label = Swt::Widgets::Label.new(group, Swt::SWT::PUSH)
    layoutdata = Swt::Layout::FormData.new(120, Swt::SWT::DEFAULT)
    layoutdata.left = Swt::Layout::FormAttachment.new( align, 0, Swt::SWT::LEFT )
    layoutdata.top  = Swt::Layout::FormAttachment.new( align, 10, Swt::SWT::BOTTOM)
    dir_label.setLayoutData( layoutdata )
    dir_label.setText(text)
    dir_label.pack
    dir_label
  end

  def build_dir_text_on_general_group(group, text, align, size = 180)
    layoutdata = Swt::Layout::FormData.new(size, Swt::SWT::DEFAULT)
    layoutdata.left = Swt::Layout::FormAttachment.new( align, 1, Swt::SWT::RIGHT)
    layoutdata.top  = Swt::Layout::FormAttachment.new( align, 0, Swt::SWT::CENTER)
    dir_text  = Swt::Widgets::Text.new(group, Swt::SWT::BORDER)
    dir_text.setLayoutData( layoutdata )
    dir_text.setText( text ) if text
    dir_text.addListener(Swt::SWT::Modify, change_handler)
    dir_text
  end

  def build_select_button_on_general_group(group, swttext, align = nil)
    # -- dir button --
    align = swttext if align
    select_dir_btn = Swt::Widgets::Button.new(group, Swt::SWT::PUSH | Swt::SWT::CENTER)
    select_dir_btn.setText('Select')
    button_width = 70
    button_width = button_width - 10 if org.jruby.platform.Platform::IS_WINDOWS
    layoutdata = Swt::Layout::FormData.new(button_width, Swt::SWT::DEFAULT)
    layoutdata.left = Swt::Layout::FormAttachment.new( swttext, 1, Swt::SWT::RIGHT)
    layoutdata.top  = Swt::Layout::FormAttachment.new( swttext, 0, Swt::SWT::CENTER)
    select_dir_btn.setLayoutData( layoutdata )
    select_dir_btn.addListener(Swt::SWT::Selection, select_handler(swttext))
    select_dir_btn
  end

  def build_checkbox_button(group, text, selected, align = nil)
    layoutdata = Swt::Layout::FormData.new(350, Swt::SWT::DEFAULT)
    if align != nil
        layoutdata.left = Swt::Layout::FormAttachment.new( align, 0, Swt::SWT::LEFT )
        layoutdata.top  = Swt::Layout::FormAttachment.new( align, 10, Swt::SWT::BOTTOM)
    end
    checkbox_button = Swt::Widgets::Button.new(group, Swt::SWT::CHECK )
    checkbox_button.setText( text )
    checkbox_button.setLayoutData( layoutdata )
    checkbox_button.setSelection(true) if selected
    checkbox_button.addListener(Swt::SWT::Selection, change_handler)
    
    checkbox_button
  end

  def build_general_group(behind)
    group = build_basic_group('General', behind)

    # -- sass dir --
    sass_dir_label = build_dir_label_on_general_group(group, "Sass Folder", group)
    @sass_dir_text = build_dir_text_on_general_group(group, config.sass_dir, sass_dir_label)
    build_select_button_on_general_group(group, @sass_dir_text)

    # -- less dir --
    #less_dir_label = build_dir_label_on_general_group(group, "Less Dir:", sass_dir_label)
    #@less_dir_text = build_dir_text_on_general_group(group, config.fireapp_less_dir, less_dir_label)
    #build_select_button_on_general_group(group, @less_dir_text)

    # -- css dir --
    css_dir_label = build_dir_label_on_general_group(group, "CSS Folder", sass_dir_label)
    @css_dir_text = build_dir_text_on_general_group(group, config.css_dir, css_dir_label)
    build_select_button_on_general_group(group, @css_dir_text)

    # -- images dir --
    images_dir_label = build_dir_label_on_general_group(group, "Image Folder", css_dir_label)
    @images_dir_text = build_dir_text_on_general_group(group, config.images_dir, images_dir_label)
    build_select_button_on_general_group(group, @images_dir_text)

    # -- coffeescripts dir --
    coffeescripts_dir_label = build_dir_label_on_general_group(group, "CoffeeScript Folder", images_dir_label)
    @coffeescripts_dir_text = build_dir_text_on_general_group(group, config.fireapp_coffeescripts_dir, coffeescripts_dir_label)
    build_select_button_on_general_group(group, @coffeescripts_dir_text)

    # -- livescripts dir --
    livescripts_dir_label = build_dir_label_on_general_group(group, "LiveScript Folder", coffeescripts_dir_label)
    @livescripts_dir_text = build_dir_text_on_general_group(group, config.fireapp_livescripts_dir, livescripts_dir_label)
    build_select_button_on_general_group(group, @livescripts_dir_text)

    # -- javascripts dir --
    js_dir_label = build_dir_label_on_general_group(group, "JavaScript Folder", livescripts_dir_label)
    @js_dir_text = build_dir_text_on_general_group(group, config.javascripts_dir, js_dir_label)
    build_select_button_on_general_group(group, @js_dir_text)


    group.pack

    group
  end

  def build_sass_group(behind)
    group = build_basic_group('Sass', behind, 'right')

    # -- output style label -- 
    output_style_label = Swt::Widgets::Label.new(group, Swt::SWT::PUSH)
    output_style_label.setText("Output Style:")
    output_style_label.pack

    # -- output style combo --
    layoutdata = Swt::Layout::FormData.new(100, Swt::SWT::DEFAULT)
    layoutdata.left = Swt::Layout::FormAttachment.new( output_style_label, 1, Swt::SWT::RIGHT)
    layoutdata.top  = Swt::Layout::FormAttachment.new( output_style_label, 0, Swt::SWT::CENTER)
    @output_style_combo  = Swt::Widgets::Combo.new(group, Swt::SWT::DEFAULT)
    @output_style_combo.setLayoutData( layoutdata )
    %W{nested expanded compact compressed}.each do |output_style|
      @output_style_combo.add(output_style)
    end
    @output_style_combo.setText( config.output_style.to_s )
    @output_style_combo.addListener(Swt::SWT::Selection, change_handler)

    @relative_assets_button = build_checkbox_button(group, 'Relative Assets', config.relative_assets, output_style_label)

    # -- line comments checkbox --
    @line_comments_button = build_checkbox_button(group, 'Line Comments', config.line_comments, @relative_assets_button)

    # -- debug info checkbox --
    @debug_info_button = build_checkbox_button(group, 'Debug Info', config.sass_options && config.sass_options[:debug_info],  @line_comments_button)

    # -- disable on build checkbox --
    #@disable_linecomments_and_debuginfo_on_build_button = build_checkbox_button(group, 'Disable Line Comments ＆ Debug Info on Build', config.fireapp_disable_linecomments_and_debuginfo_on_build,  @debug_info_button)

    group.pack

    group
  end

  def build_buildoption_group(behind)
    group = build_basic_group('Build', behind)

    # -- minifyjs_on_build checkbox --
    @minifyjs_on_build_button = build_checkbox_button(group, 'Minify JavaScript (UgligyJS)', config.fireapp_minifyjs_on_build)

    # -- always_report_on_build checkbox --
    @always_report_on_build_button = build_checkbox_button(group, 'Report', config.fireapp_always_report_on_build,  @minifyjs_on_build_button)

    group.pack

    group
  end

  def build_coffeescript_group(behind)
    group = build_basic_group('CoffeeScript', behind)

    # -- bare checkbox --
    @coffeescripts_bare_button = build_checkbox_button(group, 'Bare', config.fireapp_coffeescript_options[:bare])

    group.pack

    group
  end

  def build_less_group(behind)
    group = build_basic_group('Less', behind)

    # -- checkbox --
    @less_compress_button = build_checkbox_button(group, 'Compress', config.fireapp_less_options[:yuicompress])
    #@less_verbose_button = build_checkbox_button(group, 'Verbose', config.fireapp_less_options[:verbose], @less_compress_button)
    #@less_color_button = build_checkbox_button(group, 'Color', config.fireapp_less_options[:color], @less_verbose_button)
    @less_ieCompat_button = build_checkbox_button(group, 'IE compatibility', config.fireapp_less_options[:ieCompat], @less_compress_button)
    #@less_strictImports_button = build_checkbox_button(group, 'Strict Imports', config.fireapp_less_options[:strictImports], @less_ieCompat_button)
    #@less_strictMath_button = build_checkbox_button(group, 'Strict Math', config.fireapp_less_options[:strictMath], @less_strictImports_button)
    #@less_strictUnits_button = build_checkbox_button(group, 'Strict Units', config.fireapp_less_options[:strictUnits], @less_strictMath_button)

    group.pack

    group
  end

  def build_livescript_group(behind)
    group = build_basic_group('LiveScript', behind)

    # -- bare checkbox --
    @livescripts_bare_button = build_checkbox_button(group, 'Bare', config.fireapp_livescript_options[:bare])

    group.pack

    group
  end

  def build_thehold_group(behind)
    group = build_basic_group('TheHold', behind)

    # -- api key label --
    api_key_label = Swt::Widgets::Label.new(group, Swt::SWT::PUSH)
    layoutdata = Swt::Layout::FormData.new(120, Swt::SWT::DEFAULT)
    api_key_label.setLayoutData( layoutdata )
    api_key_label.setText("Api Key:")
    api_key_label.pack

    # -- api key text --
    layoutdata = Swt::Layout::FormData.new(200, Swt::SWT::DEFAULT)
    layoutdata.left = Swt::Layout::FormAttachment.new( api_key_label, 1, Swt::SWT::RIGHT)
    layoutdata.top  = Swt::Layout::FormAttachment.new( api_key_label, 0, Swt::SWT::CENTER)
    @api_key_text  = Swt::Widgets::Text.new(group, Swt::SWT::BORDER)
    @api_key_text.setLayoutData( layoutdata )
    text = config.the_hold_options[:token]
    @api_key_text.setText( text ) if text
    @api_key_text.addListener(Swt::SWT::Modify, change_handler)

    # -- user name label --
    user_name_label = Swt::Widgets::Label.new(group, Swt::SWT::PUSH)
    layoutdata = Swt::Layout::FormData.new(120, Swt::SWT::DEFAULT)
    layoutdata.left = Swt::Layout::FormAttachment.new( api_key_label, 0, Swt::SWT::LEFT )
    layoutdata.top  = Swt::Layout::FormAttachment.new( api_key_label, 10, Swt::SWT::BOTTOM)
    user_name_label.setLayoutData( layoutdata )
    user_name_label.setText("User Name:")
    user_name_label.pack

    # -- user name text --
    layoutdata = Swt::Layout::FormData.new(200, Swt::SWT::DEFAULT)
    layoutdata.left = Swt::Layout::FormAttachment.new( user_name_label, 1, Swt::SWT::RIGHT)
    layoutdata.top  = Swt::Layout::FormAttachment.new( user_name_label, 0, Swt::SWT::CENTER)
    @user_name_text  = Swt::Widgets::Text.new(group, Swt::SWT::BORDER)
    @user_name_text.setLayoutData( layoutdata )
    text = config.the_hold_options[:login]
    @user_name_text.setText( text ) if text
    @user_name_text.addListener(Swt::SWT::Modify, change_handler)


    # -- project name label --
    project_name_label = Swt::Widgets::Label.new(group, Swt::SWT::PUSH)
    layoutdata = Swt::Layout::FormData.new(120, Swt::SWT::DEFAULT)
    layoutdata.left = Swt::Layout::FormAttachment.new( user_name_label, 0, Swt::SWT::LEFT )
    layoutdata.top  = Swt::Layout::FormAttachment.new( user_name_label, 10, Swt::SWT::BOTTOM)
    project_name_label.setLayoutData( layoutdata )
    project_name_label.setText("Project Name:")
    project_name_label.pack

    # -- project name text --
    layoutdata = Swt::Layout::FormData.new(200, Swt::SWT::DEFAULT)
    layoutdata.left = Swt::Layout::FormAttachment.new( project_name_label, 1, Swt::SWT::RIGHT)
    layoutdata.top  = Swt::Layout::FormAttachment.new( project_name_label, 0, Swt::SWT::CENTER)
    @project_name_text  = Swt::Widgets::Text.new(group, Swt::SWT::BORDER)
    @project_name_text.setLayoutData( layoutdata )
    text = config.the_hold_options[:project]
    @project_name_text.setText( text ) if text
    @project_name_text.addListener(Swt::SWT::Modify, change_handler)

    # -- project password label --
    project_password_label = Swt::Widgets::Label.new(group, Swt::SWT::PUSH)
    layoutdata = Swt::Layout::FormData.new(120, Swt::SWT::DEFAULT)
    layoutdata.left = Swt::Layout::FormAttachment.new( project_name_label, 0, Swt::SWT::LEFT )
    layoutdata.top  = Swt::Layout::FormAttachment.new( project_name_label, 10, Swt::SWT::BOTTOM)
    project_password_label.setLayoutData( layoutdata )
    project_password_label.setText("Project Password:")
    project_password_label.pack

    # -- project password text --
    layoutdata = Swt::Layout::FormData.new(200, Swt::SWT::DEFAULT)
    layoutdata.left = Swt::Layout::FormAttachment.new( project_password_label, 1, Swt::SWT::RIGHT)
    layoutdata.top  = Swt::Layout::FormAttachment.new( project_password_label, 0, Swt::SWT::CENTER)
    @project_password_text  = Swt::Widgets::Text.new(group, Swt::SWT::BORDER)
    @project_password_text.setLayoutData( layoutdata )
    text = config.the_hold_options[:project_site_password]
    @project_password_text.setText( text ) if text
    @project_password_text.addListener(Swt::SWT::Modify, change_handler)

    # -- project host label --
    project_host_label = Swt::Widgets::Label.new(group, Swt::SWT::PUSH)
    layoutdata = Swt::Layout::FormData.new(120, Swt::SWT::DEFAULT)
    layoutdata.left = Swt::Layout::FormAttachment.new( project_password_label, 0, Swt::SWT::LEFT )
    layoutdata.top  = Swt::Layout::FormAttachment.new( project_password_label, 10, Swt::SWT::BOTTOM)
    project_host_label.setLayoutData( layoutdata )
    project_host_label.setText("Host:")
    project_host_label.pack

    # -- project host text --
    layoutdata = Swt::Layout::FormData.new(200, Swt::SWT::DEFAULT)
    layoutdata.left = Swt::Layout::FormAttachment.new( project_host_label, 1, Swt::SWT::RIGHT)
    layoutdata.top  = Swt::Layout::FormAttachment.new( project_host_label, 0, Swt::SWT::CENTER)
    @project_host_text  = Swt::Widgets::Text.new(group, Swt::SWT::BORDER)
    @project_host_text.setLayoutData( layoutdata )
    text = config.the_hold_options[:host]
    @project_host_text.setText( text ) if text
    @project_host_text.addListener(Swt::SWT::Modify, change_handler)

    group.pack

    group
  end

  def build_control_button(behind)

    button_width = 90
    button_width = button_width - 10 if org.jruby.platform.Platform::IS_WINDOWS

    # -- save button --
    save_btn = Swt::Widgets::Button.new(@shell, Swt::SWT::PUSH | Swt::SWT::CENTER)
    save_btn.setText('Save')
    layoutdata = Swt::Layout::FormData.new(button_width, Swt::SWT::DEFAULT)
    layoutdata.right = Swt::Layout::FormAttachment.new( behind, 0, Swt::SWT::RIGHT)
    layoutdata.top  = Swt::Layout::FormAttachment.new( behind, 10, Swt::SWT::BOTTOM)
    save_btn.setLayoutData( layoutdata )
    save_btn.addListener(Swt::SWT::Selection, save_handler)
    save_btn.pack

    # -- cancel button --
    cancel_btn = Swt::Widgets::Button.new(@shell, Swt::SWT::PUSH | Swt::SWT::CENTER)
    cancel_btn.setText('Cancel')
    layoutdata = Swt::Layout::FormData.new(button_width, Swt::SWT::DEFAULT)
    layoutdata.right = Swt::Layout::FormAttachment.new( save_btn, 5, Swt::SWT::LEFT)
    layoutdata.right = Swt::Layout::FormAttachment.new( save_btn, -5, Swt::SWT::LEFT) if org.jruby.platform.Platform::IS_WINDOWS
    layoutdata.top  = Swt::Layout::FormAttachment.new( save_btn, 0, Swt::SWT::CENTER)
    cancel_btn.setLayoutData( layoutdata )
    cancel_btn.addListener(Swt::SWT::Selection, cancel_handler)
    cancel_btn.pack
  end


  def change_handler
    Swt::Widgets::Listener.impl do |method, evt|   
      @isChanged = true
    end
  end

  def cancel_handler
    Swt::Widgets::Listener.impl do |method, evt|   
      close
    end
  end

  def select_handler(swttext)
    Swt::Widgets::Listener.impl do |method, evt|   
      dia = Swt::Widgets::DirectoryDialog.new(@shell)
      dia.setFilterPath(Tray.instance.watching_dir)
      dir = dia.open
      dir_path = Pathname.new(dir) if !dir.nil? 
      watching_dir_path = Pathname.new(Tray.instance.watching_dir)

      if dir.nil? || dir_path.realpath == watching_dir_path.realpath then
        nil
      elsif !dir_path.relative_path_from(watching_dir_path).to_s.split('/').include?('..') 
        swttext.setText(dir_path.relative_path_from(watching_dir_path).to_s) 
        swttext.forceFocus
      else
        App.alert("Can't use this folder.")
      end
    end
  end

  def save_handler
    Swt::Widgets::Listener.impl do |method, evt|
      evt.widget.shell.setVisible( false )

      #App.alert("Already stop watch project") Tray.instance.watching_dir
      #evt.widget.shell.dispose if Tray.instance.watching_dir

      if @isChanged
        msg_window = ProgressWindow.new
        msg_window.replace('Regenerating...', false, true)

        # -- update general --
        # Tray.instance.update_config( "http_path", @http_path_text.getText.inspect )
        Tray.instance.update_config( "css_dir", @css_dir_text.getText.inspect )
        Tray.instance.update_config( "sass_dir", @sass_dir_text.getText.inspect )
        Tray.instance.update_config( "images_dir", @images_dir_text.getText.inspect )
        Tray.instance.update_config( "javascripts_dir", @js_dir_text.getText.inspect )
        Tray.instance.update_config( "fireapp_coffeescripts_dir", @coffeescripts_dir_text.getText.inspect )
        Tray.instance.update_config( "fireapp_livescripts_dir", @livescripts_dir_text.getText.inspect )
        Tray.instance.update_config( "fireapp_minifyjs_on_build", @minifyjs_on_build_button.getSelection )
        Tray.instance.update_config( "fireapp_always_report_on_build", @always_report_on_build_button.getSelection )
        # Tray.instance.update_config( "fireapp_less_dir", @less_dir_text.getText.inspect )

        
        # -- update output style --
        Tray.instance.update_config( "output_style", ":"+@output_style_combo.getItem(@output_style_combo.getSelectionIndex).to_s )

        # -- relative_assets --
        Tray.instance.update_config( "relative_assets", @relative_assets_button.getSelection )

        # -- update line comments --
        Tray.instance.update_config( "line_comments", @line_comments_button.getSelection )

        # -- update sass options --
        sass_options = config.sass_options
        sass_options = {} if !sass_options.is_a? Hash
        sass_options[:debug_info] = @debug_info_button.getSelection
        Tray.instance.update_config( "sass_options", sass_options.inspect )

        # -- update less options --
        #less_options = config.fireapp_less_options
        #less_options = {} if !sass_options.is_a? Hash
        #less_options[:yuicompress] = @less_compress_button.getSelection
        #less_options[:ieCompat] = @less_ieCompat_button.getSelection
        #Tray.instance.update_config( "fireapp_less_options", less_options.inspect )

        #   -- other less options --
        #less_options[:verbose] = @less_verbose_button.getSelection
        #less_options[:color] = @less_color_button.getSelection
        #less_options[:strictImports] = @less_strictImports_button.getSelection
        #less_options[:strictMath] = @less_strictMath_button.getSelection
        #less_options[:strictUnits] = @less_strictUnits_button.getSelection

        # -- disable line comments & debug info--
        #Tray.instance.update_config( "fireapp_disable_linecomments_and_debuginfo_on_build", @disable_linecomments_and_debuginfo_on_build_button.getSelection )
      

        # -- update coffeescript bare -- 
        fireapp_coffeescript_options = config.fireapp_coffeescript_options
        fireapp_coffeescript_options.update({:bare => @coffeescripts_bare_button.getSelection })
        Tray.instance.update_config( "fireapp_coffeescript_options", fireapp_coffeescript_options.inspect)

        # -- update livescript bare -- 
        fireapp_livescript_options = config.fireapp_livescript_options
        fireapp_livescript_options.update({:bare => @livescripts_bare_button.getSelection })
        Tray.instance.update_config( "fireapp_livescript_options", fireapp_livescript_options.inspect)


        # -- update the_hold bare -- 
        #the_hold_options = config.the_hold_options
        #the_hold_options.update({
        #  :login => @user_name_text.getText,
        #  :token => @api_key_text.getText,
        #  :project => @project_name_text.getText,
        #  :project_site_password => @project_password_text.getText,
        #  :host => @project_host_text.getText
        #})
        #Tray.instance.update_config( "the_hold_options", the_hold_options.inspect)

        # Compass::Commands::CleanProject.new(Tray.instance.watching_dir, {}).perform
        Tray.instance.clean_project

        msg_window.dispose
      end

      close
    end
  end

  

end
