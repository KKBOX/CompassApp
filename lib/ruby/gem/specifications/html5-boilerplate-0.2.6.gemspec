# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{html5-boilerplate}
  s.version = "0.2.6"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Peter Gumeson"]
  s.date = %q{2010-11-19}
  s.description = %q{A Compass extension based on Paul Irish's HTML5 Boilerplate at http://html5boilerplate.com}
  s.email = %q{gumeson@gmail.com}
  s.files = ["README.md", "LICENSE", "VERSION", "templates/project/files/htaccess", "lib/app/helpers/html5_boilerplate_helper.rb", "lib/html5-boilerplate.rb", "stylesheets/_html5-boilerplate.scss", "stylesheets/html5-boilerplate/_fonts.scss", "stylesheets/html5-boilerplate/_handheld.scss", "stylesheets/html5-boilerplate/_helpers.scss", "stylesheets/html5-boilerplate/_media.scss", "stylesheets/html5-boilerplate/_reset.scss", "stylesheets/html5-boilerplate/_styles.scss", "templates/project/_flashes.html.haml", "templates/project/_footer.html.haml", "templates/project/_head.html.haml", "templates/project/_header.html.haml", "templates/project/_javascripts.html.haml", "templates/project/_stylesheets.html.haml", "templates/project/application.html.haml", "templates/project/files/404.html", "templates/project/files/apple-touch-icon.png", "templates/project/files/crossdomain.xml", "templates/project/files/favicon.ico", "templates/project/files/google.yml", "templates/project/files/lighttpd.conf", "templates/project/files/mime.types", "templates/project/files/nginx.conf", "templates/project/files/robots.txt", "templates/project/files/web.config", "templates/project/handheld.scss", "templates/project/index.html.haml", "templates/project/javascripts/dd_belatedpng.js", "templates/project/javascripts/jquery-1.4.4.min.js", "templates/project/javascripts/modernizr-1.6.min.js", "templates/project/javascripts/plugins.js", "templates/project/javascripts/profiling/charts.swf", "templates/project/javascripts/profiling/config.js", "templates/project/javascripts/profiling/yahoo-profiling.css", "templates/project/javascripts/profiling/yahoo-profiling.min.js", "templates/project/javascripts/rails.js", "templates/project/manifest.rb", "templates/project/partials/_base.scss", "templates/project/partials/_example.scss", "templates/project/partials/_page.scss", "templates/project/style.scss"]
  s.homepage = %q{http://github.com/sporkd/compass-html5-boilerplate}
  s.require_paths = ["lib"]
  s.rubygems_version = %q{1.3.6}
  s.summary = %q{A Compass extension based on Paul Irish's HTML5 Boilerplate}

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
