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
    @shell.setSize(800,480)
    layout = Swt::Layout::FormLayout.new
    layout.marginWidth = layout.marginHeight = 10
    @shell.layout = layout

    button = Swt::Widgets::Button.new(@shell, Swt::SWT::CHECK )
    font_data=button.getFont().getFontData()
    font_data.each do |fd|
      fd.setHeight(14)
    end
    font=Swt::Graphics::Font.new(@display, font_data)
    button.setFont(font)
    button.setText("Specify gem path")
    button.setSelection(App::CONFIG['use_specify_gem_path'])
    button.addListener(Swt::SWT::Selection,Swt::Widgets::Listener.impl do |method, evt|   
      @gem_path_text.setEnabled(evt.widget.getSelection)
      @gem_path_choose_btn.setEnabled(evt.widget.getSelection)
    end)
    @use_specify_gem_path_btn=button
    
    data = Swt::Layout::FormData.new(480, 40)
    data.left = Swt::Layout::FormAttachment.new(button, 20, Swt::SWT::LEFT)
    data.top = Swt::Layout::FormAttachment.new(button, 5, Swt::SWT::BOTTOM )
    label = Swt::Widgets::Label.new(@shell, Swt::SWT::LEFT | Swt::SWT::WRAP)
    label.setText("Compass.app comes with some default extensions. if you want use RubyGem to manage extensions, you can specify your own gem path.")
    label.setLayoutData(data)

    layout = Swt::Layout::FormLayout.new()
    layout.marginHeight=15
    layout.marginWidth=15
    data = Swt::Layout::FormData.new()
    data.left = Swt::Layout::FormAttachment.new( @use_specify_gem_path_btn, 0, Swt::SWT::LEFT)
    data.top = Swt::Layout::FormAttachment.new( label, 10, Swt::SWT::BOTTOM)
    group = Swt::Widgets::Group.new(@shell, Swt::SWT::SHADOW_ETCHED_IN)
    group.setLayout(layout)
    group.setLayoutData(data)

    data = Swt::Layout::FormData.new(360, 20)
    text = Swt::Widgets::Text.new(group, Swt::SWT::BORDER)
    text.setText(App::CONFIG['gem_path'] || '')
    text.setEnabled(@use_specify_gem_path_btn.getSelection)
    text.setLayoutData(data)
    @gem_path_text=text

    data = Swt::Layout::FormData.new()
    data.left = Swt::Layout::FormAttachment.new(text, 5)
    data.top = Swt::Layout::FormAttachment.new(text, 0, Swt::SWT::CENTER)
    button = Swt::Widgets::Button.new(group, Swt::SWT::PUSH )
    button.setText("Choose...")
    button.setLayoutData(data)
    button.setEnabled(@use_specify_gem_path_btn.getSelection)
    button.addListener(Swt::SWT::Selection,Swt::Widgets::Listener.impl do |method, evt|   
      dia = Swt::Widgets::DirectoryDialog.new(@shell)
      dir = dia.open
      @gem_path_text.setText(dir) if dir
    end)
    @gem_path_choose_btn=button

    data = Swt::Layout::FormData.new()
    data.left = Swt::Layout::FormAttachment.new(group, 0, Swt::SWT::LEFT)
    data.top = Swt::Layout::FormAttachment.new(group, 10)
    button = Swt::Widgets::Button.new(@shell, Swt::SWT::PUSH )
    button.setText("Apply")
    button.setLayoutData(data)
    button.addListener(Swt::SWT::Selection,Swt::Widgets::Listener.impl do |method, evt|   
      App::CONFIG['use_specify_gem_path']=@use_specify_gem_path_btn.getSelection
      App::CONFIG['gem_path']=@gem_path_text.getText
      App.save_config
      QuitWindow.new('Please restart Compass.app to apply Changes', 'Quit')  
      evt.widget.shell.dispose();
    end)

    data = Swt::Layout::FormData.new()
    data.left = Swt::Layout::FormAttachment.new(button, 0, Swt::SWT::RIGHT)
    data.top = Swt::Layout::FormAttachment.new(button, 0, Swt::SWT::CENTER)
    button = Swt::Widgets::Button.new(@shell, Swt::SWT::PUSH )
    button.setText("Cancel")
    button.setLayoutData(data)
    button.addListener(Swt::SWT::Selection,Swt::Widgets::Listener.impl do |method, evt|
	@shell.dispose
    end)

    @shell.pack

  end

end
