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
    @shell.pack
 end

 def notification_composite
    composite =Swt::Widgets::Composite.new(@tabFolder, Swt::SWT::NO_MERGE_PAINTS );
   layout = Swt::Layout::FormLayout.new
   layout.marginWidth = layout.marginHeight = 10
   layout.spacing = 0
   composite.layout = layout
    
   label = Swt::Widgets::Label.new( composite, Swt::SWT::LEFT | Swt::SWT::WRAP)
   label.setText('Notification Types')

    button_group =Swt::Widgets::Composite.new(composite, Swt::SWT::NO_MERGE_PAINTS );
    layoutdata = Swt::Layout::FormData.new()
    layoutdata.left = Swt::Layout::FormAttachment.new( label, 10, Swt::SWT::LEFT)
    layoutdata.top = Swt::Layout::FormAttachment.new( label,  5, Swt::SWT::BOTTOM)
    button_group.setLayoutData( layoutdata )
    layout = Swt::Layout::GridLayout.new( 3, true ) 
    layout.horizontalSpacing = 10
    layout.verticalSpacing   = 10
    button_group.setLayout( layout );

    [:directory, :exists, :remove, :create, :overwrite, :compile, :error, :identical, :warning].each do | action |
      button = Swt::Widgets::Button.new(button_group, Swt::SWT::CHECK )
      button.setText( action.to_s )
      button.setSelection(App::CONFIG["notifications"].include?( action ))
      button.addListener(Swt::SWT::Selection,Swt::Widgets::Listener.impl do |method, evt|   
        if button.getSelection 
          App::CONFIG["notifications"] << evt.widget.getText().to_sym
        else
          App::CONFIG["notifications"].delete evt.widget.getText().to_sym
        end
          App.save_config
      end)
    end

    button = Swt::Widgets::Button.new(composite, Swt::SWT::CHECK )
    button.setText( "save notification to compass_app_log.txt which in the project folder" )
    button.setSelection( App::CONFIG["save_notification_to_file"] )
    button.addListener(Swt::SWT::Selection,Swt::Widgets::Listener.impl do |method, evt|   
      App::CONFIG["save_notification_to_file"] = evt.widget.getSelection()
      App.save_config
    end)

    layoutdata = Swt::Layout::FormData.new(480,Swt::SWT::DEFAULT)
    layoutdata.left = Swt::Layout::FormAttachment.new( label, 0, Swt::SWT::LEFT)
    layoutdata.top = Swt::Layout::FormAttachment.new( button_group,  20, Swt::SWT::BOTTOM)
    button.setLayoutData( layoutdata )

    return  composite
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
   layout = Swt::Layout::RowLayout.new(Swt::SWT::VERTICAL) 
   layout.marginBottom = 0;
   layout.spacing = 10;
   button_group.setLayout( layout );

   @button_v11 = Swt::Widgets::Button.new(button_group, Swt::SWT::RADIO )
   @button_v11.setText("v0.11")
   @button_v11.setSelection( App::CONFIG['use_version'] == 0.11 || !(App::CONFIG['use_specify_gem_path'] || App::CONFIG['use_version']) )
   @button_v11.setFont(font)

   @button_v10 = Swt::Widgets::Button.new(button_group, Swt::SWT::RADIO )
   @button_v10.setText("v0.10")
   @button_v10.setSelection( App::CONFIG['use_version'] == 0.10 )
   @button_v10.setFont(font)


   button = Swt::Widgets::Button.new(button_group, Swt::SWT::RADIO )
   button.setText("Use specify gem path")
   button.setSelection(App::CONFIG['use_specify_gem_path'])
   button.setFont(font)
   button.addListener(Swt::SWT::Selection,Swt::Widgets::Listener.impl do |method, evt|   
     @gem_path_text.setEnabled(evt.widget.getSelection)
     @speial_gem_label.setEnabled(evt.widget.getSelection)
   end)
   @use_specify_gem_path_btn=button

    data = Swt::Layout::FormData.new(480,Swt::SWT::DEFAULT)
    data.left = Swt::Layout::FormAttachment.new( button_group, 22, Swt::SWT::LEFT)
    data.top = Swt::Layout::FormAttachment.new( button_group, 0, Swt::SWT::BOTTOM)
    @speial_gem_label = Swt::Widgets::Label.new( composite, Swt::SWT::LEFT | Swt::SWT::WRAP)
    @speial_gem_label.setText("Compass.app comes with some default extensions. if you want use RubyGem to manage extensions, you can specify your own gem path.\nex: /usr/local/lib/ruby/gems/1.8:/Users/foo/.gems")
    @speial_gem_label.setLayoutData(data)
    @speial_gem_label.setEnabled(@use_specify_gem_path_btn.getSelection)
    @speial_gem_label.setFont(font)


    layout = Swt::Layout::FormLayout.new()
    layout.marginHeight=0
    layout.marginWidth=0
    data = Swt::Layout::FormData.new()
    data.left = Swt::Layout::FormAttachment.new( @speial_gem_label, 0, Swt::SWT::LEFT)
    data.top = Swt::Layout::FormAttachment.new( @speial_gem_label,0, Swt::SWT::BOTTOM)
    group = Swt::Widgets::Composite.new(composite, Swt::SWT::SHADOW_ETCHED_IN)
    group.setLayout(layout)
    group.setLayoutData(data)

    data = Swt::Layout::FormData.new(480, 20)
    text = Swt::Widgets::Text.new(group, Swt::SWT::BORDER)
    text.setText(App::CONFIG['gem_path'] || '')
    text.setEnabled(@use_specify_gem_path_btn.getSelection)
    text.setLayoutData(data)
    @gem_path_text=text

    data = Swt::Layout::FormData.new()
    data.left = Swt::Layout::FormAttachment.new(@button_group, 0, Swt::SWT::LEFT)
    data.top = Swt::Layout::FormAttachment.new(group, 10, Swt::SWT::BOTTOM)
    button = Swt::Widgets::Button.new(composite, Swt::SWT::PUSH )
    button.setText("Apply")
    button.setLayoutData(data)
    button.addListener(Swt::SWT::Selection,Swt::Widgets::Listener.impl do |method, evt|   
      if @button_v11.getSelection
        App::CONFIG['use_version'] = 0.11
      elsif  @button_v10.getSelection
        App::CONFIG['use_version'] = 0.10
      else
        App::CONFIG['use_version'] = false
      end
      App::CONFIG['use_specify_gem_path']=@use_specify_gem_path_btn.getSelection
      App::CONFIG['gem_path']=@gem_path_text.getText
      App.save_config
      QuitWindow.new('Please restart Compass.app to apply Changes', 'Quit')  
      evt.widget.shell.dispose();
    end)

    data = Swt::Layout::FormData.new()
    data.left = Swt::Layout::FormAttachment.new(button, 0, Swt::SWT::RIGHT)
    data.top = Swt::Layout::FormAttachment.new(button, 0, Swt::SWT::CENTER)
    button = Swt::Widgets::Button.new(composite, Swt::SWT::PUSH )
    button.setText("Cancel")
    button.setLayoutData(data)
    button.addListener(Swt::SWT::Selection,Swt::Widgets::Listener.impl do |method, evt|
	@shell.dispose
    end)

    return composite;
  end

end
