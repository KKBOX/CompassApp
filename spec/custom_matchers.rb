



def class_exists?(class_name)  
  eval("defined?(#{class_name}) && #{class_name}.is_a?(Class)") == true  
end  

def module_exists?(module_name)
  eval("defined?(#{module_name}) && #{module_name}.is_a?(Module)") == true  
end



require 'rspec'

RSpec::Matchers.define :be_a_class_name do 
  match do |actual|
    class_exists?(actual.to_s)
  end
end


RSpec::Matchers.define :be_a_module_name do 
  match do |actual|
    module_exists?(actual.to_s)
  end
end
