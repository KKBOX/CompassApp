Compass Html5 Boilerplate
=========================

HTML5 Boilerplate is a Compass extension based on HTML5 Boilerplate by Paul Irish.
You can use it to kick-start fully compliant HTML5 applications. Setup your Rails
applications with with fully integrated Haml and Sass/Scss templates that implement
Boilerplate's functionality, or generate stand-alone Html5 Compass projects.

Browse [html5boilerplate.com](http://html5boilerplate.com) for the full workup.

Features
=========
(In addition to Html5 Boilerplate itself)

* Html5 Boilerplate stylesheets implemented as a modularized Compass library
* Lets you pick and choose only the Boilerplate mixins and includes you want
* Generates sass/scss partials to keep your stylesheets organized
* Generates modularized haml layouts for Rails apps (header, footer, flashes, etc.)
* Rails helpers to cleanly hide a little of Boilerplate's html complexity
* Loads minified jQuery in production envs, but uncompressed version in development
* Rails jquery-ujs driver installed and loaded along with jQuery and Modernizr
* Setting API Key in google.yml will auto-load jquery from google (async)
* Setting Analytics ID in google.yml will auto-load google analytics (async)
* Uses content_for hooks to keep all your javascript and stylesheets in one place
* Falls back to native Compass for stuff like clearfix and image replacement
* Fully commented source, but the haml/sass output remains comment free
* Not tested on animals

Rails Installation
==================

First, make sure the following gems are in your Gemfile

    gem "compass"
    gem "haml"
    gem "html5-boilerplate"

Then run the following

    bundle install
    compass init rails -r html5-boilerplate -u html5-boilerplate --force

(Using `--force` flag will overwrite any files that may already exist. In most cases this is probably what you want.)

(For a new project, I answer "Yes" to keep my stylesheets in app/stylesheets, but "No" for compiling them into public/stylesheets/compiled.)

Now remove your application.html.erb so that Haml can do its thing

    mv app/views/layouts/application.html.erb app/views/layouts/application.html.old

Start your Rails server, and you're done!


**Here's a list of the files that compass init installed in your Rails project:**

    app/views/layouts/application.html.haml
    app/views/layouts/_flashes.html.haml
    app/views/layouts/_footer.html.haml
    app/views/layouts/_head.html.haml
    app/views/layouts/_header.html.haml
    app/views/layouts/_javascripts.html.haml
    app/views/layouts/_stylesheets.html.haml
    
    app/stylesheets/style.scss
    app/stylesheets/partials/_base.scss
    app/stylesheets/partials/_overrides.scss
    app/stylesheets/partials/_page.scss
    app/stylesheets/partials/_fonts.scss
    app/stylesheets/partials/_media.scss
    
    public/404.html
    public/.htaccess
    public/crossdomain.xml
    public/robots.txt
    public/humans.txt
    public/apple-touch-icon.png
    public/apple-touch-icon-57x57-precomposed.png
    public/apple-touch-icon-72x72-precomposed.png
    public/apple-touch-icon-114x114-precomposed.png
    public/apple-touch-icon-precomposed.png
    public/favicon.ico
    
    public/javascripts/jquery.min.js
    public/javascripts/modernizr.min.js
    public/javascripts/plugins.js
    public/javascripts/rails.js
    
    config/compass.rb
    config/initializers/compass.rb
    config/google.yml

The Scss files above will automatically get compiled to your Sass compilation directory:

    public/stylesheets/style.css

**Note:** If you already have a config/compass.rb file in your project, you may need to
manually add the following line to the top:

    require 'html5-boilerplate'

### A few more points...

The haml will compile to the equivalent of html5-boilerplate's index.html,
but with all comments stripped out, and some additional rails stuff
like csrf_meta_tags, flashes and the Rails jquery-ujs driver.

You can set your own Google Analytics Account ID and your Google API Key
either as ENV variables, or inside config/google.yml. (see that file)

This extension has only been tested on Rails3.


Stand Alone Installation
========================

Use this if you're not using Rails, but still want compass and the html5-boilerplate sass libraries,
It will create a simplified index.html (with haml source), but without the nice Rails helpers.

    gem install html5-boilerplate
    compass create my_project -r html5-boilerplate -u html5-boilerplate --javascripts-dir js --css-dir css

The `--javascripts-dir` and `--css-dir` flags are to keep consistent with the original project layout.
If you omit them, be sure to edit your javascript and style tags accordingly in index.html.

**This will create a `my_project` directory containing the following files:**  

    index.html
    index.html.haml
    404.html
    crossdomain.xml
    robots.txt
    humans.txt
    apple-touch-icon.png
    apple-touch-icon-57x57-precomposed.png
    apple-touch-icon-72x72-precomposed.png
    apple-touch-icon-114x114-precomposed.png
    apple-touch-icon-precomposed.png
    favicon.ico
    
    src/style.scss
    src/partials/_base.scss
    src/partials/_overrides.scss
    src/partials/_page.scss
    src/partials/_fonts.scss
    src/partials/_media.scss
    
    js/jquery.min.js
    js/modernizr.min.js
    js/plugins.js
    
    .htaccess
    config.rb

Run `compass watch my_project` and the SCSS files above will automatically
get compiled to your Sass compilation directory whenever a change is made:

    css/style.css

License
=======

HTML5 Boilerplate by Paul Irish  
(comments left intact in scss files)

Compass Extension Copyright (c) 2010-2011, Peter Gumeson  
[http://creativecommons.org/licenses/by/3.0](http://creativecommons.org/licenses/by/3.0)
