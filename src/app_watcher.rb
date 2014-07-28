module Compass
  module Watcher
    
    class LivereloadWatch < Watch
      def match?(changed_path)
        @glob.split(/,/).each do  |ext|
          changed_path =~ Regexp.new("#{ext}\\Z")
        end
      end
    end

    class  AppWatcher < ProjectWatcher
      def initialize(project_path, watches=[], options={}, poll=false)
        super
        @watchers << livereload_watchers
        setup_listener
      end

      def listen_callback(modified_files, added_files, removed_files)
        #log_action(:info, ">>> Listen Callback fired added: #{added_files}, mod: #{modified_files}, rem: #{removed_files}", {})
        files = {:modified => modified_files,
                 :added    => added_files,
                 :removed  => removed_files}

        run_once, run_each = watchers.partition {|w| w.run_once_per_changeset?}

        run_once.each do |watcher|
          if file = files.values.flatten.detect{|f| watcher.match?(f) }
            action = files.keys.detect{|k| files[k].include?(file) }
            log_action(:warning, Dir.pwd, {})
            log_action(:warning, project_path.inspect,{})
            watcher.run_callback(project_path, relative_to(file, project_path), action)
          end
        end

        run_each.each do |watcher|
          files.each do |action, list|
            list.each do |file|
              watcher.run_callback(project_path, relative_to(file, project_path), action) if watcher.match?(file)
            end
          end
        end
        java.lang.System.gc()
      end

      def watch!
        compile
        super
      end

      def stop
        log_action(:info, "AppWatcher stop!",{})
        begin
          listener.stop 
        rescue Exception => e
          log_action(:warning, "#{e.message}\n#{e.backtrace}", {})
        end
      end


      def livereload_watchers
        Watcher::LivereloadWatch.new(::App::CONFIG["services_livereload_extensions"], &method(:livereload_callback))
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

      def setup_listener
        @listener = Listen.to(@project_path, :relative_paths => true)
        if poll
          @listener = listener.force_polling(true)
        end 
        @listener = listener.polling_fallback_message(POLLING_MESSAGE)
        #@listener = listener.ignore(/\.css$/) # we dont ignore .css, because we need livereload
        @listener = listener.change(&method(:listen_callback))
      end 

    end
  end
end
