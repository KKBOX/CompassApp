require 'spec_helper.rb'
require File.join(File.dirname(__FILE__), '../src/main')

describe Main do
  
  before(:all) do
    # Main.init

  end


  describe "#set_default_encoding" do
    describe "when RUBY_VERSION > '1.9', exec Main.set_default_encoding" do

      if RUBY_VERSION > "1.9"
        it "should let Encoding.default_external be UTF-8" do
          Main.set_default_encoding
          Encoding.default_external.should == Encoding::UTF_8
        end
      end

    end

    describe "when exec Main.set_lib_path" do
      
      it "should let Main.lib_src not be empty" do
        Main.set_lib_path
        Main.lib_path.should_not be_empty
        $LOAD_PATH.include?('src').should be_true
      end

    end

    describe "when exec Main.require_lib" do 

    end

    describe "when exec Main.set_config_dir" do 

    end

    describe "when exec Main.init_app" do 

    end

    describe "when exec Main.run_tray" do 

    end

  end
end