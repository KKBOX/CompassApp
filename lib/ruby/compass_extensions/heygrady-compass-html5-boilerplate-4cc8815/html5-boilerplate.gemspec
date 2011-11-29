# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.version = "2.0.0"
  s.date = "2011-11-19"

  s.name = "html5-boilerplate"
  s.authors = ["Peter Gumeson", "Grady Kuhnline"]
  s.summary = %q{A Compass extension based on Paul Irish's HTML5 Boilerplate}
  s.description = %q{A Compass extension based on Paul Irish's HTML5 Boilerplate at http://html5boilerplate.com}
  s.email = "gumeson@gmail.com"
  s.homepage = "http://github.com/sporkd/compass-html5-boilerplate"

  s.files = %w(README.md LICENSE VERSION)
  s.files += %w(templates/project/files/htaccess)
  s.files += Dir.glob("lib/**/*.*")
  s.files += Dir.glob("stylesheets/**/*.*")
  s.files += Dir.glob("templates/**/*.*")

  s.has_rdoc = false
  s.require_paths = ["lib"]
  s.rubygems_version = %q{1.7.2}
  s.add_dependency("compass", [">= 0.11.1"])
end
