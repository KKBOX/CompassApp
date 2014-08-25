require 'livereload.rb'

class  AppWatcher < Compass::Commands::WatchProject
  def initialize(project_path, options={})
    super

    CompassHooker::WatchHooker.watches += livereload_watchers
    
  end

  def watch!
    perform
    sass_compiler.compile!
  end
  
  def stop
    listener = sass_compiler.compiler.listener

    log_action(:info, "AppWatcher stop!",{})
    begin
      listener.stop if listener and listener.adapter
    rescue Exception => e
      log_action(:warning, "#{e.message}\n#{e.backtrace}", {})
    end

  end


  def custom_watcher(dir, extensions, callback)
    filter = File.join(dir, extensions)
    childe_filter = File.join(dir, "**", extensions)

    [Compass::Configuration::Watch.new(filter, &callback),
     Compass::Configuration::Watch.new(childe_filter, &callback)]
  end

  def livereload_watchers
    watches = []
    App::CONFIG["services_livereload_extensions"].split(/\s*,\s*/).each do |ext|
      watches += custom_watcher("", "*.#{ext}", method(:livereload_callback))
    end
    watches
  end

  def livereload_callback(base, file, action)
    puts ">>> #{action} detected to: #{file}"
    SimpleLivereload.instance.send_livereload_msg( base, file ) if SimpleLivereload.instance.alive?

    if App::CONFIG["notifications"].include?(:overwrite) && action == :modified
      App.notifications << "Changed: #{file}"
    end

    tray = Tray.instance
    tray.shell.display.wake if tray.shell
  end 


end
