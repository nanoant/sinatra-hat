# Temporarily fixes Sequel Ruby 1.9 error:
# Encoding::CompatibilityError - incompatible character encodings:
#   UTF-8 and ASCII-8BIT
# Since all variables are returned as ASCII-8BIT

if RUBY_VERSION >= "1.9.0"

class Sequel::Model
  def self.load(row)
    row.values.each{|v| v.force_encoding('utf-8') if v.is_a?(String)}
    super(row)
  end
end

end
