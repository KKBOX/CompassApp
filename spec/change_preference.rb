
require File.join(File.dirname(__FILE__), '../src/main')
Main.init

require File.join(File.dirname(__FILE__), '../src/ui/tray')
require File.join(File.dirname(__FILE__), 'swtbot_wrapper')
require File.join(File.dirname(__FILE__), 'swtbot_dialog_patch')

require File.join(File.dirname(__FILE__), 'spec_helper.rb')
require 'fileutils'

bot = SwtBot.new(Tray.instance.shell, Tray.instance.menu)

bot.menu('Preference...').click
pre_bot = SwtBot.new( bot.shell('Preference').widget, Tray.instance.menu)
pre_bot.tabItem('Services').activate
pre_bot.checkBox('Enable Web Server').click
pre_bot.close

Main.run_tray