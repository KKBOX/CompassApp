class AutoUpdate
  def initialize
    target_display = Swt::Widgets::Display.get_current
    target_display.asyncExec(
      Swt::RRunnable.new do | runnable |
      data = open(App::UPDATE_URL,'r')
      update = YAML.load(data)[App::OS]

      shell = create_shell(Swt::SWT::DIALOG_TRIM)
      shell.setText('Compass Update Notification')
      shell.setSize(400, 150)
      layout = Swt::Layout::RowLayout.new()
      layout.center = true 
      layout.justify = true 
      shell.layout = layout

      if  update && update["compile_version"].to_i > App::COMPILE_TIME.to_i

        hideRowData = Swt::Layout::RowData.new
        hideRowData.exclude = true
        btn = Swt::Widgets::Button.new(shell, Swt::SWT::PUSH)
        btn.setText('Download New Version')

        layout = Swt::Layout::GridLayout.new
        layout.numColumns = 3
        com = Swt::Widgets::Composite.new(shell, Swt::SWT::NONE)
        com.setLayout(layout)
        com.setLayoutData( Swt::Layout::RowData.new )
        com.setVisible(false)

        label = Swt::Widgets::Label.new(com, Swt::SWT::HORIZONTAL )
        label.setText("Dowloading:")
        bar   = Swt::Widgets::ProgressBar.new(com, Swt::SWT::SMOOTH)

        gridData = Swt::Layout::GridData.new
        gridData.widthHint = 120
        progress_info = Swt::Widgets::Label.new(com, Swt::SWT::HORIZONTAL )
        progress_info.setText("0 / 0 ")
        progress_info.setLayoutData(gridData)

        completed_label = Swt::Widgets::Label.new(shell, Swt::SWT::HORIZONTAL )
        completed_label.setText('Download Completed')
        completed_label.setVisible(false)

        btn.addListener(Swt::SWT::Selection, Swt::Widgets::Listener.impl do |method, evt|

          dia = Swt::Widgets::FileDialog.new(shell,Swt::SWT::SAVE)
          dia.setFileName( File.basename(update['url']) )
          filename = dia.open
          if filename
            btn.setVisible(false)
            com.setVisible(true)
            filesize = 0
            open(filename,'wb') do |f|
              f.write( open( update['url'], 
                            :content_length_proc => lambda{ |content_length| filesize = content_length } , 
                            :progress_proc       => lambda { |s| bar.setSelection(s*100/filesize)
                              progress_info.setText("#{s/1024} / #{filesize/1024} KB")
                              App.display.sleep if(!App.display.read_and_dispatch) }
                           ).read )
            end
            completed_label.setVisible(true)
            shell.forceActive
          end
        end)
      else
        label = Swt::Widgets::Label.new(shell, Swt::SWT::HORIZONTAL )
        label.setText("Compass.app is up to date")
      end

      m=target_display.getPrimaryMonitor().getBounds();
      rect = shell.getClientArea();
      shell.setLocation((m.width-rect.width) /2, (m.height-rect.height) /2) 
      shell.open
      shell.forceActive
      end)
  end
end
