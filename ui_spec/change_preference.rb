

require File.join(File.dirname(__FILE__), 'ui_spec_helper.rb')


bot = SwtBot.new(Tray.instance.shell, Tray.instance.menu)

bot.menu('Preference...').click
pre_bot = SwtBot.new( bot.shell('Preference').widget, Tray.instance.menu)
pre_bot.tabItem('Services').activate
pre_bot.checkBox('Enable Web Server').select
pre_bot.textWithLabel('http://127.0.0.1:').setText('51423')


#pre_bot.close

Main.run_tray