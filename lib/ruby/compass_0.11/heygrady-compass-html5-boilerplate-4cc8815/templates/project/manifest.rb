description "Compass extension for HTML5 Boilerplate located at http://html5boilerplate.com"

stylesheet 'style.scss', :media => 'all'
stylesheet 'partials/_base.scss'
stylesheet 'partials/_overrides.scss'
stylesheet 'partials/_fonts.scss'
stylesheet 'partials/_media.scss'
stylesheet 'partials/_page.scss'

if Compass.configuration.project_type == :rails
  file 'application.html.haml', :to => 'app/views/layouts/application.html.haml'
  file '_flashes.html.haml', :to => 'app/views/layouts/_flashes.html.haml'
  file '_footer.html.haml', :to => 'app/views/layouts/_footer.html.haml'
  file '_head.html.haml', :to => 'app/views/layouts/_head.html.haml'
  file '_header.html.haml', :to => 'app/views/layouts/_header.html.haml'
  file '_javascripts.html.haml', :to => 'app/views/layouts/_javascripts.html.haml'
  file '_stylesheets.html.haml', :to => 'app/views/layouts/_stylesheets.html.haml'
  file 'files/google.yml', :to => 'config/google.yml'
  javascript 'javascripts/jquery-1.6.2.js', :to => 'jquery.js'
  javascript 'javascripts/jquery-1.6.2.min.js', :to => 'jquery.min.js'
  javascript 'javascripts/modernizr-2.0.6.min.js', :to => 'modernizr.min.js'
  javascript 'javascripts/plugins.js', :to => 'plugins.js'
  javascript 'javascripts/rails.js', :to => 'rails.js'
else
  html 'index.html.haml'
  file 'index.html.haml'
  javascript 'javascripts/jquery-1.6.2.js', :to => 'jquery-1.6.2.js'
  javascript 'javascripts/jquery-1.6.2.min.js', :to => 'jquery-1.6.2.min.js'
  javascript 'javascripts/modernizr-2.0.6.min.js', :to => 'modernizr-2.0.6.min.js'
  javascript 'javascripts/plugins.js', :to => 'plugins.js'
  javascript 'javascripts/script.js', :to => 'script.js'
end
html 'files/404.html', :to => '404.html'
html 'files/htaccess', :to => '.htaccess'
html 'files/crossdomain.xml', :to => 'crossdomain.xml'
html 'files/robots.txt', :to => 'robots.txt'
html 'files/humans.txt', :to => 'humans.txt'
html 'files/apple-touch-icon.png', :to => 'apple-touch-icon.png'
html 'files/apple-touch-icon-57x57-precomposed.png', :to => 'apple-touch-icon-57x57-precomposed.png'
html 'files/apple-touch-icon-72x72-precomposed.png', :to => 'apple-touch-icon-72x72-precomposed.png'
html 'files/apple-touch-icon-114x114-precomposed.png', :to => 'apple-touch-icon-114x114-precomposed.png'
html 'files/apple-touch-icon-precomposed.png', :to => 'apple-touch-icon-precomposed.png'
html 'files/favicon.ico', :to => 'favicon.ico'

help %Q{
This is a Compass extension for HTML5 Boilerplate by Paul Irish
(See full docs at: http://github.com/sporkd/compass-html5-boilerplate)

Rails Installation
========================
$ gem install html5-boilerplate
$ cd my_rails_project
$ compass init rails -r html5-boilerplate -u html5-boilerplate --force

Stand Alone Installation
========================
$ gem install html5-boilerplate
$ compass create my_project -r html5-boilerplate -u html5-boilerplate --javascripts-dir js --css-dir css

}

welcome_message %Q{
You've installed HTML5 Boilerplate. Good for you!

}
