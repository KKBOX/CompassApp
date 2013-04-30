require "singleton"
require "webrick";


class SimpleHTTPServer
  include Singleton
  include WEBrick
  def start(dir, options)
    mime_types = WEBrick::HTTPUtils::DefaultMimeTypes
    mime_types.store 'js', 'application/javascript'
    mime_types.store 'svg', 'image/svg+xml'
    mime_types.store 'mp3', 'audio/mpeg'
    mime_types.store 'mp4', 'video/mp4'
    mime_types.store 'ogv', 'video/ogg'
    mime_types.store 'webm', 'video/webm'

    options={
      :Port => 24680,
      :MimeTypes => mime_types
    }.merge(options)
    stop
    @http_server = HTTPServer.new(options) unless @http_server
    @http_server_thread = Thread.new do 
      @http_server.mount("/",HTTPServlet::FileHandler, dir,  {
        :FancyIndexing => true
      });
      
      @http_server.start
    end
  end

  def stop
    @http_server.shutdown if @http_server
    @http_server = nil 
    @http_server_thread.kill if @http_server_thread && @http_server_thread.alive?
  end

end

