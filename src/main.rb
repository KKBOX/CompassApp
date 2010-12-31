require "swt_wrapper.rb"

if Dir.pwd =~ / /
  display  = Swt::Widgets::Display.get_current 
  msgbox=Swt::Widgets::MessageBox.new(Swt::Widgets::Shell.new(display), Swt::SWT::ICON_ERROR| Swt::SWT::OK)
  msgbox.setMessage("Compass.app is running in \n\n#{Dir.pwd}\n\nThis path has space , please move Compass.app to another path")
  msgbox.open
  return 
end

# for mac app bundle
ruby_lib_path = File.join(File.dirname(File.dirname(File.dirname(__FILE__))), "ruby").to_s()[5..-1]
if File.exists?( ruby_lib_path )
  LIB_PATH = File.join(File.dirname(File.dirname(File.dirname(__FILE__)))).to_s()[5..-1]
else
  LIB_PATH = 'lib'
end
# don't use ruby gem add start speed 
# ENV['GEM_HOME']="#{LIB_PATH}/ruby/gem"
# require "rubygems"

gems_path=File.join(LIB_PATH, "ruby", "gem", "gems")
Dir.new( gems_path).entries.reject{|e| e =~ /^\./}.each do |dir|
  $LOAD_PATH.unshift( File.join(gems_path, dir,'lib'))
end
$LOAD_PATH.unshift "."

require 'stringio'
require 'thread'
require "open-uri"
require "yaml"



require "compass"
require "compass/exec"
require "ninesixty"
require "html5-boilerplate"

require "app.rb"
require "compass_patch.rb"
require "tray.rb"

Tray.new.run

