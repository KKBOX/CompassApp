INITAT=Time.now
require 'java'

# set default encoding
if ::VERSION > "1.9"
  Encoding.default_external = Encoding::UTF_8
  #Encoding.default_internal = Encoding::UTF_8
end

$LOAD_PATH << 'src'
require 'pathname'
resources_dir =  Pathname.new(__FILE__).dirname().dirname().dirname().to_s()[5..-1]
if resources_dir && File.exists?( File.join(resources_dir, 'lib','ruby'))
  LIB_PATH = File.join(resources_dir, 'lib')
else
  LIB_PATH = File.expand_path 'lib' 
end


require "swt_wrapper"
require "ui/splash_window"
SplashWindow.instance.replace('Loading...')
require "require_patch.rb"

require 'stringio'
require 'thread'
require "open-uri"
require "yaml"
%w{alert notification quit_window tray preference_panel report welcome_window}.each do | f |
  require "ui/#{f}"
end

require 'optparse'
options = {}
OptionParser.new do |opts|
  opts.banner = "Usage: example.rb [options]"
  
  options[:config_dir] = File.join( java.lang.System.getProperty("user.home") , '.compass-ui' )
  opts.on("-c PATH", "--config-dir PATH", "config dir path") do |v|
    options[:config_dir] = v
  end

end.parse!

begin
  # TODO: dirty, need refactor
  if File.directory?(File.dirname(options[:config_dir])) && File.writable?(File.dirname(options[:config_dir])) 
    CONFIG_DIR = options[:config_dir]
  else
    CONFIG_DIR = File.join(Dir.pwd, 'config')
    Alert.new("Can't Create #{options[:config_dir]}, just put config folder to #{CONFIG_DIR}")
  end

  require "app.rb"
  App.require_compass
 
  begin
    require "ninesixty"
    require "html5-boilerplate"
    require "compass-h5bp"
    require "bootstrap-sass"
    require "susy"
    require "zurb-foundation"
  rescue LoadError
  end

  require "livereload"
  require "simplehttpserver"
  

  if App::CONFIG['show_welcome']
    WelcomeWindow.new
  end
  App.clear_autocomplete_cache

  require "lock_file"
  lock_file = LockFile.new

  Tray.instance.run
  
  lock_file.close

rescue Exception => e
  puts e.message
  puts e.backtrace
  Report.new( e.message + "\n" + e.backtrace.join("\n"), nil, {:show_reset_button => true} )
end
