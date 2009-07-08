module GetText
  class Reloader < ::Rack::Reloader
    def initialize(app, cooldown = 10)
      @po = Dir.glob(File.join(File.dirname(__FILE__), '..', 'locale', '**', '*.po'))
      @mo = Dir.glob(File.join(File.dirname(__FILE__), '..', 'locale', '**', '*.mo'))
      @pot = File.join(File.dirname(__FILE__), '..', 'locale', 'rbigg.pot') # Used for locking
      # If there are not translations, give up
      cooldown = nil unless @po && @mo && @po.size > 0 && @mo.size > 0
      super(app, cooldown, Stat)
    end

    def safe_load(file, mtime, stderr = $stderr)
      @translations += 1
      stderr.puts "#{self.class}: reloaded `#{FastGettext.text_domain}' translation `#{file}'"
    ensure
      @mtimes[file] = mtime
    end

    def reload!(stderr = $stderr)
      @translations = 0
      super
      if @translations > 0
        found, stat = safe_stat(@mo.first)
        if found && stat
          File.open(@pot, 'r') do |f|
            # Ensure we don't produce translation twice
            f.flock(File::LOCK_EX)
            found, mstat = safe_stat(@mo.first)
            if found && mstat && mstat.mtime == stat.mtime
              require 'gettext/tools'
              Dir.chdir File.join(File.dirname(__FILE__), '..') do
                GetText.create_mofiles(:po_root => 'locale', :mo_root => 'locale')
              end
            end
            # Reload whole translation
            FastGettext.add_text_domain(FastGettext.text_domain, :path => File.join(File.dirname(__FILE__), '..', 'locale'))
            FastGettext.current_cache = {}
          end
        end
      end
    end

    module Stat
      def rotation
        @po.map{|file|
          found, stat = safe_stat(file)
          next unless found and stat and mtime = stat.mtime
          @cache[file] = found
          yield(found, mtime)
        }.compact
      end

      def safe_stat(file)
        return unless file
        stat = ::File.stat(file)
        return file, stat if stat.file?
      rescue Errno::ENOENT, Errno::ENOTDIR
        @cache.delete(file) and false
      end
    end
  end
end
