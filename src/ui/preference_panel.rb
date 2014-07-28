require 'singleton'

class PreferencePanel
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
  end

  def create_window
    @shell = Swt::Widgets::Shell.new(@display, Swt::SWT::DIALOG_TRIM)
    @shell.setText("Preference")
    @shell.setBackgroundMode(Swt::SWT::INHERIT_DEFAULT)
    @shell.setSize(550,300)
    @shell.layout = Swt::Layout::FillLayout.new

    @tabFolder = Swt::Widgets::TabFolder.new(@shell, Swt::SWT::BORDER);

    compass_version_tab = Swt::Widgets::TabItem.new( @tabFolder, Swt::SWT::NONE)
    compass_version_tab.setControl( self.compass_version_composite );
    compass_version_tab.setText('Compass')

    notification_tab = Swt::Widgets::TabItem.new( @tabFolder, Swt::SWT::NONE)
    notification_tab.setControl( self.notification_composite );
    notification_tab.setText('Notification')

    http_server_tab = Swt::Widgets::TabItem.new( @tabFolder, Swt::SWT::NONE)
    http_server_tab.setControl( self.services_composite );
    http_server_tab.setText('Services')

    history_tab = Swt::Widgets::TabItem.new( @tabFolder, Swt::SWT::NONE)
    history_tab.setControl( self.history_composite );
    history_tab.setText('History')

    @shell.pack
  end

  def history_composite
    composite =Swt::Widgets::Composite.new(@tabFolder, Swt::SWT::NO_MERGE_PAINTS );
    layout = Swt::Layout::GridLayout.new(1,true);
    composite.layout = layout
    
    label = Swt::Widgets::Label.new( composite, Swt::SWT::LEFT | Swt::SWT::WRAP)
    label.setText("We will list the last 10 folders in the history.\nIf you want to clean it, please click the button below.")

    clear_history_button = Swt::Widgets::Button.new(composite, Swt::SWT::PUSH )
    clear_history_button.setLayoutData( Swt::Layout::GridData.new(Swt::SWT::TOP, Swt::SWT::LEFT , false, false, 0, 0) )
    
    clear_history_button.text = "Clear History"
    clear_history_button.addListener(Swt::SWT::Selection, Swt::Widgets::Listener.impl do |method, evt| 
      Tray.instance.clear_history
      App.alert('done')
    end)
    composite
  end

  def services_composite
    composite =Swt::Widgets::Composite.new(@tabFolder, Swt::SWT::NO_MERGE_PAINTS );
    layout = Swt::Layout::FormLayout.new
    layout.marginWidth = layout.marginHeight = 10
    layout.spacing = 0
    composite.layout = layout
    
    # ====== web server =====
    @service_http_button = Swt::Widgets::Button.new(composite, Swt::SWT::CHECK )
    @service_http_button.setText( 'Enable Web Server' )
    @service_http_button.setSelection( App::CONFIG["services"].include? :http )
    @service_http_button.addListener(Swt::SWT::Selection, services_button_handler)

    layoutdata = Swt::Layout::FormData.new()
    layoutdata.left = Swt::Layout::FormAttachment.new( @service_http_button, 10, Swt::SWT::LEFT )
    layoutdata.top  = Swt::Layout::FormAttachment.new( @service_http_button, 10, Swt::SWT::BOTTOM)
    http_port_label = Swt::Widgets::Label.new( composite, Swt::SWT::LEFT | Swt::SWT::WRAP)
    http_port_label.setText("http://127.0.0.1:")
    http_port_label.setLayoutData(layoutdata)


    layoutdata = Swt::Layout::FormData.new(50, Swt::SWT::DEFAULT)
    layoutdata.left = Swt::Layout::FormAttachment.new( http_port_label, 1, Swt::SWT::RIGHT)
    layoutdata.top  = Swt::Layout::FormAttachment.new( http_port_label, 0, Swt::SWT::CENTER)
    @http_port_text  = Swt::Widgets::Text.new(composite, Swt::SWT::BORDER)
    @http_port_text.setText( App::CONFIG["services_http_port"].to_s )
    @http_port_text.setLayoutData( layoutdata )
    @http_port_text.addListener(Swt::SWT::Modify, services_port_handler)

    layoutdata = Swt::Layout::FormData.new(480, Swt::SWT::DEFAULT)
    layoutdata.left = Swt::Layout::FormAttachment.new( http_port_label, 0, Swt::SWT::LEFT )
    layoutdata.top  = Swt::Layout::FormAttachment.new( http_port_label, 10, Swt::SWT::BOTTOM)
    http_service_info = Swt::Widgets::Label.new( composite, Swt::SWT::LEFT | Swt::SWT::WRAP)
    http_service_info.setText("It will run a tiny web server when you watch a folder, so you can use absolute path in your files.")
    http_service_info.setLayoutData(layoutdata)

    # ====== livereload server =====
    layoutdata = Swt::Layout::FormData.new()
    layoutdata.left = Swt::Layout::FormAttachment.new( @service_http_button, 0, Swt::SWT::LEFT )
    layoutdata.top  = Swt::Layout::FormAttachment.new( http_service_info, 10, Swt::SWT::BOTTOM)
    @service_livereload_button = Swt::Widgets::Button.new(composite, Swt::SWT::CHECK )
    @service_livereload_button.setText( 'Enable livereload' )
    @service_livereload_button.setSelection( App::CONFIG["services"].include? :livereload )
    @service_livereload_button.addListener(Swt::SWT::Selection, services_button_handler)
    @service_livereload_button.setLayoutData(layoutdata)

    layoutdata = Swt::Layout::FormData.new()
    layoutdata.left = Swt::Layout::FormAttachment.new( @service_livereload_button, 10, Swt::SWT::LEFT )
    layoutdata.top  = Swt::Layout::FormAttachment.new( @service_livereload_button, 10, Swt::SWT::BOTTOM)
    livereload_port_label = Swt::Widgets::Label.new( composite, Swt::SWT::LEFT | Swt::SWT::WRAP)
    livereload_port_label.setText("Port")
    livereload_port_label.setLayoutData(layoutdata)


    layoutdata = Swt::Layout::FormData.new(50, Swt::SWT::DEFAULT)
    layoutdata.left = Swt::Layout::FormAttachment.new( livereload_port_label, 3, Swt::SWT::RIGHT)
    layoutdata.top = Swt::Layout::FormAttachment.new(  livereload_port_label, 0, Swt::SWT::CENTER)
    @livereload_port_text = Swt::Widgets::Text.new(composite, Swt::SWT::BORDER)
    @livereload_port_text.setText( App::CONFIG["services_livereload_port"].to_s )
    @livereload_port_text.setLayoutData( layoutdata )
    @livereload_port_text.addListener(Swt::SWT::Modify, services_port_handler)
    
    layoutdata = Swt::Layout::FormData.new()
    layoutdata.left = Swt::Layout::FormAttachment.new( livereload_port_label, 0, Swt::SWT::LEFT )
    layoutdata.top  = Swt::Layout::FormAttachment.new( livereload_port_label, 10, Swt::SWT::BOTTOM)
    livereload_extensions_label = Swt::Widgets::Label.new( composite, Swt::SWT::LEFT | Swt::SWT::WRAP)
    livereload_extensions_label.setText("File extensions to monitor")
    livereload_extensions_label.setLayoutData(layoutdata)


    layoutdata = Swt::Layout::FormData.new(250, Swt::SWT::DEFAULT)
    layoutdata.left = Swt::Layout::FormAttachment.new( livereload_extensions_label, 3, Swt::SWT::RIGHT)
    layoutdata.top = Swt::Layout::FormAttachment.new(  livereload_extensions_label, 0, Swt::SWT::CENTER)
    @livereload_extensions_text = Swt::Widgets::Text.new(composite, Swt::SWT::BORDER)
    @livereload_extensions_text.setText( App::CONFIG["services_livereload_extensions"].to_s )
    @livereload_extensions_text.setLayoutData( layoutdata )
    @livereload_extensions_text.addListener(Swt::SWT::Modify, services_extensions_handler)

    layoutdata = Swt::Layout::FormData.new(480, Swt::SWT::DEFAULT)
    layoutdata.left = Swt::Layout::FormAttachment.new( livereload_extensions_label, 0, Swt::SWT::LEFT )
    layoutdata.top  = Swt::Layout::FormAttachment.new( livereload_extensions_label, 10, Swt::SWT::BOTTOM)
    livereload_service_info = Swt::Widgets::Link.new( composite, Swt::SWT::LEFT | Swt::SWT::WRAP)
    livereload_service_info.setText("livereload applies CSS/JS Changes to browsers without reloading the page, and auto reloads the page when HTML changes")
    livereload_service_info.setLayoutData(layoutdata)
    livereload_service_info.addListener(Swt::SWT::Selection, Swt::Widgets::Listener.impl do |method, evt| 
       Swt::Program.launch(evt.text)
    end)
    
    layoutdata = Swt::Layout::FormData.new(480, Swt::SWT::DEFAULT)
    layoutdata.left = Swt::Layout::FormAttachment.new( livereload_service_info, 0, Swt::SWT::LEFT )
    layoutdata.top  = Swt::Layout::FormAttachment.new( livereload_service_info, 00, Swt::SWT::BOTTOM)
    livereload_service_help_info = Swt::Widgets::Link.new( composite, Swt::SWT::LEFT | Swt::SWT::WRAP)
    livereload_service_help_info.setText("You have to install <a href=\"https://github.com/kkbox/CompassApp/wiki/Preferences\">livereload browser extension or use livereload-js</a> to use this feature.")
    livereload_service_help_info.setLayoutData(layoutdata)
    livereload_service_help_info.addListener(Swt::SWT::Selection, Swt::Widgets::Listener.impl do |method, evt| 
       Swt::Program.launch(evt.text)
    end)
     return composite
  end

  def services_button_handler 
    Swt::Widgets::Listener.impl do |method, evt|   
      App::CONFIG["services"] = []
      App::CONFIG["services"] << :http if @service_http_button.getSelection       
      App::CONFIG["services"] << :livereload if @service_livereload_button.getSelection       
      App.save_config
      Tray.instance.rewatch
    end
  end

  def services_port_handler 
    Swt::Widgets::Listener.impl do |method, evt|   
      has_change = false
      port = @http_port_text.getText.to_i
      port = port.to_i
      if port < 0 || port > 65535 
        App.alert("http port number should be intergers between 0 and 65535")
      else
       
        if App::CONFIG['services_http_port'] != port
          App::CONFIG['services_http_port'] = port
          @http_port_text.setText(App::CONFIG['services_http_port'].to_s)
          has_change = true 
        end
      end

      port = @livereload_port_text.getText.to_i
      port = port.to_i
      if port < 0 || port > 65535 
        App.alert("livereload port number should be intergers between 0 and 65535")
      else

        if App::CONFIG['services_livereload_port'] != port
          App::CONFIG['services_livereload_port'] = port
          @livereload_port_text.setText(App::CONFIG['services_livereload_port'].to_s)
          has_change = true 
        end

        if has_change
          App.save_config
          Tray.instance.rewatch
        end
      end
    end
  end

  def services_extensions_handler
    Swt::Widgets::Listener.impl do |method, evt|  
      
      extensions = @livereload_extensions_text.getText.split(/,/).map!{|x| x.strip }.join(',')
      if extensions != App::CONFIG["services_livereload_extensions"]
        App::CONFIG["services_livereload_extensions"] = extensions
        App.save_config
        Tray.instance.rewatch
      end
    end
  end

  def notification_composite
    composite =Swt::Widgets::Composite.new(@tabFolder, Swt::SWT::NO_MERGE_PAINTS );
    layout = Swt::Layout::FormLayout.new
    layout.marginWidth = layout.marginHeight = 10
    layout.spacing = 0
    composite.layout = layout

    label = Swt::Widgets::Label.new( composite, Swt::SWT::LEFT | Swt::SWT::WRAP)
    label.setText('Notification Types')

    layoutdata = Swt::Layout::FormData.new()
    layoutdata.left = Swt::Layout::FormAttachment.new( label, 10, Swt::SWT::LEFT)
    layoutdata.top = Swt::Layout::FormAttachment.new( label,  5, Swt::SWT::BOTTOM)
    button_group =Swt::Widgets::Composite.new( composite, Swt::SWT::NO_MERGE_PAINTS );
    button_group.setLayoutData( layoutdata )
    layout = Swt::Layout::RowLayout.new(Swt::SWT::VERTICAL) 
    layout.spacing = 10
    button_group.setLayout( layout );

    @notification_error_button = Swt::Widgets::Button.new(button_group, Swt::SWT::CHECK )
    @notification_error_button.setText( 'Errors and Warnings' )
    @notification_error_button.setSelection( App::CONFIG["notifications"].include?( :error ) )
    @notification_error_button.addListener( Swt::SWT::Selection, notification_button_handler )

    @notification_change_button = Swt::Widgets::Button.new(button_group, Swt::SWT::CHECK )
    @notification_change_button.setText( 'Other Change ( create, update, ...)' )
    @notification_change_button.setSelection(App::CONFIG["notifications"].include?( :directory ))
    @notification_change_button.addListener(Swt::SWT::Selection, notification_button_handler)


    layoutdata = Swt::Layout::FormData.new(480,Swt::SWT::DEFAULT)
    layoutdata.left = Swt::Layout::FormAttachment.new( label, 0, Swt::SWT::LEFT)
    layoutdata.top = Swt::Layout::FormAttachment.new( button_group,  20, Swt::SWT::BOTTOM)
    label = Swt::Widgets::Label.new( composite, Swt::SWT::LEFT | Swt::SWT::WRAP)
    label.setText('Log File')
    label.setLayoutData(layoutdata)
    layoutdata = Swt::Layout::FormData.new(480,Swt::SWT::DEFAULT)
    layoutdata.left = Swt::Layout::FormAttachment.new( label, 14, Swt::SWT::LEFT)
    layoutdata.top = Swt::Layout::FormAttachment.new(  label,  5, Swt::SWT::BOTTOM)
    @log_notifaction_button = Swt::Widgets::Button.new(composite, Swt::SWT::CHECK )
    @log_notifaction_button.setLayoutData( layoutdata )
    @log_notifaction_button.setText( "Generate compass_app_log.txt in the project folder" )
    @log_notifaction_button.setSelection( App::CONFIG["save_notification_to_file"] )
    @log_notifaction_button.addListener(Swt::SWT::Selection, notification_button_handler)


    return  composite
  end

  def notification_button_handler 
    Swt::Widgets::Listener.impl do |method, evt|   
      notifications = []
      if @notification_error_button.getSelection 
        notifications += [ :error, :warnings ]
      end
      if @notification_change_button.getSelection 
        notifications += [ :directory, :remove, :create, :overwrite, :compile, :identical ]
      end
      App::CONFIG["notifications"] = notifications
      App::CONFIG['save_notification_to_file'] = @log_notifaction_button.getSelection
      App.save_config

    end
  end

  def compass_version_composite()
    composite =Swt::Widgets::Composite.new(@tabFolder, Swt::SWT::NO_MERGE_PAINTS );
    layout = Swt::Layout::FormLayout.new
    layout.marginWidth = layout.marginHeight = 10
    layout.marginLeft = 19
    layout.spacing = 0
    composite.layout = layout
  
    # ===== Preferred Syntax =====
    preferred_syntax_label = Swt::Widgets::Label.new( composite, Swt::SWT::LEFT | Swt::SWT::WRAP)
    data = Swt::Layout::FormData.new( )
    preferred_syntax_label.setLayoutData(data)
    preferred_syntax_label.setText("Preferred Syntax:")

    button_group =Swt::Widgets::Composite.new(composite, Swt::SWT::NO_MERGE_PAINTS );
    data = Swt::Layout::FormData.new(370,Swt::SWT::DEFAULT)
    data.left = Swt::Layout::FormAttachment.new( preferred_syntax_label, 5, Swt::SWT::RIGHT)
    data.top = Swt::Layout::FormAttachment.new(  preferred_syntax_label, 0, Swt::SWT::TOP)
    button_group.setLayoutData( data )

    rowlayout = Swt::Layout::RowLayout.new(Swt::SWT::VERTICAL) 
    rowlayout.marginBottom = 0;
    rowlayout.marginTop = 0;
    rowlayout.spacing = 6;
    button_group.setLayout( rowlayout );

    @button_preffered_scss = Swt::Widgets::Button.new(button_group, Swt::SWT::RADIO )
    @button_preffered_scss.setText("SCSS")
    @button_preffered_scss.setSelection( App::CONFIG['preferred_syntax'] == "scss" )
    @button_preffered_scss.addListener(Swt::SWT::Selection, preferred_syntax_button_handler)
    @button_preffered_sass = Swt::Widgets::Button.new(button_group, Swt::SWT::RADIO )
    @button_preffered_sass.setText("Sass (indented syntax)")
    @button_preffered_sass.setSelection( App::CONFIG['preferred_syntax'] == "sass" )
    @button_preffered_sass.addListener(Swt::SWT::Selection, preferred_syntax_button_handler)



    # ===== Compass Version =====
    
    compass_version_label = Swt::Widgets::Label.new( composite, Swt::SWT::LEFT | Swt::SWT::WRAP)
    compass_version_label.setText("Compass Version:")
    data = Swt::Layout::FormData.new()
    data.right = Swt::Layout::FormAttachment.new( preferred_syntax_label, 0, Swt::SWT::RIGHT)
    data.top = Swt::Layout::FormAttachment.new(  button_group, 18, Swt::SWT::BOTTOM)
    compass_version_label.setLayoutData( data )
   
    button_group =Swt::Widgets::Composite.new(composite, Swt::SWT::NO_MERGE_PAINTS );
    data = Swt::Layout::FormData.new(380,Swt::SWT::DEFAULT)
    data.left = Swt::Layout::FormAttachment.new( compass_version_label, 5, Swt::SWT::RIGHT)
    data.top = Swt::Layout::FormAttachment.new(  compass_version_label, 0, Swt::SWT::TOP)
    button_group.setLayoutData( data )

    rowlayout = Swt::Layout::RowLayout.new(Swt::SWT::VERTICAL) 
    rowlayout.marginBottom = 0;
    rowlayout.marginTop = 0;
    rowlayout.spacing = 6;
    button_group.setLayout( rowlayout );

    @button_version_default = Swt::Widgets::Button.new(button_group, Swt::SWT::RADIO )
    @button_version_default.setText("Default (Sass 3.3.10 + Compass 1.0.0.alpha.20)")
    @button_version_default.setSelection( App::CONFIG['use_version'] == 1.0 )
    @button_version_default.addListener(Swt::SWT::Selection, compass_version_button_handler)

    @use_specify_gem_path_btn = Swt::Widgets::Button.new(button_group, Swt::SWT::RADIO )
    @use_specify_gem_path_btn.setText("Custom (advanced users only)")
    @use_specify_gem_path_btn.setSelection(App::CONFIG['use_specify_gem_path'])
    @use_specify_gem_path_btn.addListener(Swt::SWT::Selection, compass_version_button_handler)


    special_gem_label = Swt::Widgets::Label.new( composite, Swt::SWT::LEFT | Swt::SWT::WRAP)
    special_gem_label.setText('You can use RubyGem to manage Compass and its extensions. Use "gem env path" command to find your gem paths.')
    special_gem_label.setLayoutData( simple_formdata(button_group, 22, 5, 320) )

    special_gem_label_ex = Swt::Widgets::Label.new( composite, Swt::SWT::LEFT | Swt::SWT::WRAP)
    special_gem_label_ex.setText("ex, /usr/local/lib/ruby/gems/1.8:/Users/foo/.gems")
    special_gem_label_ex.setLayoutData( simple_formdata(special_gem_label, 1, 8, 320) )


    @gem_path_text = Swt::Widgets::Text.new(composite, Swt::SWT::BORDER)
    @gem_path_text.setText(App::CONFIG['gem_path'] || '')
    @gem_path_text.setEnabled(@use_specify_gem_path_btn.getSelection)
    @gem_path_text.setLayoutData( simple_formdata( special_gem_label_ex, 0, 7, 320) )
    @gem_path_text.addListener(Swt::SWT::Modify, compass_version_button_handler)

    @use_specify_gem_path_btn.addListener(Swt::SWT::Selection,Swt::Widgets::Listener.impl do |method, evt|   
      @gem_path_text.setEnabled(evt.widget.getSelection)

    end)
    
    @apply_group =Swt::Widgets::Composite.new(composite, Swt::SWT::NO_MERGE_PAINTS );
    rowlayout = Swt::Layout::RowLayout.new(Swt::SWT::VERTICAL) 
    rowlayout.marginBottom = 0;
    rowlayout.spacing = 3;
    @apply_group.setLayout( rowlayout );
    @apply_group.setLayoutData( simple_formdata(@gem_path_text, -8, 6, 340) )
    @apply_group.setVisible(false)

    special_gem_label_ex = Swt::Widgets::Label.new( @apply_group, Swt::SWT::LEFT | Swt::SWT::WRAP)
    red = Swt::Graphics::Color.new(@display, 255, 0, 0);
    special_gem_label_ex.setForeground(red);
    special_gem_label_ex.setText(" You have to restart Commpass.app to apply this change")

    compass_version_apply_button = Swt::Widgets::Button.new(@apply_group, Swt::SWT::PUSH )
    compass_version_apply_button.setText("Apply Change")
    compass_version_apply_button.addListener(Swt::SWT::Selection,Swt::Widgets::Listener.impl do |method, evt|   
      if @button_version_default.getSelection
        App::CONFIG['use_version'] = 1.0
      else
        App::CONFIG['use_version'] = false
      end

      App::CONFIG['use_specify_gem_path']=@use_specify_gem_path_btn.getSelection
      App::CONFIG['gem_path']=@gem_path_text.getText
      App.save_config
      evt.widget.shell.dispose();
      Tray.instance.stop_watch
      java.lang.System.exit(0)
    end)


    return composite;
  end

  def preferred_syntax_button_handler
   Swt::Widgets::Listener.impl do |method, evt|   
      if @button_preffered_scss.getSelection
        App::CONFIG['preferred_syntax'] = "scss"
      else
        App::CONFIG['preferred_syntax'] = "sass"
      end 
      App.save_config
    end
  end

  def compass_version_button_handler 
    Swt::Widgets::Listener.impl do |method, evt|   
      if  ( @button_version_default.getSelection && App::CONFIG['use_version'] == 1.0 ) ||   
          ( @use_specify_gem_path_btn.getSelection && App::CONFIG['use_version'] == false &&
            App::CONFIG['gem_path'] == @gem_path_text.getText )
        @apply_group.setVisible(false)
      else
        @apply_group.setVisible(true)
      end 
    end
  end

  def simple_formdata( element, left=0, bottom=0, width=480)
    data = Swt::Layout::FormData.new(width,Swt::SWT::DEFAULT)
    data.left = Swt::Layout::FormAttachment.new( element, left, Swt::SWT::LEFT)
    data.top = Swt::Layout::FormAttachment.new( element, bottom, Swt::SWT::BOTTOM)
    data
  end
end
