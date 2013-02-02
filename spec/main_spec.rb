require 'spec_helper.rb'
require '../src/main.rb'

describe Main do
  
  before(:all) do
    Main.init
  end


  describe "#set_default_encoding" do
    it "should let Encoding.default_external be UTF-8" do
      Encoding.default_external.should == Encoding::UTF_8
    end


  end

end