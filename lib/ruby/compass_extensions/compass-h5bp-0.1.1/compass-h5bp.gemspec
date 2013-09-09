# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "compass/h5bp/version"

Gem::Specification.new do |s|
  s.name        = "compass-h5bp"
  s.version     = Compass::H5bp::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Peter Gumeson"]
  s.email       = ["gumeson@gmail.com"]
  s.homepage    = "http://rubygems.org/gems/compass-h5bp"
  s.summary     = %q{ Compass extension for Html5 Boilerplate v4.1 }
  s.description = %q{ Compass extension of Html5 mixins extracted from v4 of the Html5 Boilerplate project (h5bp.com) }

  s.rubyforge_project = "compass-h5bp"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  s.add_dependency("compass")
end
