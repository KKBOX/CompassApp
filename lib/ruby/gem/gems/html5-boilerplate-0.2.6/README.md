Compass Html5 Boilerplate
=========================

HTML5 Boilerplate is a Compass extension based on HTML5 Boilerplate by Paul Irish.
You can use it to kick-start fully compliant HTML5 applications. Generate either
stand-alone HTML5 projects, or Rails applications with fully integrated HTML5
Haml and Sass (Scss) templates.

Browse [html5boilerplate.com](http://html5boilerplate.com) for the full workup.

Rails Installation
==================

    gem install html5-boilerplate
    cd my_rails_project
    compass init rails -r html5-boilerplate -u html5-boilerplate --force

**This will install the following files in your rails project:**  
(Using `--force` flag will overwrite any files that may already exist. In most cases this is probably what you want.)

    app/views/layouts/application.html.haml
    app/views/layouts/_flashes.html.haml
    app/views/layouts/_footer.html.haml
    app/views/layouts/_head.html.haml
    app/views/layouts/_header.html.haml
    app/views/layouts/_javascripts.html.haml
    app/views/layouts/_stylesheets.html.haml
    
    app/stylesheets/style.scss
    app/stylesheets/handheld.scss
    app/stylesheets/partials/_base.scss
    app/stylesheets/partials/_example.scss
    app/stylesheets/partials/_page.scss
    
    public/404.html
    public/.htaccess
    public/crossdomain.xml
    public/robots.txt
    public/apple-touch-icon.png
    public/favicon.ico

    public/javascripts/dd_belatedpng.js
    public/javascripts/jquery-1.4.4.min.js
    public/javascripts/modernizr-1.6.min.js
    public/javascripts/plugins.js
    public/javascripts/rails.js
    public/javascripts/profiling/charts.swf
    public/javascripts/profiling/config.js
    public/javascripts/profiling/yahoo-profiling.css
    public/javascripts/profiling/yahoo-profiling.min.js
    
    config/compass.rb
    config/initializers/compass.rb
    config/google.yml
    config/nginx.conf
    config/mime.types

The Scss files above will automatically get compiled to your Sass compilation directory:

    public/stylesheets/style.css
    public/stylesheets/handheld.css

**Note:** If you already have a config/compass.rb file in your project, you may need to
manually add the following line to the top:

    require 'html5-boilerplate'

### A few more minor points to store into your brainpan...

If you still have an application.html.erb in your layouts, you will need to loose
it now so that Rails will use your shiny new application.html.haml layout instead.

The haml will compile to the equivalent of html5-boilerplate's index.html,
but with all comments stripped out, and some additional rails stuff
like csrf_meta_tags, flashes and the Rails jQuery driver.

You can set your own Google Analytics Account ID and your Google API Key
either as ENV variables, or inside config/google.yml.

This extension has only been tested on Rails3.


Stand Alone Installation
========================

    gem install html5-boilerplate
    compass create my_project -r html5-boilerplate -u html5-boilerplate --javascripts-dir js --css-dir css

The `--javascripts-dir` and `--css-dir` flags are to keep consistent with the original project layout.
If you omit them, be sure to edit your javascript and style tags accordingly in index.html.

**This will create a `my_project` directory containing the following files:**  

    index.html
    404.html
    crossdomain.xml
    robots.txt
    apple-touch-icon.png
    favicon.ico
    
    src/style.scss
    src/handheld.scss
    src/partials/_base.scss
    src/partials/_example.scss
    src/partials/_page.scss
    
    js/dd_belatedpng.js
    js/jquery-1.4.4.min.js
    js/modernizr-1.6.min.js
    js/plugins.js
    js/profiling/charts.swf
    js/profiling/config.js
    js/profiling/yahoo-profiling.css
    js/profiling/yahoo-profiling.min.js
    
    .htaccess
    config.rb
    nginx.conf
    mime.types
    web.config

Run `compass watch my_project` and the SCSS files above will automatically
get compiled to your Sass compilation directory whenever a change is made:

    css/style.css
    css/handheld.css

License
=======

HTML5 Boilerplate by Paul Irish  
(comments left intact in scss files)

Compass Extension Copyright (c) 2010, Peter Gumeson  
[http://creativecommons.org/licenses/by/3.0](http://creativecommons.org/licenses/by/3.0)
