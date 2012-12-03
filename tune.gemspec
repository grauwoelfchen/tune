# -*- encoding: utf-8 -*-
require File.expand_path('../lib/tune/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["Yasuhiro Asaka"]
  gem.email         = ["grauwoelfchen@gmail.com"]
  gem.description   = %q{tune is a command line interface of Radio Tray via dbus}
  gem.summary       = %q{tune is a small controller for Radio Tray}
  gem.homepage      = ""

  gem.files         = `git ls-files`.split($\)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.name          = "tune"
  gem.require_paths = ["lib"]
  gem.version       = Tune::VERSION

  gem.add_dependency 'ruby-dbus'
  gem.add_dependency 'thor'

  gem.add_development_dependency 'rspec'
  gem.add_development_dependency 'fuubar'
  gem.add_development_dependency 'ZenTest'

  # travis
  gem.add_development_dependency 'rake', '~> 0.9.2.2'
  gem.add_development_dependency 'rdoc', '~> 3.11'
end
