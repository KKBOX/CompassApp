require 'pathname'

# Override DirectoryDialog's open
class Swt::Widgets::DirectoryDialog
  
  attr_accessor :open_path
  @@open_path = Pathname.new(File.join(File.dirname(__FILE__), '..', 'test_project', 'swtbot_watch_test')).realpath

  def self.open_path
    @@open_path
  end

  def self.open_path=(path)
    @@open_path = Pathname.new(path).realpath
  end

  def open
    #Pathname.new(@@open_path).realpath.to_s  
    puts 'DirectoryDialog open: '+@@open_path
    @@open_path
  end
end

# Override FileDialog's open
class Swt::Widgets::FileDialog
  
  attr_accessor :open_path
  @@open_path = Pathname.new(File.join(File.dirname(__FILE__), '..', 'test_project', 'swtbot_create_test')).realpath

  def self.open_path
    @@open_path
  end

  def self.open_path=(path)
    @@open_path = Pathname.new(path).realpath
  end

  def open
    #Pathname.new(@@open_path).realpath.to_s
    puts 'FileDialog open: '+@@open_path
    @@open_path
  end
end

# 
class Report
  def initialize(msg, target_display = nil, options={}, &block)
    puts 'Report show: '+msg
  end
end

#
class Alert
  def initialize(msg, target_display = nil, &block)
    puts 'Alert show: '+msg
  end
end

#
class Notification
  def initialize(msg, target_display = nil )
    puts 'Alert show: '+msg
  end
end

#
class QuitWindow
  def initialize(msg, button_text='Quit')
    puts 'QuitWindow show: '+msg
  end
end

#
class WelcomeWindow
  def initialize()
    puts 'WelcomeWindow show'
  end
end

class SplashWindow
  include Singleton
  def initialize(msg="Starting", target_display = nil, &block)
    puts 'SplashWindow show'
  end

  def replace(msg)
    puts 'Alert replace: '+msg
  end

  def isDisposed
    true
  end

  def dispose
  end
end
