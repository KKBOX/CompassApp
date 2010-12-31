$LOAD_PATH.unshift(File.dirname(__FILE__))
$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
require 'lemonade'
require 'spec'
require 'spec/autorun'

IMAGES_TMP_PATH = File.dirname(__FILE__) + '/images-tmp'
Compass.configuration.images_path = IMAGES_TMP_PATH

Spec::Runner.configure do |config|
  
end
