# encoding: utf-8
require 'iconv'

class Integer
  def minute
    self * 60
  end
  alias minutes minute
  def hour
    minute * 60
  end
  alias hours hour
  def day
    hour * 24 
  end
  alias days day
  def week
    day * 7
  end
  alias weeks week
  def month
    day * 30
  end
  alias months month
  def year
    day * 365
  end
  alias years year
  def ago
    Time.now - self
  end
  def forth
    Time.now + self
  end
end

class Time
  def year_start
    d = (self - (month-1).months - (day-1).days - hour.hours - min.minutes - sec)
    d - (d.day-1).days - d.hour.hours - d.min.minutes - d.sec
  end
  def month_start
    self - (day-1).days - hour.hours - min.minutes - sec
  end
  def week_start
    self - ((wday + 6) % 7).days - hour.hours - min.minutes - sec
  end
  def midnight
    self - hour.hours - min.minutes - sec
  end
  def noon
    midnight + 12.hours
  end
end

class String
  def mail_utf8_subject
    # 4.2 http://tools.ietf.org/html/rfc2047
    '=?UTF-8?Q?'+(self.chomp.gsub(/[^ !-<>-^`-~]/){|m| m.unpack('C*').map{|c| '=%02X' % c}.join}.gsub(/\s/, '_'))+'?='
  end
  def cdata
    "<![CDATA[#{self.gsub(/\]\]>/,']]]]><![CDATA[>')}]]>"
  end
  def md5
    hash = Digest::MD5.new
    hash << self
    hash.hexdigest
  end
  def sha1
    hash = Digest::SHA1.new
    hash << self
    hash.hexdigest
  end
  # This is Pligg style password hash
  def pwdhash(salt=nil)
    salt = String.random_password.md5 if salt.nil?
    salt = salt[0..8]
    salt+(salt+self).sha1
  end
  def excerpt(chars=nil)
    first = split(/(?:\n\r?){2,}/)[0] || ""
    return first if chars.nil?
    words = first.split(' ')
    pos, count = words.inject([0, 0]) do |c, v|
      c[1] + v.length < chars ? [c[0] + 1, c[1] + v.length] : c
    end
    words[0..pos].join(' ') + ((pos == words.size) ? '' : '…')
  end
  def utf8_length
    unpack('U*').length
  end
  def pad(other, extra=0)
    padding = other.utf8_length - utf8_length
    padding = 0 if padding < 0
    ' ' * (padding+extra) + self
  end
  def self.random_password(length=9, strength=0)
    vowels      = 'aeuy'
    consonants  = 'bdghjmnpqrstvz'
    consonants += 'BDGHJLMNPQRSTVWXZ' if strength & 1 != 0
    vowels     += 'AEUY'              if strength & 2 != 0
    consonants += '23456789'          if strength & 4 != 0
    consonants += '@#$%'              if strength & 8 != 0
    password = '';
    alt = rand(2)
    length.times do
      password += consonants[rand(consonants.size - 1)].chr if alt != 0
      password += vowels[rand(vowels.size - 1)].chr         if alt == 0
      alt = 1 - alt
    end
    password
  end
  def comma_split
    CSV.parse_line(gsub(/"\s+,/,'",').gsub(/,\s+"/,',"')).collect{|t| t.strip unless t.nil?}.delete_if{|t| t.nil? || t.empty?}
  end
  # http://gist.github.com/93045
  def to_permalink
    Iconv.iconv('ascii//translit//IGNORE', 'utf-8', self).first.gsub("'", "").gsub(/[^\x00-\x7F]+/, '').gsub(/[^a-zA-Z0-9-]+/, '-').gsub(/--+/, '-').gsub(/^-/, '').gsub(/-$/, '').downcase
  end
end

class Array
  def comma_join
    map{|v| s = v.gsub!(/,/,',') || v.gsub!(/"/,'""'); s ? '"'+v+'"' : v}.join(', ')
  end
end

if defined? Rack
  class Rack::Request
    def url(path=nil)
      url = scheme + "://"
      url << host
      if scheme == "https" && port != 443 ||
        scheme == "http" && port != 80
        url << ":#{port}"
      end
      url << (path ? path : fullpath)
      url
    end
  end
end

def silence_warnings
  old_verbose, $VERBOSE = $VERBOSE, nil
  yield
ensure
  $VERBOSE = old_verbose
end

if RUBY_VERSION < "1.9.0"
  class Symbol
   def to_proc
     proc { |obj, *args| obj.send(self, *args) }
   end
  end
end
