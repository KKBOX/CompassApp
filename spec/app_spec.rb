require 'spec_helper'


require '../src/main.rb'
Main.set_default_encoding
Main.set_lib_path
Main.set_config_dir

require '../src/app.rb'
describe App do 
  
  before(:all) do

  end

  describe "when get App.get_config" do 
    config = App.get_config
    
    it "should not be empty" do
      config.should_not be_empty
    end
    
    it "should include needed attr" do

      [ "show_welcome",
        "use_version",
        "use_specify_gem_path",
        "notifications",
        "save_notification_to_file",
        "services",
        "services_http_port",
        "services_livereload_port",
        "services_livereload_extensions",
        "preferred_syntax",
        "force_enable_fsevent"].each do |attr|
          config.should include(attr)
      end

    end

    it "it's attr 'services_http_port' should >= 0" do
      config['services_http_port'].to_i.should be >= 0
    end


    it "it's attr 'services_livereload_port' should >= 0" do
      config['services_livereload_port'].to_i.should be >= 0
    end
  end
  
  describe "when exec require_compass" do

    App.require_compass

    it "should have module 'Compass'" do
      'Compass'.should be_a_module_name
    end
  end
end