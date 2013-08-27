
require File.join(File.dirname(__FILE__), 'lib/helper/ui_spec_helper.rb')

describe "create_project_test" do
  
  bot = SwtBot.new(Tray.instance.shell, Tray.instance.menu)

  describe "create by FileDialog path" do
    it "should new a Compass Project" do
      bot.menu('Create Compass Project').menu('compass').menu('project').click
    end
  end

  describe "create by DirectoryDialog path" do
    it "should new a Compass Project" do
      _path = Swt::Widgets::FileDialog.open_path
      Swt::Widgets::FileDialog.open_path = Swt::Widgets::DirectoryDialog.open_path

      bot.menu('Create Compass Project').menu('compass').menu('project').click
      
      Swt::Widgets::FileDialog.open_path = _path
    end
  end
end 

#bot.menu('Quit').click

=begin
bot = SwtBot.new(Tray.instance.shell, Tray.instance.menu)





#bot.menu('Watch a Folder...').click
#bot.menu('Create Compass Project').menu('blueprint').menu('buttons').click

#puts Tray.instance.dialog



Compass::Frameworks::ALL.each do | framework |
  next if framework.name =~ /^_/
  next if framework.template_directories.empty?
  #puts framework.name
  framework.template_directories.each do | dir |
    #puts "  "+dir.to_s
  end
end


#describe Main do
  #when "create project ''" do
    #it "" do
    #end
  #end
#end
=end


#Main.run_tray


