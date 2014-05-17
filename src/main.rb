
module Main
  extend self
  
  attr_reader :init_at, :lib_path, :config_dir

  def init
    @init_at=Time.now

    set_default_encoding
    set_lib_path
    require_lib
    init_app
  end

  def set_default_encoding
    # set default encoding
    if RUBY_VERSION > "1.9"
      Encoding.default_external = Encoding::UTF_8
      #Encoding.default_internal = Encoding::UTF_8
    end
  end

  def set_lib_path
    $LOAD_PATH << 'src'

    require 'uri'
    resources_dir = File.join(File.dirname( File.dirname(File.dirname( URI.parse(__FILE__).path ))), 'Resources')
    if File.exists?( File.join(resources_dir, 'lib','ruby'))
          @lib_path = File.join(resources_dir, 'lib')
    else
          @lib_path = File.expand_path 'lib'
    end

  end


  def require_lib
    require 'swt_wrapper'
    require "ui/splash_window"
    SplashWindow.instance.replace('Loading...')
    require "require_patch.rb"

    require 'stringio'
    require 'thread'
    require "open-uri"
    require "yaml"
    %w{alert notification quit_window tray preference_panel report welcome_window change_options_panel progress_window}.each do | f |
      require "ui/#{f}"
    end

  end

  def set_config_dir

    require 'optparse'
    options = {}
    OptionParser.new do |opts|
      opts.banner = "Usage: example.rb [options]"
      
      options[:config_dir] = File.join( java.lang.System.getProperty("user.home") , '.compass-ui' )
      opts.on("-c PATH", "--config-dir PATH", "config dir path") do |v|
        options[:config_dir] = v
      end

    end.parse!

    # TODO: dirty, need refactor
      if File.directory?(File.dirname(options[:config_dir])) && File.writable?(File.dirname(options[:config_dir])) 
        @config_dir = options[:config_dir]
      else
        @config_dir = File.join(Dir.pwd, 'config')
        Alert.new("Can't Create #{options[:config_dir]}, just put config folder to #{@config_dir}")
      end
  end

  def app_require_lib

      require "app.rb"
      App.require_compass
      require "notifier"
     
      begin
        require "ninesixty"
        require "html5-boilerplate"
        require "compass-h5bp"
        require "compass-normalize"
        require "bootstrap-sass"
        require "susy"
        require "zurb-foundation-compass-template"
      rescue LoadError
      end

      require "livereload"
      require "simplehttpserver"

      if App::CONFIG['show_welcome']
        WelcomeWindow.new
      end   
      App.clear_autocomplete_cache

  end

  def init_app
    begin
      set_config_dir
      app_require_lib

    rescue Exception => e
      puts e.message
      puts e.backtrace
      Report.new( e.message + "\n" + e.backtrace.join("\n"), nil, {:show_reset_button => true} )
    end
  end

  def run_tray

    begin
      Tray.instance.run

    rescue Exception => e
      puts e.message
      puts e.backtrace
      Report.new( e.message + "\n" + e.backtrace.join("\n"), nil, {:show_reset_button => true} )
    end

  end


end


if $0 == '-' || $0 == __FILE__
  Main.init
  Main.run_tray
end
