Compass::Frameworks.register("html5-boilerplate", :path => "#{File.dirname(__FILE__)}/..") if defined?(Compass)

if defined?(ActionController)
  require File.join(File.dirname(__FILE__), 'app', 'helpers', 'html5_boilerplate_helper')
  ActionController::Base.helper(Html5BoilerplateHelper)
end
