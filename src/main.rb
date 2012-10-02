INITAT=Time.now

$LOAD_PATH << 'src'

ruby_lib_path = File.join(File.dirname(File.dirname(File.dirname(File.dirname(__FILE__)))), "ruby").to_s()[5..-1] 
if File.exists?( ruby_lib_path ) 
  LIB_PATH = File.join(File.dirname(File.dirname(File.dirname(File.dirname(__FILE__))))).to_s()[5..-1] 
else 
  LIB_PATH = 'lib' 
end

require "swt_wrapper"


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

  Tray.instance.run

rescue Exception => e
  puts e.message
  puts e.backtrace
  App.report( e.message + "\n" + e.backtrace.join("\n"), nil, {:show_reset_button => true} )
  App.display.dispose

end
