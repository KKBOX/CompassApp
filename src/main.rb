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

require "app.rb"

begin
  App.require_compass

  begin
    require "ninesixty"
    require "html5-boilerplate"
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
  App.report( e.message + e.backtrace.join("\n") )
  App.display.dispose

end
