

#require 'rspec'
require File.join(File.dirname(__FILE__), '../src/main')
Main.init

require File.join(File.dirname(__FILE__), '../src/ui/tray')
require File.join(File.dirname(__FILE__), 'swtbot_wrapper')
bot = SwtBot.new(Tray.instance.shell, Tray.instance.menu)

require File.join(File.dirname(__FILE__), 'swtbot_dialog_patch')

watch = bot.menu('Watch a Folder...')
puts watch
watch.click

basic = bot.menu('Create Compass Project').menu('blueprint').menu('basic')
puts basic
#basic.click





#puts Tray.instance.dialog
#bot.bot.shells.each do |s|
  #puts s.to_s
#end
  

Compass::Frameworks::ALL.each do | framework |
  next if framework.name =~ /^_/
  next if framework.template_directories.empty?
  #puts framework.name
  framework.template_directories.each do | dir |
    #puts "  "+dir.to_s
  end
end

Main.run_tray
