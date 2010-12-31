description "Compass extention for HTML5 Boilerplate located at http://html5boilerplate.com"

stylesheet 'style.scss', :media => 'all'
stylesheet 'handheld.scss', :media => 'handheld'
stylesheet 'partials/_base.scss'
stylesheet 'partials/_example.scss'
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
  file 'files/nginx.conf', :to => 'config/nginx.conf'
  javascript 'javascripts/dd_belatedpng.js', :to => 'dd_belatedpng.js'
  javascript 'javascripts/jquery-1.4.4.min.js', :to => 'jquery-1.4.4.min.js'
  javascript 'javascripts/modernizr-1.6.min.js', :to => 'modernizr-1.6.min.js'
  javascript 'javascripts/plugins.js', :to => 'plugins.js'
  javascript 'javascripts/rails.js', :to => 'rails.js'
  javascript 'javascripts/profiling/charts.swf', :to => 'profiling/charts.swf'
  javascript 'javascripts/profiling/config.js', :to => 'profiling/config.js'
  javascript 'javascripts/profiling/yahoo-profiling.css', :to => 'profiling/yahoo-profiling.css'
  javascript 'javascripts/profiling/yahoo-profiling.min.js', :to => 'profiling/yahoo-profiling.min.js'
else
  html 'index.html.haml'
  file 'files/nginx.conf', :to => 'nginx.conf'
  file 'files/web.config', :to => 'web.config'
  javascript 'javascripts/dd_belatedpng.js', :to => 'dd_belatedpng.js'
  javascript 'javascripts/jquery-1.4.4.min.js', :to => 'jquery-1.4.4.min.js'
  javascript 'javascripts/modernizr-1.6.min.js', :to => 'modernizr-1.6.min.js'
  javascript 'javascripts/plugins.js', :to => 'plugins.js'
  javascript 'javascripts/profiling/charts.swf', :to => 'profiling/charts.swf'
  javascript 'javascripts/profiling/config.js', :to => 'profiling/config.js'
  javascript 'javascripts/profiling/yahoo-profiling.css', :to => 'profiling/yahoo-profiling.css'
  javascript 'javascripts/profiling/yahoo-profiling.min.js', :to => 'profiling/yahoo-profiling.min.js'
end
html 'files/404.html', :to => '404.html'
html 'files/htaccess', :to => '.htaccess'
html 'files/crossdomain.xml', :to => 'crossdomain.xml'
html 'files/robots.txt', :to => 'robots.txt'
html 'files/apple-touch-icon.png', :to => 'apple-touch-icon.png'
html 'files/favicon.ico', :to => 'favicon.ico'

help %Q{
This is a Compass extention for HTML5 Boilerplate by Paul Irish
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
