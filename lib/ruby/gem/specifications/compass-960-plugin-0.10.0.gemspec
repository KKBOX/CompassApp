# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{compass-960-plugin}
  s.version = "0.10.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 1.3.5") if s.respond_to? :required_rubygems_version=
  s.authors = ["Chris Eppstein"]
  s.date = %q{2010-06-07}
  s.description = %q{The 960 Grid System is an effort to streamline web development workflow by providing commonly used dimensions, based on a width of 960 pixels. http://960.gs/}
  s.email = %q{chris@eppsteins.net}
  s.files = ["compass-960-plugin.gemspec", "README.mkdn", "lib/ninesixty.rb", "stylesheets/960/_grid.sass", "stylesheets/960/_text.sass", "templates/project/grid.sass", "templates/project/manifest.rb", "templates/project/text.sass"]
  s.homepage = %q{http://github.com/chriseppstein/compass-960-plugin}
  s.require_paths = ["lib"]
  s.rubyforge_project = %q{compass-960-plugin}
  s.rubygems_version = %q{1.3.6}
  s.summary = %q{Compass compatible Sass port of 960.gs.}

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 3

    if Gem::Version.new(Gem::RubyGemsVersion) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<compass>, [">= 0.10.0"])
    else
      s.add_dependency(%q<compass>, [">= 0.10.0"])
    end
  else
    s.add_dependency(%q<compass>, [">= 0.10.0"])
  end
end
