NOTICE!!! (And Now for Something Completely Different)
=========================================================

If you are using Rails, you should now be using [html5-rails](https://github.com/sporkd/html5-rails) instead of this gem.
It has all you need to get Html5Boilerplate up and running with the Rails 3 asset pipeline, plus a bunch of other nice new conventions.

For the rest of you who still want to use this gem for standalone projects or for older verisons of Rails, here's what you need to know:

* The compass CSS library has been moved out of this gem and into the [compass-h5bp](https://github.com/sporkd/compass-h5bp) gem. This allows both gems to benifit from updates to the compass library.
* The newest version of [compass-h5bp](https://github.com/sporkd/compass-h5bp) uses normalize.css instead of reset, just like current Html5Boilerplate. So upgrading might be a pain.

So in short, I have shifted my efforts to [html5-rails](https://github.com/sporkd/html5-rails), and I now view this gem
as the first standalone implementation of [compass-h5bp](https://github.com/sporkd/compass-h5bp).
To this end I will continue to merge pull requests for those who want to continue using it.

Of course, I encourage anyone to create other implementations of [compass-h5bp](https://github.com/sporkd/compass-h5bp) for [insert your framework here].


About
==========

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
* Fully commented source, but the haml/sass output remains comment free
* Not tested on animals


Installation
========================

(This is for stand-alone. Rails install instructions live on only in the git history)

    gem install html5-boilerplate
    compass create my_project -r compass-h5bp -r html5-boilerplate -u html5-boilerplate --javascripts-dir js --css-dir css

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
    
    js/jquery-1.6.2.min.js
    js/modernizr-2.0.6.min.js
    js/plugins.js
    js/script.js
    
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
