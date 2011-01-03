require "swt_wrapper.rb"

if Dir.pwd =~ / /
  display  = Swt::Widgets::Display.get_current 
  msgbox=Swt::Widgets::MessageBox.new(Swt::Widgets::Shell.new(display), Swt::SWT::ICON_ERROR| Swt::SWT::OK)
  msgbox.setMessage("Compass.app is running in \n\n#{Dir.pwd}\n\nThis path has space , please move Compass.app to another path")
  msgbox.open
  return 
end

# don't use ruby gem add start speed 
#ENV['GEM_HOME']="#{LIB_PATH}/ruby/gem"


require 'stringio'
require 'thread'
require "open-uri"
require "yaml"

require "app.rb"

App.require_compass
begin
  require "ninesixty"
  require "html5-boilerplate"
rescue LoadError
end

require "tray.rb"

Tray.new.run

