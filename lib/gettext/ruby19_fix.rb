# Temporarily fixes gettext error:
# lib/gettext/locale_path.rb:77:in `%': key not found (KeyError) 

if RUBY_VERSION >= "1.9.0"

module GetText
  class LocalePath
    def initialize(name, topdir = nil)
      @name = name
      if topdir
        @locale_paths = ["#{topdir}/%{lang}/LC_MESSAGES/%{name}.mo", "#{topdir}/%{lang}/%{name}.mo"]
      else
        @locale_paths = self.class.default_path_rules
      end
      @locale_paths.map! {|v| v % {:name => name, :lang => '%{lang}'} }
    end
  end
end

end
