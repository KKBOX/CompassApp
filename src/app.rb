require "compile_version.rb"
require "notification.rb"
require "report.rb"


module App
  extend self

  VERSION = "1.0"
  OS = org.jruby.platform.Platform::OS
  include CompileVersion
  NOTIFIES = []

  CONFIG_DIR = File.join( java.lang.System.getProperty("user.home") , '.compass-ui' )

  Dir.mkdir( CONFIG_DIR ) unless File.exists?( CONFIG_DIR )

  HISTORY_CONFIG_FILE =  File.join( CONFIG_DIR, 'history')
  
  def version
    VERSION
  end

  def compile_version
     "#{OS}.#{COMPILE_TIME}.#{REVISION}"
  end

  def discover_compass_frameworks
    default_path = File.join( java.lang.System.getProperty("user.home"), '.compass','extensions' )
    if File.exists?( default_path ) 
          Compass::Frameworks.discover( default_path ) 
    end
  end

  def set_histoy(dirs)
    File.open(HISTORY_CONFIG_FILE, 'w') do |out|
      YAML.dump(dirs, out)
    end 
  end 

  def get_history
    dirs = YAML.load_file( HISTORY_CONFIG_FILE ) if File.exists?(HISTORY_CONFIG_FILE)
    return dirs if dirs
    return []
  end 

  def display
    Swt::Widgets::Display.get_current
  end

  def create_shell(style = nil)
    style ||= Swt::SWT::NO_FOCUS | Swt::SWT::NO_TRIM
    Swt::Widgets::Shell.new( Swt::Widgets::Display.get_current, style)
  end

  def create_image(path)
    Swt::Graphics::Image.new( Swt::Widgets::Display.get_current,  
                             JRuby.runtime.jruby_class_loader.get_resource_as_stream( 'data/images/' +path ))
  end

  def get_stdout
    begin
      sio = StringIO.new
      old_stdout, $stdout = $stdout, sio 
      #  Invoke method to test that writes to stdout
      yield
      output = sio.string.gsub(/\e\[\d+m/,'')
    rescue Exception => e  	
      output = e.message
    end
    $stdout = old_stdout # restore stdout
    return output
  end

  def notify(msg, target_display = nil )
    if org.jruby.platform.Platform::IS_MAC
      system('/usr/bin/osascript', "#{LIB_PATH}/applescript/growl.applescript", msg )
    else
      Notification.new(msg, target_display)
    end
  end

  def alert(msg, target_display = nil)
    Report.new(msg, target_display)
  end

  def check_update
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
        btn = Swt::Widgets::Button.new (shell, Swt::SWT::PUSH)
        btn.setText('Download New Version')

        layout = Swt::Layout::GridLayout.new
        layout.numColumns = 3
        com = Swt::Widgets::Composite.new(shell, Swt::SWT::NONE)
        com.setLayout(layout)
        com.setLayoutData( Swt::Layout::RowData.new )
        com.setVisible(false)

        label = Swt::Widgets::Label.new(com, Swt::SWT::HORIZONTAL )
        label.setText("Dowloading:")
        bar   = Swt::Widgets::ProgressBar.new (com, Swt::SWT::SMOOTH)

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
