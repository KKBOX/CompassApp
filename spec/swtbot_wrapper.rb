
require '../src/main'
Main.set_lib_path
SWTBOT_LIB_PATH ="#{Main.lib_path}/swtbot"

Dir.glob('#{lib_path}/swtbot/*.jar') do |jar|
  require jar
end


require '../src/ui/swt_wrapper'

module SWTBot

end