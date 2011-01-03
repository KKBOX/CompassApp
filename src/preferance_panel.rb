class PreferencePanel

  def initialize(msg='test', target_display = nil)
    target_display = Swt::Widgets::Display.get_current unless target_display
    target_display.asyncExec(
      Swt::RRunnable.new do | runnable |
      shell = Swt::Widgets::Shell.new(target_display, Swt::SWT::DIALOG_TRIM)
      shell.setText("Compass.app Preference")
      shell.setBackgroundMode(Swt::SWT::INHERIT_DEFAULT)
      shell.setSize(800,480)
      layout = Swt::Layout::FormLayout.new
      layout.marginWidth = layout.marginHeight = 10
      shell.layout = layout

      button = Swt::Widgets::Button.new(shell, Swt::SWT::CHECK )
      button.setText("Use specify gem path:")
      button.setSelection(App::CONFIG['use_specify_gem_path'])
      @use_specify_gem_path_btn=button

      data = Swt::Layout::FormData.new(300, Swt::SWT::DEFAULT)
      data.left = Swt::Layout::FormAttachment.new(button, 5, Swt::SWT::LEFT)
      data.top = Swt::Layout::FormAttachment.new(button, 3)
      text = Swt::Widgets::Text.new(shell, Swt::SWT::BORDER)
      text.setLayoutData(data)
      text.setText(App::CONFIG['gem_path'] || '')
      @gem_path_text=text

      data = Swt::Layout::FormData.new(100, Swt::SWT::DEFAULT)
      data.left = Swt::Layout::FormAttachment.new(text, 0, Swt::SWT::CENTER)
      data.top = Swt::Layout::FormAttachment.new(text, 25)
      button = Swt::Widgets::Button.new(shell, Swt::SWT::PUSH )
      button.setText("Save")
      button.setLayoutData(data)

      button.addListener(Swt::SWT::Selection,Swt::Widgets::Listener.impl do |method, evt|   
        App::CONFIG['use_specify_gem_path']=@use_specify_gem_path_btn.getSelection
        App::CONFIG['gem_path']=@gem_path_text.getText
        App.save_config
        App.alert(' Please restart Compass.app to apply changes')
        evt.widget.shell.dispose();
      end)

      shell.pack
      m=target_display.getPrimaryMonitor().getBounds()
      rect = shell.getClientArea()
      shell.setLocation((m.width-rect.width) /2, (m.height-rect.height) /2) 
      shell.open
      shell.forceActive
      end)
  end
end
