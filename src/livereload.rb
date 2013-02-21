require "singleton"
require 'em-websocket'
require 'json'

module EventMachine
  module WebSocket
    class Connection 
      def receive_data(data)
        debug [:receive_data, data]

        if @handler
          @handler.receive_data(data)
        else
          dispatch(data)
        end 
      rescue HandshakeError => e
        debug [:error, e]
        trigger_on_error(e)
        # Errors during the handshake require the connection to be aborted

        #abort # comment for failover normailhttp request

      rescue WebSocketError => e
        debug [:error, e]
        trigger_on_error(e)
        close_websocket_private(1002) # 1002 indicates a protocol error
      rescue => e
        debug [:error, e]
        # These are application errors - raise unless onerror defined
        trigger_on_error(e) || raise(e)
        # There is no code defined for application errors, so use 3000
        # (which is reserved for frameworks)
        close_websocket_private(3000)
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
            ws.send "!!ver:#{1.6}";
            SimpleLivereload.instance.clients << ws
          rescue
            puts $!
            puts $!.backtrace
          end
        end
        ws.onmessage do |msg|
          puts "Browser URL: #{msg}"
        end

        ws.onclose do
          SimpleLivereload.instance.clients.delete ws
          puts "Browser disconnected."
        end

        ws.onerror do |error|
          # for http://help.livereload.com/kb/general-use/using-livereload-without-browser-extensions
          if error.kind_of?(EventMachine::WebSocket::HandshakeError)
            ws.send_data "HTTP/1.1 200 OK\r\n\r\n"+ open(File.join(LIB_PATH, 'javascripts', "livereload.js")).read
            ws.close_connection_after_writing
          else
            ws.about
          end
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
    data = JSON.dump( ['refresh', { :path => URI.escape(File.join(base, relative)),
                     :apply_js_live  => true,
                     :apply_css_live => true,
                     :apply_images_live => true }] )
    @clients.each do |ws|
      EM::next_tick do
        ws.send(data)
      end
    end 
  end 


end

