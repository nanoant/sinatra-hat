# Sinatra 0.9.x Haml template cache module

# Caches Haml templates in Class instance "render_haml_#{template}" methods,
# avoiding reparsing and recompiling of the template on every page reload.

class Sinatra::Base
  # Override function responsible for calling internal Haml rendering routines
  def haml(template, options={}, locals={})
    method = "render_haml_#{template}".to_sym
    return super(template, options, locals) unless self.respond_to? method
    locals = options.delete(:locals) || locals || {}
    if options[:layout] != false
      __send__(:render_haml_layout, locals) { __send__(method, locals) }
    else
      __send__(method, locals)
    end
  end
  def render_haml(template, data, options, locals, &block)
    method = "render_haml_#{template}".to_sym
    ::Haml::Engine.new(data, options).def_method(self.class, method, *(locals.keys))
    __send__(method, locals, &block)
  end
  def self.clear_cache!
    instance_methods.grep(/^render_haml_/).each{|m| remove_method m}
  end
  def clear_cache!; self.class.clear_cache! end
end
