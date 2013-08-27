
require File.join(File.dirname(__FILE__), 'lib/helper/ui_spec_helper.rb')

describe "create_project_test" do
  
  bot = SwtBot.new(Tray.instance.shell, Tray.instance.menu)

  describe "click Create Compass Project" do
    it "should create by FileDialog path" do
      bot.menu('Create Compass Project').menu('compass').menu('project').click
    end
    
    it "should create by DirectoryDialog path" do
      _path = Swt::Widgets::FileDialog.open_path
      Swt::Widgets::FileDialog.open_path = Swt::Widgets::DirectoryDialog.open_path

      bot.menu('Create Compass Project').menu('compass').menu('project').click
      
      Swt::Widgets::FileDialog.open_path = _path
    end
  end

  describe "click Quit" do
    it "should exit CompassApp" do
      bot.menu('Quit').click
    end
  end
end 



