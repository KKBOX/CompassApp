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
    @shell.setText("Compass.app Preference")
    @shell.setBackgroundMode(Swt::SWT::INHERIT_DEFAULT)
    @shell.setSize(550,300)
    @shell.layout = Swt::Layout::FillLayout.new

    @tabFolder = Swt::Widgets::TabFolder.new(@shell, Swt::SWT::BORDER);

    compass_version_tab = Swt::Widgets::TabItem.new( @tabFolder, Swt::SWT::NONE)
    compass_version_tab.setControl( self.compass_version_composite );
    compass_version_tab.setText('Compass version')

    notification_tab = Swt::Widgets::TabItem.new( @tabFolder, Swt::SWT::NONE)
    notification_tab.setControl( self.notification_composite );
    notification_tab.setText('Notification')

    http_server_tab = Swt::Widgets::TabItem.new( @tabFolder, Swt::SWT::NONE)
    http_server_tab.setControl( self.services_composite );
    http_server_tab.setText('Optional services')

    @shell.pack
  end

  def services_composite
    composite =Swt::Widgets::Composite.new(@tabFolder, Swt::SWT::NO_MERGE_PAINTS );
    layout = Swt::Layout::FormLayout.new
    layout.marginWidth = layout.marginHeight = 10
    layout.spacing = 0
    composite.layout = layout

    label = Swt::Widgets::Label.new( composite, Swt::SWT::LEFT | Swt::SWT::WRAP)
    label.setText('Services')

    button_group =Swt::Widgets::Composite.new(composite, Swt::SWT::NO_MERGE_PAINTS );
    layoutdata = Swt::Layout::FormData.new()
    layoutdata.left = Swt::Layout::FormAttachment.new( label, 10, Swt::SWT::LEFT)
    layoutdata.top = Swt::Layout::FormAttachment.new( label,  5, Swt::SWT::BOTTOM)
    button_group.setLayoutData( layoutdata )
    layout = Swt::Layout::RowLayout.new(Swt::SWT::VERTICAL) 
    layout.spacing = 10
    button_group.setLayout( layout );

    service_none_button = Swt::Widgets::Button.new(button_group, Swt::SWT::RADIO )
    service_none_button.setText( 'none' )
    service_none_button.setSelection( App::CONFIG["services"].empty? )
    service_none_button.addListener(Swt::SWT::Selection, services_button_handler)

    service_http_button = Swt::Widgets::Button.new(button_group, Swt::SWT::RADIO )
    service_http_button.setText( 'http' )
    service_http_button.setSelection( App::CONFIG["services"] == [:http])
    service_http_button.addListener(Swt::SWT::Selection, services_button_handler)

    service_livereload_button = Swt::Widgets::Button.new(button_group, Swt::SWT::RADIO )
    service_livereload_button.setText( 'http and livereload' )
    service_livereload_button.setSelection(App::CONFIG["services"] == [:http, :livereload])

    
    layoutdata = Swt::Layout::FormData.new()
    layoutdata.left = Swt::Layout::FormAttachment.new( 0 )
    layoutdata.top = Swt::Layout::FormAttachment.new( button_group, 10, Swt::SWT::BOTTOM)
    service_config_label = Swt::Widgets::Label.new( composite, Swt::SWT::LEFT | Swt::SWT::WRAP)
    service_config_label.setText('Service config')
    service_config_label.setLayoutData( layoutdata )

    layoutdata = Swt::Layout::FormData.new()
    layoutdata.left = Swt::Layout::FormAttachment.new( service_config_label, 10, Swt::SWT::LEFT)
    layoutdata.top = Swt::Layout::FormAttachment.new( service_config_label, 10, Swt::SWT::BOTTOM)
    http_port_label = Swt::Widgets::Label.new( composite, Swt::SWT::LEFT | Swt::SWT::WRAP)
    http_port_label.setText("http port:")
    http_port_label.setLayoutData(layoutdata)


    layoutdata = Swt::Layout::FormData.new(50, Swt::SWT::DEFAULT)
    layoutdata.left = Swt::Layout::FormAttachment.new( http_port_label, 1, Swt::SWT::RIGHT)
    layoutdata.top = Swt::Layout::FormAttachment.new( http_port_label, 0, Swt::SWT::TOP)
    http_port_text = Swt::Widgets::Text.new(composite, Swt::SWT::BORDER)
    http_port_text.setText( App::CONFIG["services_http_port"].to_s )
    http_port_text.setLayoutData( layoutdata )
    http_port_text.addListener(Swt::SWT::Selection, services_button_handler)
 
    layoutdata = Swt::Layout::FormData.new()
    layoutdata.left = Swt::Layout::FormAttachment.new( http_port_label, 0, Swt::SWT::LEFT)
    layoutdata.top = Swt::Layout::FormAttachment.new( http_port_label, 10, Swt::SWT::BOTTOM)
    livereload_port_label = Swt::Widgets::Label.new( composite, Swt::SWT::LEFT | Swt::SWT::WRAP)
    livereload_port_label.setText("livereload port:")
    livereload_port_label.setLayoutData(layoutdata)


    layoutdata = Swt::Layout::FormData.new(50, Swt::SWT::DEFAULT)
    layoutdata.left = Swt::Layout::FormAttachment.new( livereload_port_label, 1, Swt::SWT::RIGHT)
    layoutdata.top = Swt::Layout::FormAttachment.new( livereload_port_label, 0, Swt::SWT::TOP)
    livereload_port_text = Swt::Widgets::Text.new(composite, Swt::SWT::BORDER)
    livereload_port_text.setText( App::CONFIG["services_livereload_port"].to_s )
    livereload_port_text.setLayoutData( layoutdata )
    livereload_port_text.addListener(Swt::SWT::Selection, services_button_handler)

    layoutdata = Swt::Layout::FormData.new()
    layoutdata.left = Swt::Layout::FormAttachment.new(0, 0)
    layoutdata.top = Swt::Layout::FormAttachment.new(livereload_port_label, 10, Swt::SWT::BOTTOM)
    @services_apply_button = Swt::Widgets::Button.new(composite, Swt::SWT::PUSH )
    @services_apply_button.setLayoutData(layoutdata)
    @services_apply_button.setText("Apply")
    @services_apply_button.setEnabled(false)
    @services_apply_button.addListener(Swt::SWT::Selection,Swt::Widgets::Listener.impl do |method, evt|   
      App::CONFIG["services"] = case true
      when service_none_button.getSelection       then [] 
      when service_http_button.getSelection       then [ :http ] 
      when service_livereload_button.getSelection then [ :http, :livereload] 
      end
      App::CONFIG['services_http_port'] = http_port_text.getText
      App::CONFIG['services_livereload_port'] = livereload_port_text.getText
      App.save_config
      App.alert('done')  
      evt.widget.setEnabled(false)
    end)
    return  composite
  end
  
  def services_button_handler 
    Swt::Widgets::Listener.impl do |method, evt|   
      @services_apply_button.setEnabled(true)
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

    notification_error_button = Swt::Widgets::Button.new(button_group, Swt::SWT::RADIO )
    notification_error_button.setText( 'only errors' )
    notification_error_button.setSelection( App::CONFIG["notifications"] == [:error] )
    notification_error_button.addListener(Swt::SWT::Selection, notification_button_handler)

    notification_warning_button = Swt::Widgets::Button.new(button_group, Swt::SWT::RADIO )
    notification_warning_button.setText( 'errors and warnings' )
    notification_warning_button.setSelection( App::CONFIG["notifications"] == [:error, :warnings])
    notification_warning_button.addListener(Swt::SWT::Selection, notification_button_handler)

    notification_everything_button = Swt::Widgets::Button.new(button_group, Swt::SWT::RADIO )
    notification_everything_button.setText( 'errors, warnings and success' )
    notification_everything_button.setSelection(App::CONFIG["notifications"].include?( :directory ))
    notification_everything_button.addListener(Swt::SWT::Selection, notification_button_handler)


    layoutdata = Swt::Layout::FormData.new(480,Swt::SWT::DEFAULT)
    layoutdata.left = Swt::Layout::FormAttachment.new( label, 0, Swt::SWT::LEFT)
    layoutdata.top = Swt::Layout::FormAttachment.new( button_group,  20, Swt::SWT::BOTTOM)
    log_notifaction_button = Swt::Widgets::Button.new(composite, Swt::SWT::CHECK )
    log_notifaction_button.setLayoutData( layoutdata )
    log_notifaction_button.setText( "save notification to compass_app_log.txt which in the project folder" )
    log_notifaction_button.setSelection( App::CONFIG["save_notification_to_file"] )
    log_notifaction_button.addListener(Swt::SWT::Selection, notification_button_handler)


    layoutdata = Swt::Layout::FormData.new()
    layoutdata.left = Swt::Layout::FormAttachment.new(0, 0)
    layoutdata.top = Swt::Layout::FormAttachment.new(log_notifaction_button, 10, Swt::SWT::BOTTOM)
    @notifications_apply_button = Swt::Widgets::Button.new(composite, Swt::SWT::PUSH )
    @notifications_apply_button.setLayoutData(layoutdata)
    @notifications_apply_button.setText("Apply")
    @notifications_apply_button.setEnabled(false)
    
    @notifications_apply_button.addListener(Swt::SWT::Selection,Swt::Widgets::Listener.impl do |method, evt|   
      App::CONFIG["notifications"] = case true
      when notification_error_button.getSelection      then [ :error] 
      when notification_warning_button.getSelection    then [ :error, :warnings ] 
      when notification_everything_button.getSelection then [ :directory, :exists, :remove, :create, :overwrite, :compile, :error, :identical, :warning ]
      end
      App::CONFIG['save_notification_to_file'] = log_notifaction_button.getSelection
      App.save_config
      App.alert('done')  
      evt.widget.setEnabled(false)
    end)

    return  composite
  end

  def notification_button_handler 
    Swt::Widgets::Listener.impl do |method, evt|   
      @notifications_apply_button.setEnabled(true)
    end
  end

  def compass_version_composite()
    composite =Swt::Widgets::Composite.new(@tabFolder, Swt::SWT::NO_MERGE_PAINTS );
    layout = Swt::Layout::FormLayout.new
    layout.marginWidth = layout.marginHeight = 10
    layout.spacing = 0
    composite.layout = layout

    font_data=@shell.getFont().getFontData()
    font_data.each do |fd|
      fd.setHeight(12)
    end
    font=Swt::Graphics::Font.new(@display, font_data)

    button_group =Swt::Widgets::Composite.new(composite, Swt::SWT::NO_MERGE_PAINTS );
    rowlayout = Swt::Layout::RowLayout.new(Swt::SWT::VERTICAL) 
    rowlayout.marginBottom = 0;
    rowlayout.spacing = 10;
    button_group.setLayout( rowlayout );

    button_v11 = Swt::Widgets::Button.new(button_group, Swt::SWT::RADIO )
    button_v11.setText("v0.11.beta.5(default)")
    button_v11.setSelection( App::CONFIG['use_version'] == 0.11 || !(App::CONFIG['use_specify_gem_path'] || App::CONFIG['use_version']) )
    button_v11.setFont(font)
    button_v11.addListener(Swt::SWT::Selection, compass_version_button_handler)

    button_v10 = Swt::Widgets::Button.new(button_group, Swt::SWT::RADIO )
    button_v10.setText("v0.10.6")
    button_v10.setSelection( App::CONFIG['use_version'] == 0.10 )
    button_v10.setFont(font)
    button_v10.addListener(Swt::SWT::Selection, compass_version_button_handler)


    use_specify_gem_path_btn = Swt::Widgets::Button.new(button_group, Swt::SWT::RADIO )
    use_specify_gem_path_btn.setText("Use specify gem path")
    use_specify_gem_path_btn.setSelection(App::CONFIG['use_specify_gem_path'])
    use_specify_gem_path_btn.setFont(font)
    use_specify_gem_path_btn.addListener(Swt::SWT::Selection, compass_version_button_handler)
  

    data = Swt::Layout::FormData.new(480,Swt::SWT::DEFAULT)
    data.left = Swt::Layout::FormAttachment.new( button_group, 22, Swt::SWT::LEFT)
    data.top = Swt::Layout::FormAttachment.new( button_group, 0, Swt::SWT::BOTTOM)
    speial_gem_label = Swt::Widgets::Label.new( composite, Swt::SWT::LEFT | Swt::SWT::WRAP)
    speial_gem_label.setText("Compass.app comes with some default extensions. if you want use RubyGem to manage extensions, you can specify your own gem path.\nex: /usr/local/lib/ruby/gems/1.8:/Users/foo/.gems")
    speial_gem_label.setLayoutData(data)
    speial_gem_label.setEnabled(use_specify_gem_path_btn.getSelection)
    speial_gem_label.setFont(font)


    layoutdata = Swt::Layout::FormData.new(480, Swt::SWT::DEFAULT)
    layoutdata.left = Swt::Layout::FormAttachment.new( speial_gem_label, 0, Swt::SWT::LEFT)
    layoutdata.top = Swt::Layout::FormAttachment.new( speial_gem_label, 2, Swt::SWT::BOTTOM)
    gem_path_text = Swt::Widgets::Text.new(composite, Swt::SWT::BORDER)
    gem_path_text.setText(App::CONFIG['gem_path'] || '')
    gem_path_text.setEnabled(use_specify_gem_path_btn.getSelection)
    gem_path_text.setLayoutData( layoutdata )
    gem_path_text.addListener(Swt::SWT::Selection, compass_version_button_handler)
 
    use_specify_gem_path_btn.addListener(Swt::SWT::Selection,Swt::Widgets::Listener.impl do |method, evt|   
      gem_path_text.setEnabled(evt.widget.getSelection)
      speial_gem_label.setEnabled(evt.widget.getSelection)
    end)

    layoutdata = Swt::Layout::FormData.new()
    layoutdata.left = Swt::Layout::FormAttachment.new(button_group, 0, Swt::SWT::LEFT)
    layoutdata.top = Swt::Layout::FormAttachment.new(gem_path_text, 10, Swt::SWT::BOTTOM)
    @compass_version_apply_button = Swt::Widgets::Button.new(composite, Swt::SWT::PUSH )
    @compass_version_apply_button.setLayoutData(layoutdata)
    @compass_version_apply_button.setText("Apply")
    @compass_version_apply_button.setEnabled(false)
    @compass_version_apply_button.addListener(Swt::SWT::Selection,Swt::Widgets::Listener.impl do |method, evt|   
      if button_v11.getSelection
        App::CONFIG['use_version'] = 0.11
      elsif  button_v10.getSelection
        App::CONFIG['use_version'] = 0.10
      else
        App::CONFIG['use_version'] = false
      end
      App::CONFIG['use_specify_gem_path']=use_specify_gem_path_btn.getSelection
      App::CONFIG['gem_path']=gem_path_text.getText
      App.save_config
      QuitWindow.new('Please restart Compass.app to apply Changes', 'Quit')  
      evt.widget.shell.dispose();
    end)

    data = Swt::Layout::FormData.new()
    data.left = Swt::Layout::FormAttachment.new(@compass_version_apply_button, 0, Swt::SWT::RIGHT)
    data.top = Swt::Layout::FormAttachment.new(@compass_version_apply_button, 0, Swt::SWT::CENTER)
    button = Swt::Widgets::Button.new(composite, Swt::SWT::PUSH )
    button.setText("Cancel")
    button.setLayoutData(data)
    button.addListener(Swt::SWT::Selection,Swt::Widgets::Listener.impl do |method, evt|
      @shell.dispose
    end)

    return composite;
  end

  def compass_version_button_handler 
    Swt::Widgets::Listener.impl do |method, evt|   
      @compass_version_apply_button.setEnabled(true)
    end
  end
end
