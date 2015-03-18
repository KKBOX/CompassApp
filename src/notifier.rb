
require "terminal-notifier"

class Notifier

	@@default_options = {:title => "Compass.app"}

	def self.notify(msg, options = {})
		options = @@default_options.merge(options)
		TerminalNotifier.notify(msg, options) #if org.jruby.platform.Platform::IS_MAC 
	end

	def self.is_support
    org.jruby.platform.Platform::IS_MAC && TerminalNotifier.available?
	end

end
