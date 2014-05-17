Compass H5bp
============

This is a Compass extension of HTML5 mixins extracted from v4 of [HTML5 Boilerplate](http://html5boilerplate.com).
This gem provides only the CSS mixins and not the HTML or Javascript templates. This makes sense because any 
implementation of HTML5 Boilerplate should be specific to the language and framework it's built on.

Browse [html5boilerplate.com](http://html5boilerplate.com) for the full workup.

Or, you can read more about compass extensions [here](http://compass-style.org/help/tutorials/extensions/).


Installation
============

Two options: 

---

1) A raw install using gem:

    gem install compass-h5bp

---

2) Or, if using [Bundler](http://gembundler.com/). Place the following line in your Gemfile:

    gem 'compass-h5bp'

Then run:

    $ bundle install


Usage
=====

First, you must add the plugin to your `config.rb` (your Compass configuration file). This can be done be placing an
import line at the top of the file and is required to add the compass plugin to the sass load paths:

    require 'compass-h5bp'
    
Then, inside your SCSS (or Sass) file, you must import the `h5bp` compass library before you can use any of the mixins:

    @import "h5bp";

Then include the mixins that make up the [Normalize portion](http://necolas.github.com/normalize.css) of HTML5
Boilerplate's styles. 

You can include all of Normalize at once:

    @include h5bp-normalize;

 Or pull in only the portions of Normalize you want:

    @include h5bp-display;
    @include h5bp-base;
    @include h5bp-links;
    @include h5bp-typography;
    @include h5bp-lists;
    @include h5bp-embeds;
    @include h5bp-figures;
    @include h5bp-forms;
    @include h5bp-tables;

Next you can include the opinionated default base styles:

    @include h5bp-base-styles;

You can include the default Html5 Boilerplate Chrome Frame notification styling:

    @include h5bp-chromeframe;

Now you can define your own custom CSS here.

Then (optionally) let H5bp define some semantic helper classes. (e.g. `.clearfix`):

    @include h5bp-helpers;

Finally, you can include H5bp's predefined print style media query:

    @include h5bp-media;


License
=======

[HTML5 Boilerplate](http://html5boilerplate.com), created by by Paul Irish and Divya Manian.

Copyright (c) 2012 Peter Gumeson.
See [LICENSE](https://github.com/sporkd/compass-h5bp/blob/master/LICENSE) for full license.
