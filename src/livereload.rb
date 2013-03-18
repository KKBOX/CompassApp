require "singleton"
require 'em-websocket'
require 'json'

module EventMachine
  module WebSocket
    class Connection
      def dispatch(data)
        if data.match(/\A<policy-file-request\s*\/>/)
          send_flash_cross_domain_file
          # we need livereload.js
        elsif data.match(/\AGET \/?livereload.js/)
          send_livereloadjs_file
        else
          @handshake ||= begin
                           handshake = Handshake.new(@secure || @secure_proxy)

                           handshake.callback { |upgrade_response, handler_klass|
                             debug [:accepting_ws_version, handshake.protocol_version]
                             debug [:upgrade_response, upgrade_response]
                             self.send_data(upgrade_response)
                             @handler = handler_klass.new(self, @debug)
                             @handshake = nil 
                             trigger_on_open(handshake)
                           }   

                           handshake.errback { |e| 
                             debug [:error, e]
                             trigger_on_error(e)
                             # Handshake errors require the connection to be aborted
                             abort
                           }   

                           handshake
                         end 

          @handshake.receive_data(data)
        end 
      end 
      def send_livereloadjs_file
        debug [:send_livereloadjs_file, '' ]
        send_data open(File.join(LIB_PATH, 'javascripts', "livereload.js")){|f| f.read}

        # handle the cross-domain request transparently
        # no need to notify the user about this connection
        @onclose = nil
        close_connection_after_writing
      end 

    end
  end
end

class SimpleLivereload
  include Singleton
  attr_accessor :clients

  def initialize
    @clients=[]
  end

  def watch(dir, options)
    start_websocket_server(options)
  end


  def start_websocket_server(options)
    options={
      :host => '0.0.0.0', 
      :port => 35729,
      :debug => false
    }.merge(options)


    Thread.abort_on_exception = true
    @livereload_thread = Thread.new do 
      EventMachine::WebSocket.start( options ) do |ws|
        ws.onopen do
          begin
            puts "Browser connected."; 
            #ws.send "!!ver:#{1.6}";
            SimpleLivereload.instance.clients << ws
          rescue
            puts $!
            puts $!.backtrace
          end
        end
        ws.onmessage do |msg|
          puts "Browser URL: #{msg}"
          begin
            msg = JSON.parse(msg)
            if msg["command"]=='hello'
              ws.send JSON.dump({
                "command"    => 'hello',
                "protocols"  => ['http://livereload.com/protocols/official-7'],
                "serverName" => "Compass.app"
              })
            end
          rescue
          end
        end

        ws.onclose do
          SimpleLivereload.instance.clients.delete ws
          puts "Browser disconnected."
        end
      end
    end
  end

  def unwatch
    if @livereload_thread && @livereload_thread.alive?
      EventMachine::WebSocket.stop
    end
  end

  def alive?
    @livereload_thread && @livereload_thread.alive?
  end

  def send_livereload_msg( base, relative )
    data = JSON.dump( {
      :command => "reload",
      :path    => URI.escape(File.join(base, relative)),
      :liveCSS => true,
    } )
    @clients.each do |ws|
      EM::next_tick do
        ws.send(data)
      end
    end 
  end 


end

