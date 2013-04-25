require 'rubygems'
require 'rspec'
require 'faker'
require 'fileutils'

require File.join(File.dirname(__FILE__), '../src/main')
Main.init

require File.join(File.dirname(__FILE__), '../src/ui/tray')
require File.join(File.dirname(__FILE__), 'lib/swtbot_wrapper')
require File.join(File.dirname(__FILE__), 'lib/swtbot_dialog_patch')






