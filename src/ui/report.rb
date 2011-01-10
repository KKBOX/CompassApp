class Report

  def initialize(msg, target_display = nil)
    target_display = Swt::Widgets::Display.get_current unless target_display
    target_display.asyncExec(
      Swt::RRunnable.new do | runnable |
      shell = Swt::Widgets::Shell.new(target_display, Swt::SWT::DIALOG_TRIM)
      shell.setText("Compass Report")
      shell.setBackgroundMode(Swt::SWT::INHERIT_DEFAULT)
      shell.setSize(800,480)
      layout = Swt::Layout::GridLayout.new
      layout.numColumns = 2;
      shell.layout = layout

      gridData = Swt::Layout::GridData.new
      gridData.horizontalAlignment = Swt::SWT::LEFT;
      gridData.verticalAlignment = Swt::SWT::TOP;
      gridData.verticalSpan=2
      label = Swt::Widgets::Label.new(shell, Swt::SWT::LEFT)
      label.setImage( App.create_image('icon/64.png') )
      label.setLayoutData(gridData)

      gridData = Swt::Layout::GridData.new
      label = Swt::Widgets::Label.new(shell, Swt::SWT::LEFT)
      font_data=label.getFont().getFontData()
      font_data.each do |fd|
        fd.setStyle(Swt::SWT::BOLD)
      end
      font=Swt::Graphics::Font.new(target_display, font_data)
      label.setFont(font)
      label.setText('Compass Report:')
      label.setLayoutData(gridData)


      gridData = Swt::Layout::GridData.new
      gridData.horizontalAlignment = Swt::SWT::FILL;
      gridData.verticalAlignment = Swt::SWT::FILL;
      gridData.grabExcessHorizontalSpace = true;
      gridData.grabExcessVerticalSpace = true;
      text = Swt::Widgets::Text.new(shell, Swt::SWT::MULTI | Swt::SWT::READ_ONLY | Swt::SWT::V_SCROLL | Swt::SWT::H_SCROLL)
      text.setText(msg)
      text.setLayoutData(gridData)

      gridData = Swt::Layout::GridData.new
      gridData.horizontalAlignment = Swt::SWT::RIGHT;
      gridData.verticalAlignment = Swt::SWT::BOTTOM;
      gridData.grabExcessHorizontalSpace = false;
      gridData.grabExcessVerticalSpace = false;
      gridData.horizontalSpan=2
      btn = Swt::Widgets::Button.new(shell, Swt::SWT::PUSH | Swt::SWT::CENTER)
      btn.setText('OK')
      btn.setLayoutData(gridData)
      btn.addListener(Swt::SWT::Selection,Swt::Widgets::Listener.impl do |method, evt|   
        evt.widget.shell.dispose();
      end)

      m=target_display.getPrimaryMonitor().getBounds();
      rect = shell.getClientArea();
      shell.setLocation((m.width-rect.width) /2, (m.height-rect.height) /2) 
      shell.open
      shell.forceActive
      end)

  end
end
