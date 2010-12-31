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
  end

  class Logger
    def initialize(*actions)
      self.options = actions.last.is_a?(Hash) ? actions.pop : {}
      @display   = self.options[:display]
      @log_dir = self.options[:log_dir] 
      @logfile = open(@log_dir + '/compass_app_log.txt','a+') if @log_dir
      @actions = DEFAULT_ACTIONS.dup
      @actions += actions
    end

    # Record an action that has occurred
    def record(action, *arguments)
      msg = "#{action_padding(action)}#{action} #{arguments.join(' ')}"
      App.notify(msg.strip, @display) if action == :error
      log msg
    end
    
     def emit(msg)
	log(msg)
     end

    def log(msg)
      puts msg
      if  @logfile
        @logfile.puts Time.now.strftime("%Y-%m-%d %H:%M:%S") + " " + msg
        @logfile.flush
      end
    end
  end

end
