require 'haml'

module WEBrick
  module HTTPServlet

    class HamlHandler < AbstractServlet

      ##
      # Creates a new hamlHandler on +server+ that will evaluate and serve the
      # haml file +name+

      def initialize(server, name)
        super(server, name)
        @script_filename = name
      end

      ##
      # Handles GET requests

      def do_GET(req, res)
        unless defined?(Haml)
          @logger.warn "#{self.class}: Haml not defined."
          raise HTTPStatus::Forbidden, "HamlHandler cannot work."
        end
        begin
          data = open(@script_filename){|io| io.read }
          res.body = evaluate(Haml::Engine.new(data), req, res)
          res['content-type'] ||=
            HTTPUtils::mime_type(@script_filename, @config[:MimeTypes])
        rescue StandardError => ex
          raise
        rescue Exception => ex
          @logger.error(ex)
          raise HTTPStatus::InternalServerError, ex.message
        end
      end

      ##
      # Handles POST requests

      alias do_POST do_GET

      private

      ##
      # Evaluates +haml+ providing +servlet_request+ and +servlet_response+ as
      # local variables.

      def evaluate(haml, servlet_request, servlet_response)
        Module.new.module_eval{
          servlet_request.meta_vars
          servlet_request.query
          haml.render(binding)
        }
      end
    end
  end
end
