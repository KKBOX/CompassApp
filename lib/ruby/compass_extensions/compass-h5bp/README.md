Compass H5bp
=========================

This is a Compass extension of Html5 mixins extracted from v3 on Html5 Boilerplate
by Paul Irish and Divya Manian. This gem provides only the CSS mixins and not the
html or javascript templates.  This makes sense because any implementation of
Html5 Boilerplate should be specific to the language and framework it's built on.

Browse [html5boilerplate.com](http://html5boilerplate.com) for the full workup.

Or, you can read more about compass extensions [here](http://compass-style.org/help/tutorials/extensions/).


Installation
=========================

    gem install compass-h5bp

Or, in your Gemfile

    gem 'compass-h5bp'

Then run

    $ bundle install


Usage
=========================

Inside your Scss (or Sass) file, you first need to import the `h5bp`
compass library before you can use any of the mixins:

    @import "h5bp";

Then include the mixins that make up the Normalize portion of Html5
Boilerplate's styles. http://necolas.github.com/normalize.css

    @include h5bp-display;
    @include h5bp-selection;
    @include h5bp-base;
    @include h5bp-links;
    @include h5bp-typography;
    @include h5bp-lists;
    @include h5bp-embeds;
    @include h5bp-figures;
    @include h5bp-forms;
    @include h5bp-tables;

Now you can define your own custom CSS here.

Then (optionally) let H5bp define some semantic helper classes. (e.g. `.clearfix`):

    @include h5bp-helpers;

You can include the default Html5 Boilerplate Chrome Frame notification styling:

    @include h5bp-chromeframe;

Finally, you can include H5bp's predefined print style media query:

    @include h5bp-media;


License
========

HTML5 Boilerplate created by by Paul Irish and Divya Manian
http://html5boilerplate.com

Copyright (c) 2012 Peter Gumeson
See [LICENSE](https://github.com/sporkd/compass-h5bp/blob/master/LICENSE) for full license.
