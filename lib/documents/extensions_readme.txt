Install Compass Extension
=========================

Compass.app uses Compass extension as project template. If you put Compass extensions inside this folder, Compass.app will try to load it when the application starts.

For more detailed information, please refer: https://github.com/kkbox/CompassApp/wiki/Use-compass-extensions


Create Your Own Project Template
================================

It is very easy to create your own project template. You can create a folder here with the directory structure:

extension_name
|- templates
   |- template_name
      |- some.html
      |- some.scss
      |- some_other.scss
      |- some.png
      |- some_other.png
      |- manifest.rb (optional)

If you do not have a manifest.rb, Compass will use "easy mode" and put everything in the right place.

For more detailed information, please refer: http://compass-style.org/help/tutorials/extensions/

You can also download our sample project template and give it a try: https://github.com/kkbox/compass-handlino
