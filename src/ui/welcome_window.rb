class WelcomeWindow

  def initialize()
    target_display = Swt::Widgets::Display.get_current
      shell = Swt::Widgets::Shell.new(target_display, Swt::SWT::DIALOG_TRIM)
      shell.setText("Compass.app")
      shell.setBackgroundMode(Swt::SWT::INHERIT_DEFAULT)
      shell.setSize(800,480)
      layout = Swt::Layout::RowLayout.new(Swt::SWT::VERTICAL)
      layout.spacing = 10
      layout.marginLeft   = 10;
      layout.marginTop    = 10;
      layout.marginRight  = 10;
      layout.marginBottom = 10;
      layout.wrap    = true
      shell.layout   = layout

      font_data=shell.getFont().getFontData()
      font_data.each do |fd|
        fd.setHeight(12)
      end
      new_font=Swt::Graphics::Font.new(target_display, font_data)
      label = Swt::Widgets::Label.new(shell, Swt::SWT::LEFT)
      label.setText('Compass.app is a menu bar only application.')
      label.setFont(new_font);

      label = Swt::Widgets::Label.new(shell, Swt::SWT::LEFT|Swt::SWT::WRAP)
      label.setText('We helps designers compile stylesheets easily without resorting to command line interface.')
      label.setLayoutData( Swt::Layout::RowData.new( 400, Swt::SWT::DEFAULT ))
      label.setFont(new_font);

      label = Swt::Widgets::Label.new(shell, Swt::SWT::LEFT)
      label.setImage( App.create_image('where_am_i.png') )

      composite = Swt::Widgets::Composite.new(shell, Swt::SWT::NO_MERGE_PAINTS );
      layout = Swt::Layout::FormLayout.new()
      composite.layout = layout
      composite.setLayoutData( Swt::Layout::RowData.new( 400, Swt::SWT::DEFAULT ))

      @button = Swt::Widgets::Button.new(composite, Swt::SWT::CHECK )
      @button.setText( 'Never show again' )
      @button.addListener(Swt::SWT::Selection, Swt::Widgets::Listener.impl do |method, evt|
        App::CONFIG['show_welcome'] = !@button.getSelection
        App.save_config
      end)
      @button.setFont(new_font);

      @start_button = Swt::Widgets::Button.new(composite, Swt::SWT::PUSH )
      layoutdata = Swt::Layout::FormData.new()
      layoutdata.right = Swt::Layout::FormAttachment.new( 100, 0)
      @start_button.setLayoutData(layoutdata)
      @start_button.setText( 'Start' )
      @start_button.addListener(Swt::SWT::Selection, Swt::Widgets::Listener.impl do |method, evt|
        evt.widget.shell.dispose();
      end)
      @start_button.setFont(new_font);

      shell.pack
      m=target_display.getPrimaryMonitor().getBounds();
      rect = shell.getClientArea();
      shell.setLocation((m.width-rect.width) /2, (m.height-rect.height) /2) 
      shell.open
      shell.forceActive
  end
end
