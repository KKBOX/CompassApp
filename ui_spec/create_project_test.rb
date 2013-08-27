
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

  describe "create by FileDialog path" do
    it "should exit CompassApp" do
      @bot.menu('Quit').click
    end
  end
end 



