
module Compass
  module Commands
    class UpdateProject
      def new_compiler_instance(additional_options = {})
        compiler_opts = Compass.sass_engine_options
        compiler_opts.merge!(:quiet => options[:quiet],
                             :force => options[:force],
                             :sass_files => explicit_sass_files,
                             :dry_run => options[:dry_run],
                             :logger => options[:logger])
        compiler_opts.merge!(additional_options)
        Compass::Compiler.new(working_path,
                              Compass.configuration.sass_path,
                              Compass.configuration.css_path,
                              compiler_opts)
      end
    end
    class WatchProject 

      def perform # we remove  Signal.trap("INT"), add version check on configuration.watches
        check_for_sass_files!(new_compiler_instance)
        recompile
        require 'fssm'
        if options[:poll]
          require "fssm/backends/polling"
          # have to silence the ruby warning about chaning a constant.
          stderr, $stderr = $stderr, StringIO.new
          FSSM::Backends.const_set("Default", FSSM::Backends::Polling)
          $stderr = stderr
        end

        action = FSSM::Backends::Default.to_s == "FSSM::Backends::Polling" ? "polling" : "watching"

        puts ">>> Compass is #{action} for changes. Press Ctrl-C to Stop."

        begin
          FSSM.monitor do |monitor|
            Compass.configuration.sass_load_paths.each do |load_path|
              load_path = load_path.root if load_path.respond_to?(:root)
              next unless load_path.is_a? String
              monitor.path load_path do |path|
                path.glob '**/*.s[ac]ss'

                path.update &method(:recompile)
                path.delete {|base, relative| remove_obsolete_css(base,relative); recompile(base, relative)}
                path.create &method(:recompile)
              end
            end
            if Compass::VERSION.to_f >= 0.11
              Compass.configuration.watches.each do |glob, callback|
                monitor.path Compass.configuration.project_path do |path|
                  path.glob glob
                  path.update do |base, relative|
                    puts ">>> Change detected to: #{relative}"
                    callback.call(base, relative)
                  end
                  path.create do |base, relative|
                    puts ">>> New file detected: #{relative}"
                    callback.call(base, relative)
                  end
                  path.delete do |base, relative|
                    puts ">>> File Removed: #{relative}"
                    callback.call(base, relative)
                  end
                end
              end
            end

          end
        rescue FSSM::CallbackError => e
          # FSSM catches exit? WTF.
          if e.message =~ /exit/
            exit
          end
        end

      end
    end
  end

  module Frameworks
    def register_directory(directory)
      loaders = [
        File.join(directory, "compass_init.rb"),
        File.join(directory, 'lib', File.basename(directory)+".rb"),
        File.join(directory, File.basename(directory)+".rb")
      ]
      loader = loaders.detect{|l| File.exists?(l)}
      registered_framework = detect_registration do
        load loader if loader # force reload file, to make sure framework registered
      end
      unless registered_framework
        register File.basename(directory), directory
      end
    end
  end

  class Logger
    def initialize(*actions)
      self.options = actions.last.is_a?(Hash) ? actions.pop : {}
      @display   = self.options[:display]
      @log_dir = self.options[:log_dir] 
      @actions = DEFAULT_ACTIONS.dup
      @actions += actions
    end

    # Record an action that has occurred
    def record(action, *arguments)
      msg = "#{action_padding(action)}#{action} #{arguments.join(' ')}"
      if App::CONFIG["notifications"].include?(action)
        App.notify( msg.strip, @display )
      end
      log( msg )
    end

    def emit(msg)
      log(msg)
    end

    def log(msg)
      puts msg
      if App::CONFIG["save_notification_to_file"] && @log_dir
        @logfile = open(@log_dir + '/compass_app_log.txt','a+') unless @logfile
        @logfile.puts Time.now.strftime("%Y-%m-%d %H:%M:%S") + " " + msg
        @logfile.flush
      else
        @logfile.close if @logfile
        @logfile = nil
      end
    end
  end

  class Compiler

    # Compile one Sass file
    def compile(sass_filename, css_filename)
      start_time = end_time = nil 
      css_content = logger.red do
        timed do
          engine(sass_filename, css_filename).render
        end 
      end 
      duration = options[:time] ? "(#{(css_content.__duration * 1000).round / 1000.0}s)" : ""
      write_file(css_filename, css_content, options.merge(:force => true, :extra => duration))
      Compass.configuration.run_callback(:stylesheet_saved, css_filename ) 

      # PATCH: write wordlist File
      sass_filename_str = sass_filename.gsub(/[^a-z0-9]/i, '_')
      File.open( File.join( App::AUTOCOMPLTETE_CACHE_DIR, sass_filename_str + "_project" ), 'w' ) do |f|
        f.write Compass.configuration.project_path
      end

      File.open( File.join( App::AUTOCOMPLTETE_CACHE_DIR, sass_filename_str + "_mixin" ), 'w' ) do |f|
        ::Sass::Tree::MixinDefNode.mixins.uniq.sort.each do |name|
          f.puts "\"#{name}\""
        end
      end

      File.open( File.join( App::AUTOCOMPLTETE_CACHE_DIR, sass_filename_str + "_variable" ), 'w' ) do |f|
        ::Sass::Tree::VariableNode.variables.uniq.sort.each do |name|
          f.puts "\"$#{name}\""
        end
      end
    end 
  end
end


default_path = File.join( java.lang.System.getProperty("user.home"), '.compass','extensions' )

if File.exists?( default_path ) 
  App.scan_library( default_path )
  Compass::Frameworks.discover( default_path ) 
end 


