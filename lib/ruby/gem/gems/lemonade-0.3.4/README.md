Lemonade—On the fly sprite generator for Sass/Compass
=====================================================

Please read my [blog post on CSS sprites for Sass/Compass](http://www.hagenburger.net/BLOG/Lemonade-CSS-Sprites-for-Sass-Compass.html) or have a look at the presentation [3 steps to make better and faster frontends](http://www.slideshare.net/hagenburger/3-steps-to-make-better-faster-frontends) (slides 23—37).


**Usage ([SCSS or Sass](http://sass-lang.com/docs/yardoc/file.SASS_REFERENCE.html)):**

    .fanta {
      background: sprite-image("bottles/fanta.png");
    }
    .seven-up {
      background: sprite-image("bottles/seven-up.png");
    }
    .coke {
      background: sprite-image("cans/coke.png") no-repeat;
    }

**Output (CSS):**

    .fanta {
      background: url('/images/bottles.png');
    }
    .seven-up {
      background: url('/images/bottles.png') 0 -50px;
    }
    .coke {
      background: url('/images/cans.png') no-repeat;
    }


Background
----------

* Generates a sprite image for each folder (e. g. “bottles” and “cans”)
* Sets the background position (unless “0 0”)
* It uses the `images_dir` defined by Compass (just like `image-url()`)
* No Rake task needed
* No additional classes
* No configuration
* No RMagick required (but full support for PNG)


Installation
------------

    gem install lemonade
    

Current State
-------------

* Compass standalone finished
* Rails Sass integration finished
* Staticmatic integration finished
* Haml integration (with “:sass” filter): work in progress


Options
-------

You can pass an additional background position.
It will be added to the calculated position:

    .seven-up {
      background: sprite-image("bottles/seven-up.png", 12px, 3px);
    }

Output (assuming the calculated position would be “0 -50px” as shown above):

    .seven-up {
      background: url('/images/bottles.png') 12px -47px;
    }

If you need empty space around the current image, this will add 20px transparent space above and below.

    .seven-up {
      background: sprite-image("bottles/seven-up.png", 0, 0, 20px);
    }
    
This one adds 20px above, 30px below:
    
    .seven-up {
      background: sprite-image("bottles/seven-up.png", 0, 0, 20px, 30px);
    }

Right aligned images are possible:

    .seven-up {
      background: sprite-image("bottles/seven-up.png", 100%, 4px);
    }
    
The original image will be placed on the right side of the sprite image.
Use this, if you have a link with an arrow on the right side (like Apple).


Note on Patches/Pull Requests
-----------------------------

* Fork the project.
* Make your feature addition or bug fix.
* Add tests for it. This is important so I don't break it in a
  future version unintentionally.
* Commit, do not mess with rakefile, version, or history.
  (if you want to have your own version, that is fine but bump version in a commit by itself I can ignore when I pull)
* Send me a pull request. Bonus points for topic branches.


Rails 3 Troubleshooting
-----------------------

If you want to use Lemonade with Rails 3 Please use this compass and haml versions in your Gemfile

    gem 'compass',     '0.10.2'
    gem 'haml-edge',   '3.1.49', :require => 'haml'


Copyright
---------

Copyright (c) 2010 [Nico Hagenburger](http://www.hagenburger.net).
See MIT-LICENSE for details.
[Follow me](http://twitter.com/hagenburger) on twitter.
