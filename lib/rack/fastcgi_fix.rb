# PATH_INFO and QUERY_STRING may not be defined when using lighttpd with server.error-handler-404 trick
class Rack::Handler::FastCGI
  class <<self
    alias rack_serve serve
    def serve(request, app)
      env = request.env
      parts = env['REQUEST_URI'].to_s.split('?')
      env['SCRIPT_NAME'] = ''
      env['PATH_INFO'] = parts[0] if env['PATH_INFO'] == ''
      env['QUERY_STRING'] = parts[1..-1].join('?') if parts.length > 1 && env['QUERY_STRING'] == ''
      rack_serve(request, app)
    end
  end
end
