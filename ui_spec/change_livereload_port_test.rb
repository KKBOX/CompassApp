

require File.join(File.dirname(__FILE__), 'ui_spec_helper.rb')
require File.join(File.dirname(__FILE__), 'shared_example/sass_compile_example.rb')


bot = SwtBot.new(Tray.instance.shell, Tray.instance.menu)

describe 'change_livereload_port_test' do


	# chage port 
	bot.menu('Preference...').click
	pre_bot = SwtBot.new( bot.shell('Preference').widget, Tray.instance.menu)
	pre_bot.tabItem('Services').activate
	pre_bot.checkBox('Enable livereload').select
	pre_bot.textWithLabel('Port').setText('42315')
	pre_bot.close

	# test example
	it_should_behave_like 'sass_compile_example'

	after(:all) do
		#bot.close
		#java.lang.System.exit(0)
		#Main.run_tray
	end
end
