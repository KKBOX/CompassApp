class Report

  def initialize(msg, target_display = nil, options={}, &block)
    report_text_area=nil
    @target_display = Swt::Widgets::Display.get_current unless target_display
    @target_display.syncExec(
      Swt::RRunnable.new do | runnable |
    shell = Swt::Widgets::Shell.new(@target_display, Swt::SWT::DIALOG_TRIM)
    shell.setText("Compass.app Report")
    shell.setBackgroundMode(Swt::SWT::INHERIT_DEFAULT)
    shell.setSize(800,480)
    layout = Swt::Layout::GridLayout.new
    layout.numColumns = 2;
    shell.layout = layout

    if App.respond_to?(:create_image)
      gridData = Swt::Layout::GridData.new
      gridData.horizontalAlignment = Swt::SWT::LEFT;
      gridData.verticalAlignment = Swt::SWT::TOP;
      gridData.verticalSpan=2
      label = Swt::Widgets::Label.new(shell, Swt::SWT::LEFT)
      label.setImage( App.create_image('icon/64.png') )
      label.setLayoutData(gridData)
    else
      layout.numColumns=1
    end

    gridData = Swt::Layout::GridData.new
    label = Swt::Widgets::Label.new(shell, Swt::SWT::LEFT)
    font_data=label.getFont().getFontData()
    font_data.each do |fd|
      fd.setStyle(Swt::SWT::BOLD)
      fd.setHeight(14)
    end
    font=Swt::Graphics::Font.new(@target_display, font_data)
    label.setFont(font)
    if options[:show_reset_button]
      label.setText('There is something wrong.')
    else
      label.setText('Compass.app Report:')
    end
    label.setLayoutData(gridData)


    gridData = Swt::Layout::GridData.new
    gridData.horizontalAlignment = Swt::SWT::FILL;
    gridData.verticalAlignment = Swt::SWT::FILL;
    gridData.grabExcessHorizontalSpace = true;
    gridData.grabExcessVerticalSpace = true;
    report_text_area = Swt::Widgets::Text.new(shell, Swt::SWT::MULTI | Swt::SWT::READ_ONLY | Swt::SWT::V_SCROLL | Swt::SWT::H_SCROLL)
    report_text_area.setText(msg)
    report_text_area.setLayoutData(gridData)


    gridData = Swt::Layout::GridData.new
    gridData.horizontalAlignment = Swt::SWT::RIGHT;
    gridData.verticalAlignment = Swt::SWT::BOTTOM;
    gridData.grabExcessHorizontalSpace = false;
    gridData.grabExcessVerticalSpace = false;
    gridData.horizontalSpan=2

    if options[:show_reset_button]
      button_group =Swt::Widgets::Composite.new( shell, Swt::SWT::NO_MERGE_PAINTS );
      button_group.setLayoutData(gridData)
      rowlayout = Swt::Layout::RowLayout.new() 
      rowlayout.marginBottom = 0;
      rowlayout.marginTop = 0;
      rowlayout.spacing = 10;
      button_group.setLayout( rowlayout );

      btn = Swt::Widgets::Button.new(button_group, Swt::SWT::PUSH | Swt::SWT::CENTER)
      btn.setText('Quit')
      btn.addListener(Swt::SWT::Selection,Swt::Widgets::Listener.impl do |method, evt|   
        evt.widget.shell.dispose();
      end)
      
      if defined? App::CONFIG
        btn = Swt::Widgets::Button.new(button_group, Swt::SWT::PUSH | Swt::SWT::CENTER)
        btn.setText('Quit && Reset my preferences')
        btn.addListener(Swt::SWT::Selection,Swt::Widgets::Listener.impl do |method, evt|   
          App::CONFIG['use_version'] = 0.12
          App::CONFIG['use_specify_gem_path']=false
          App.save_config

          evt.widget.shell.dispose();
        end)
      end

    else
      btn = Swt::Widgets::Button.new(shell, Swt::SWT::PUSH | Swt::SWT::CENTER)
      btn.setText('OK')
      btn.setLayoutData(gridData)
      btn.addListener(Swt::SWT::Selection,Swt::Widgets::Listener.impl do |method, evt|   
        block.call if block_given?
        evt.widget.shell.dispose();
      end)
    end

    if @target_display
      m=@target_display.getPrimaryMonitor().getBounds() 
      rect = shell.getClientArea();
      shell.setLocation((m.width-rect.width) /2, (m.height-rect.height) /2) 
    end
    shell.open
    shell.forceActive

    if options[:show_reset_button]
      while(!shell.is_disposed) do
        @target_display.sleep if(!@target_display.read_and_dispatch)
      end
    end
      end)
    @text = report_text_area

  end

  def append(text, &block)
    @text.append "\n#{text}" if @text && !@text.is_disposed
    @text.update
    block.call if block_given?
  end
end
