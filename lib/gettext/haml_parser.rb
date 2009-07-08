# Haml gettext parser module
# http://pastie.org/445297

require 'gettext/tools/rgettext'
require 'gettext/parser/ruby'
require 'haml'

class String
  def escape_single_quotes
    self.gsub(/'/, "\\\\'")
  end
end

class Haml::Engine
  # Overriden function that parses Haml tags
  # Injects gettext call for plain text action.
  def parse_tag(line)
    tag_name, attributes, attributes_hashes, object_ref, nuke_outer_whitespace,
      nuke_inner_whitespace, action, value, last_line = super(line)
    @precompiled << "_('#{value.escape_single_quotes}')\n" unless action && action != '!' || action == '!' && value[0..0] == '=' || value.empty?
    [tag_name, attributes, attributes_hashes, object_ref, nuke_outer_whitespace,
        nuke_inner_whitespace, action, value, last_line]
  end
  # Overriden function that producted Haml plain text
  # Injects gettext call for plain text action.
  def push_plain(text)
    @precompiled << "_('#{text.escape_single_quotes}')\n"
  end
  def push_flat(line)
    return super(line) if @gettext_filters.nil? || !@gettext_filters.last
    text = line.unstripped
    return if text == ''
    @precompiled << "_('#{text.escape_single_quotes}')\n"
  end
  def start_filtered(name)
    @gettext_filters ||= []
    @gettext_filters.push( (name == 'markdown') )
    super
  end
  def close_filtered(filter)
    @gettext_filters.pop
    super
  end
end

# Haml gettext parser
module HamlParser
  module_function
 
  def target?(file)
    File.extname(file) == ".haml"
  end
 
  def parse(file, ary = [])
    haml = Haml::Engine.new(IO.readlines(file).join)
    code = haml.precompiled.split(/$/)
    GetText::RubyParser.parse_lines(file, code, ary)
  end
end
 
GetText::RGetText.add_parser(HamlParser)
