require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe Lemonade::SassExtensions::Functions::Lemonade do
  before :each do
    @sass = Sass::Environment.new
    $lemonade_sprites = nil
    $lemonade_margin_bottom = nil
    FileUtils.cp_r File.dirname(__FILE__) + '/images', IMAGES_TMP_PATH
  end
  
  after :each do
    FileUtils.rm_r IMAGES_TMP_PATH
  end
  
  def image_size(file)
    Lemonade::generate_sprites
    IO.read(IMAGES_TMP_PATH + '/' + file)[0x10..0x18].unpack('NN')
  end
  
  def evaluate(value)
    Sass::Script::Parser.parse(value, 0, 0).perform(@sass).to_s
  end
  
  it "should return the sprite file name" do
    evaluate('sprite-image("sprites/30x30.png")').should == "url('/sprites.png')"
  end
  
  it "should also work with `sprite-img`" do
    evaluate('sprite-img("sprites/30x30.png")').should == "url('/sprites.png')"
  end
  
  it "should work in folders with dashes and underscores" do
    evaluate('sprite-image("other_images/more-images/sprites/test.png")').should ==
      "url('/other_images/more-images/sprites.png')"
  end
  
  it "should not work without any folder" do
    lambda { evaluate('sprite-image("test.png")') }.should raise_exception(Sass::SyntaxError)
  end
  
  it "should set the background position" do
    evaluate('sprite-image("sprites/30x30.png")').should == "url('/sprites.png')"
    evaluate('sprite-image("sprites/150x10.png")').should == "url('/sprites.png') 0 -30px"
    image_size('sprites.png').should == [150, 40]
  end
  
  it "should use the X position" do
    evaluate('sprite-image("sprites/30x30.png", 5px, 0)').should == "url('/sprites.png') 5px 0"
    image_size('sprites.png').should == [30, 30]
  end
  
  it "should calculate 20px empty space between sprites" do
    # Resulting sprite should look like (1 line = 10px height, X = placed image):
    
    # X
    # 
    # 
    # XX
    # XX
    # 
    # 
    # XXX
    # XXX
    # XXX
    
    evaluate('sprite-image("sprites/10x10.png")').should == "url('/sprites.png')"
    # space before #2: 20px
    evaluate('sprite-image("sprites/20x20.png", 0, 0, 20px)').should == "url('/sprites.png') 0 -30px"
    # space after #2: 20px
    evaluate('sprite-image("sprites/30x30.png")').should == "url('/sprites.png') 0 -70px"
    image_size('sprites.png').should == [30, 100]
  end
  
  it "should calculate empty space between sprites and combine space like CSS margins" do
    # Resulting sprite should look like (1 line = 10px height, X = placed image):
    
    # X
    # 
    # 
    # 
    # XX
    # XX
    # 
    # XXX
    # XXX
    # XXX
    
    evaluate('sprite-image("sprites/10x10.png", 0, 0, 0, 30px)').should == "url('/sprites.png')"
    # space between #1 and #2: 30px (=> 30px > 20px)
    evaluate('sprite-image("sprites/20x20.png", 0, 0, 20px, 5px)').should == "url('/sprites.png') 0 -40px"
    # space between #2 and #3: 10px (=> 5px < 10px)
    evaluate('sprite-image("sprites/30x30.png", 0, 0, 10px)').should == "url('/sprites.png') 0 -70px"
    image_size('sprites.png').should == [30, 100]
  end
  
  it "should calculate empty space correctly when 2 output images are uses" do
    evaluate('sprite-image("sprites/10x10.png", 0, 0, 0, 30px)').should == "url('/sprites.png')"
    evaluate('sprite-image("other_images/test.png")').should == "url('/other_images.png')"
    evaluate('sprite-image("sprites/20x20.png", 0, 0, 20px, 5px)').should == "url('/sprites.png') 0 -40px"
  end
  
  it "should allow % for x positions" do
    # Resulting sprite should look like (1 line = 10px height, X = placed image):
    
    # XXXXXXXXXXXXXXX
    #               X
    
    evaluate('sprite-image("sprites/150x10.png")')
    evaluate('sprite-image("sprites/10x10.png", 100%)').should == "url('/sprites.png') 100% -10px"
  end
  
  it "should not compose the same image twice" do
    evaluate('sprite-image("sprites/10x10.png")').should == "url('/sprites.png')"
    evaluate('sprite-image("sprites/20x20.png")').should == "url('/sprites.png') 0 -10px"
    evaluate('sprite-image("sprites/20x20.png")').should == "url('/sprites.png') 0 -10px" # reuse image from line above
    image_size('sprites.png').should == [20, 30]
  end
  
end