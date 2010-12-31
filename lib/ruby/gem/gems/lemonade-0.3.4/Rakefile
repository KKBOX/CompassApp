require 'rubygems'
require 'rake'

begin
  require 'jeweler'
  Jeweler::Tasks.new do |gem|
    gem.name = "lemonade"
    gem.summary = "On the fly sprite generator for Sass/Compass"
    gem.description = "Generates sprites on the fly by using `background: sprite-image(\"sprites/logo.png\")`. No Photoshop, no RMagick, no Rake task, save your time and have a lemonade."
    gem.email = "gems@hagenburger.net"
    gem.homepage = "http://github.com/hagenburger/lemonade"
    gem.authors = ["Nico Hagenburger"]
    gem.add_dependency "haml", ">= 3.0.0"
    gem.add_dependency "compass", ">= 0.10.0"
    gem.add_dependency "chunky_png", ">= 0.8.0"
    gem.add_development_dependency "rspec", ">= 1.2.9"
  end
  Jeweler::GemcutterTasks.new
rescue LoadError
  puts "Jeweler (or a dependency) not available. Install it with: gem install jeweler"
end

require 'spec/rake/spectask'
Spec::Rake::SpecTask.new(:spec) do |spec|
  spec.libs << 'lib' << 'spec'
  spec.spec_files = FileList['spec/**/*_spec.rb']
end

Spec::Rake::SpecTask.new(:rcov) do |spec|
  spec.libs << 'lib' << 'spec'
  spec.pattern = 'spec/**/*_spec.rb'
  spec.rcov = true
end

task :spec => :check_dependencies

task :default => :spec

require 'rake/rdoctask'
Rake::RDocTask.new do |rdoc|
  version = File.exist?('VERSION') ? File.read('VERSION') : ""

  rdoc.rdoc_dir = 'rdoc'
  rdoc.title = "lemonade #{version}"
  rdoc.rdoc_files.include('README*')
  rdoc.rdoc_files.include('lib/**/*.rb')
end
