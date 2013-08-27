require 'rubygems'
require 'rspec'
require 'faker'
require 'fileutils'

require File.join(File.dirname(__FILE__), '../root_dir.rb')

require File.join(COMPASSAPP_DIR, 'src/main')
Main.init

require File.join(COMPASSAPP_DIR, 'src/ui/tray')

require File.join(UI_SPEC_DIR, 'lib/swtbot_wrapper')
require File.join(UI_SPEC_DIR, 'lib/swtbot_dialog_patch')





module UiSpecHelper
  extend self

  @bot = SwtBot.new(Tray.instance.shell, Tray.instance.menu)

  def stop_watch
    #Tray.instance.stop_watch
    @bot.regexMenu('^Stop watching ').click
  end

  def quit
    @bot.menu('Quit').click
  end
end


