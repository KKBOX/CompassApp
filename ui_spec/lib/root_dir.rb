require 'pathname'

UI_SPEC_DIR = Pathname.new(File.join(File.dirname(__FILE__), '..')).realpath
COMPASSAPP_DIR = Pathname.new(File.join(UI_SPEC_DIR, '..')).realpath