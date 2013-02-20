require 'spec_helper'

require '../src/main'
Main.set_default_encoding
Main.set_lib_path
Main.set_config_dir

require '../src/app'
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

Compass::Frameworks::ALL.each do | framework |
  puts framework.name
end


#describe NewProjectTest do

  

#end