class QuitWindow

  def initialize(msg, button_text='Quit')
    target_display = Swt::Widgets::Display.get_current
      shell = Swt::Widgets::Shell.new(target_display, Swt::SWT::DIALOG_TRIM)
      shell.setText("Compass.app")
      shell.setBackgroundMode(Swt::SWT::INHERIT_DEFAULT)
      shell.setSize(800,480)
      layout = Swt::Layout::GridLayout.new
      layout.numColumns = 2;
      shell.layout = layout

      gridData = Swt::Layout::GridData.new
      gridData.horizontalAlignment = Swt::SWT::LEFT;
      gridData.verticalAlignment = Swt::SWT::TOP;
      gridData.verticalSpan=1
      label = Swt::Widgets::Label.new(shell, Swt::SWT::LEFT)
      label.setImage( App.create_image('icon/32.png') )
      label.setLayoutData(gridData)

      gridData = Swt::Layout::GridData.new
      label = Swt::Widgets::Label.new(shell, Swt::SWT::LEFT)
      label.setText(msg)
      label.setLayoutData(gridData)


      gridData = Swt::Layout::GridData.new
      gridData.horizontalAlignment = Swt::SWT::CENTER;
      gridData.verticalAlignment = Swt::SWT::BOTTOM;
      gridData.grabExcessHorizontalSpace = false;
      gridData.grabExcessVerticalSpace = false;
      gridData.horizontalSpan=2
      btn = Swt::Widgets::Button.new(shell, Swt::SWT::PUSH | Swt::SWT::CENTER)
      btn.setText(button_text)
      btn.setLayoutData(gridData)
      btn.addListener(Swt::SWT::Selection,Swt::Widgets::Listener.impl do |method, evt|   
        evt.widget.shell.dispose();
        java.lang.System.exit(0)
      end)
      shell.pack
      m=target_display.getPrimaryMonitor().getBounds();
      rect = shell.getClientArea();
      shell.setLocation((m.width-rect.width) /2, (m.height-rect.height) /2) 
      shell.open
      shell.forceActive
  end
end
