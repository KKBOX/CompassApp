
require '../src/main'
Main.set_lib_path
SWTBOT_LIB_PATH ="#{Main.lib_path}/swtbot"

Dir.glob(File.join(SWTBOT_LIB_PATH, '*.jar')) do |jar|
  require jar
end


class QuietLayout < org.apache.log4j.PatternLayout
  def format(event)
    ""
  end
end

appender = org.apache.log4j.ConsoleAppender.new QuietLayout.new
org.apache.log4j.BasicConfigurator.configure(appender);


class SwtBot

  def initialize(shell, menu)
    @shell = shell
    @menu = menu
    @bot = org.eclipse.swtbot.swt.finder.SWTBot.new @shell
    org.eclipse.swtbot.swt.finder.utils.SWTBotPreferences.PLAYBACK_DELAY = 1000;
  end

  def menu(text, idx = 0)
    com.handlino.swtbot.patch.SWTBotUtils.findSwtBotMenuByMenu(@menu, text, idx)
  end

  def button(text, idx = 0)
    @bot.button(text, idx)
  end

  def ccomboBox(text, idx = 0)
    @bot.ccomboBox(text, idx) # Not typing error, it's `ccomboBox`
  end 

  def checkBox(text, idx = 0)
    @bot.checkBox(text, idx)
  end

  def clabel(text, idx = 0)
    @bot.clabel(text, idx) # Not typing error, it's `clabel`
  end

  def tabItem(text, idx = 0)
    @bot.tabItem(text, idx)
  end

  def shell(text, idx = 0)
    @bot.shell(text, idx)
  end

  def activeShell
    @bot.activeShell
  end

  def activeBot
    self.activeShell.bot
  end

  def bot
    @bot
  end

  def close
    @shell.dispose
  end

end

