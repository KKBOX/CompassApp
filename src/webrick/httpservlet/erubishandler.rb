#
# erubishandler.rb -- erubisHandler Class
#
# Author: IPR -- Internet Programming with Ruby -- writers
# Copyright (c) 2001 TAKAHASHI Masayoshi, GOTOU Yuuzou
# Copyright (c) 2002 Internet Programming with Ruby writers. All rights
# reserved.
#
# $IPR: erubishandler.rb,v 1.25 2003/02/24 19:25:31 gotoyuzo Exp $

require 'webrick/httpservlet/abstract.rb'

require 'erubis'

module WEBrick
  module HTTPServlet

    ##
    # erubisHandler evaluates an erubis file and returns the result.  This handler
    # is automatically used if there are .rhtml files in a directory served by
    # the FileHandler.
    #
    # erubisHandler supports GET and POST methods.
    #
    # The erubis file is evaluated with the local variables +servlet_request+ and
    # +servlet_response+ which are a WEBrick::HTTPRequest and
    # WEBrick::HTTPResponse respectively.
    #
    # Example .rhtml file:
    #
    #   Request to <%= servlet_request.request_uri %>
    #
    #   Query params <%= servlet_request.query.inspect %>

    class ErubisHandler < AbstractServlet

      ##
      # Creates a new erubisHandler on +server+ that will evaluate and serve the
      # erubis file +name+

      def initialize(server, name)
        super(server, name)
        @script_filename = name
      end

      ##
      # Handles GET requests

      def do_GET(req, res)
        unless defined?(Erubis)
          @logger.warn "#{self.class}: Erubis not defined."
          raise HTTPStatus::Forbidden, "ErubisHandler cannot work."
        end
        begin
          data = open(@script_filename){|io| io.read }
          res.body = evaluate(Erubis::Eruby.new(data), req, res)
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
      # Evaluates +erubis+ providing +servlet_request+ and +servlet_response+ as
      # local variables.

      def evaluate(erubis, servlet_request, servlet_response)
        Module.new.module_eval{
          servlet_request.meta_vars
          servlet_request.query
          erubis.result(binding)
        }
      end
    end
  end
end
