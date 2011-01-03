require "compile_version.rb"
require "notification.rb"
require "report.rb"
require "preferance_panel.rb"


module App
  extend self

  include CompileVersion
  VERSION = "1.1"
  OS = org.jruby.platform.Platform::OS
  
  def version
    VERSION
  end

  def compile_version
    "#{OS}.#{COMPILE_TIME}.#{REVISION}"
  end

  CONFIG_DIR = File.join( java.lang.System.getProperty("user.home") , '.compass-ui' )

  Dir.mkdir( CONFIG_DIR ) unless File.exists?( CONFIG_DIR )

  HISTORY_FILE =  File.join( CONFIG_DIR, 'history')
  CONFIG_FILE  =  File.join( CONFIG_DIR, 'config')

  def get_system_default_gem_path
    begin
      %x{gem env gempath}.strip.split(/:/).first
    rescue => e
      nil
    end
  end

  def get_config
    begin 
      x = YAML.load_file( CONFIG_FILE ) 
    rescue => e
      x = {} 
    end
    {
      "use_specify_gem_path" => false,
      "gem_path" => App.get_system_default_gem_path
    }.merge!(x)
  end
 
  CONFIG = get_config

 
  def require_compass

    begin
      ENV["GEM_HOME"] = CONFIG["gem_path"] 
      ENV["GEM_PATH"] = CONFIG["gem_path"] 
      require "rubygems"
      require "compass"
      require "compass/exec"
    rescue LoadError => e
      if CONFIG["use_specify_gem_path"]
        alert(" Load Compass fail, Use Default Compass library, please check the Gem Path")
      end
      ruby_lib_path = File.join(File.dirname(File.dirname(File.dirname(__FILE__))), "ruby").to_s()[5..-1]
      if File.exists?( ruby_lib_path )
        lib_path = File.join(File.dirname(File.dirname(File.dirname(__FILE__)))).to_s()[5..-1]
      else
        lib_path = 'lib'
      end 

      gems_path=File.join(lib_path, "ruby", "gem", "gems")
      Dir.new( gems_path).entries.reject{|e| e =~ /^\./}.each do |dir|
        $LOAD_PATH.unshift( File.join(gems_path, dir,'lib'))
      end 
      $LOAD_PATH.unshift "." 
      require "compass"
      require "compass/exec"
    end

    require "compass_patch.rb"
  end

  def save_config
    open(CONFIG_FILE,'w') do |f|
      f.write YAML.dump(CONFIG)
    end

  end

  def set_histoy(dirs)
    File.open(HISTORY_FILE, 'w') do |out|
      YAML.dump(dirs, out)
    end 
  end 

  def get_history
    dirs = YAML.load_file( HISTORY_FILE ) if File.exists?(HISTORY_FILE)
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

  def try
    begin
      yield
    rescue Exception => e
      alert("#{e.message}\n#{e.backtrace.join("\n")}")
    end
  end

end
