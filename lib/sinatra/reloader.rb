# Reload scripts and reset routes on change
class Sinatra::Reloader < Rack::Reloader
  def safe_load(file, mtime, stderr = $stderr)
    if file == ::Sinatra::Application.app_file
      ::Sinatra::Application.reset!
      ::Sinatra::Application.clear_cache! if ::Sinatra::Application.respond_to? :clear_cache!
      stderr.puts "#{self.class}: reseting routes and cache"
    end
    super
  end
end
