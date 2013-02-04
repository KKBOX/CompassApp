require 'spec_helper.rb'
#puts $LOAD_PATH.inspect
#puts Dir.pwd
require '../src/main.rb'

describe Main do
  
  before(:all) do
    # Main.init
  end


  describe "#set_default_encoding" do
    describe "when RUBY_VERSION > '1.9'" do

      if RUBY_VERSION > "1.9"
        it "should let Encoding.default_external be UTF-8" do
          Main.set_default_encoding
          Encoding.default_external.should == Encoding::UTF_8
        end
      end

    end

  end

end