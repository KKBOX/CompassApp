puts File.join(File.dirname(__FILE__), '../src/ui/tray')

require 'pathname'
puts Pathname.new(__FILE__).realpath

