# Haml gettext module providing gettext translation for all Haml plain text
# calls
# http://pastie.org/445295

class Haml::Engine
  # Inject _ gettext into plain text and tag plain text calls
  def push_plain(text)
    super(_(text))
  end
  def parse_tag(line)
    tag_name, attributes, attributes_hashes, object_ref, nuke_outer_whitespace,
      nuke_inner_whitespace, action, value, last_line = super(line)
    value = _(value) unless action && action != '!' || action == '!' && value[0..0] == '=' || value.empty?
    # translate inline ruby code too
    value.gsub!(/_\('([^']+)'\)/) {|m| '\''+_($1)+'\''} unless action != '=' || value.empty?
    attributes_hashes.each{|h| h.each{|v| v.gsub!(/_\('([^']+)'\)/){|m| '\''+_($1)+'\''} if v.is_a? String} unless h.nil? || h.empty?} unless attributes_hashes.nil? || attributes_hashes.empty?
    [tag_name, attributes, attributes_hashes, object_ref, nuke_outer_whitespace,
        nuke_inner_whitespace, action, value, last_line]
  end
  def push_flat(line)
    return super(line) if @gettext_filters.nil? || !@gettext_filters.last
    text = line.full.dup
    text = "" unless text.gsub!(/^#{@flat_spaces}/, '')
    text = _(text) if text != ''
    @filter_buffer << "#{text}\n"
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
