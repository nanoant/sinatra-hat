# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{sinatra-hat}
  s.version = "0.0.1"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Adam Strzelecki"]
  s.date = %q{2009-07-09}
  s.description = %q{Sinatra Ruby gem extensions for gettext, caching, reloading, etc.}
  s.email = %q{ono@java.pl}
  s.extra_rdoc_files = [
    "README.markdown"
  ]
  s.files = [
    "MIT-LICENSE",
     "README.markdown",
     "Rakefile",
     "VERSION",
     "lib/gettext/date.rb",
     "lib/gettext/haml.rb",
     "lib/gettext/haml_parser.rb",
     "lib/gettext/ruby19_fix.rb",
     "lib/rack/fastcgi_fix.rb",
     "lib/rack/gettext_reloader.rb",
     "lib/sequel/utf8_fix.rb",
     "lib/sinatra-hat.rb",
     "lib/sinatra-hat/string_permalink.rb",
     "lib/sinatra-hat/utils.rb",
     "lib/sinatra/reloader.rb",
     "lib/sinatra/template_cache.rb",
     "test/sinatra-hat_test.rb",
     "test/test_helper.rb"
  ]
  s.homepage = %q{http://github.com/nanoant/sinatra-hat}
  s.rdoc_options = ["--charset=UTF-8"]
  s.require_paths = ["lib"]
  s.rubygems_version = %q{1.3.3}
  s.summary = %q{Sinatra Ruby gem extensions for gettext, caching, reloading, etc.}
  s.test_files = [
    "test/sinatra-hat_test.rb",
     "test/test_helper.rb"
  ]

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 3

    if Gem::Version.new(Gem::RubyGemsVersion) >= Gem::Version.new('1.2.0') then
    else
    end
  else
  end
end