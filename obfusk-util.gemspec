require File.expand_path('../lib/obfusk/util/version', __FILE__)

Gem::Specification.new do |s|
  s.name        = 'obfusk-util'
  s.homepage    = 'https://github.com/obfusk/rb-obfusk-util'
  s.summary     = 'miscellaneous utility library for ruby'

  s.description = <<-END.gsub(/^ {4}/, '')
    miscellaneous utility library for ruby

    ...
  END

  s.version     = Obfusk::Util::VERSION
  s.date        = Obfusk::Util::DATE

  s.authors     = [ 'Felix C. Stegerman' ]
  s.email       = %w{ flx@obfusk.net }

  s.license     = 'GPLv2'

  s.files       = %w{ .yardopts README.md Rakefile } \
                + %w{ obfusk-util.gemspec } \
                + Dir['{lib,spec}/**/*.rb']

  s.add_development_dependency 'rake'
  s.add_development_dependency 'rspec'

  s.required_ruby_version = '>= 1.9.1'
end
