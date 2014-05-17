require 'test/unit'
require 'compass'
require 'compass-h5bp'
require 'sass/plugin'
require 'fileutils'

PROJECT_DIR = File.join(File.dirname(__FILE__), 'project')
ORIGINAL_OUTPUT_PATH = File.join(PROJECT_DIR, 'css', 'original.css')
TEST_OUTPUT_PATH = File.join(PROJECT_DIR, 'css', 'test.css')
ORIGINAL_NORMALIZE_OUTPUT_PATH = File.join(PROJECT_DIR, 'css', 'original_normalize.css')
TEST_NORMALIZE_OUTPUT_PATH = File.join(PROJECT_DIR, 'css', 'test_normalize.css')

class CompassH5bpTest < Test::Unit::TestCase
  
  def test_compass_version_matches_original
    FileUtils.rm_f ORIGINAL_OUTPUT_PATH
    FileUtils.rm_f TEST_OUTPUT_PATH
    FileUtils.rm_f ORIGINAL_NORMALIZE_OUTPUT_PATH
    FileUtils.rm_f TEST_NORMALIZE_OUTPUT_PATH
    Compass.reset_configuration!
    Compass.configuration do |config|
      config.environment = :production
      config.project_path = PROJECT_DIR
      config.sass_dir = 'sass'
      config.css_dir = 'css'
      config.cache = false
      config.output_style = :compact
      config.line_comments = false
    end
    args = Compass.configuration.to_compiler_arguments(:logger => Compass::NullLogger.new)
    compiler = Compass::Compiler.new *args
    compiler.run
    original_css = read_and_normalize(ORIGINAL_OUTPUT_PATH)
    test_css = read_and_normalize(TEST_OUTPUT_PATH)
    original_normalize_css = read_and_normalize(ORIGINAL_NORMALIZE_OUTPUT_PATH)
    test_normalize_css = read_and_normalize(TEST_NORMALIZE_OUTPUT_PATH)
    assert_equal original_css, test_css
    assert_equal original_normalize_css, test_normalize_css
  end
  
  def read_and_normalize(file)
    File.open(file).read.
      gsub(/\/\*.+?\*\/\n/m, '').
      gsub(/\n+/, "\n").
      gsub(/\n +/, "\n").
      gsub(/color: white;/, 'color: #ffffff;').
      gsub(/#(.)(.)(.)\b/, '#\1\1\2\2\3\3')
  end
end