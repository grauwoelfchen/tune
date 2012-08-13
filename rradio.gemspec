# -*- encoding: utf-8 -*-
require File.expand_path('../lib/rradio/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["Yasuhiro Asaka"]
  gem.email         = ["y.grauwoelfchen@gmail.com"]
  gem.description   = %q{rradio is command line interface of radiotray via dbus}
  gem.summary       = %q{rradio includes wrapper commands of radiotray}
  gem.homepage      = ""

  gem.files         = `git ls-files`.split($\)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.name          = "rradio"
  gem.require_paths = ["lib"]
  gem.version       = RRadio::VERSION

  gem.add_dependency 'ruby-dbus'
  gem.add_dependency 'thor'
  gem.add_development_dependency 'rspec'
  gem.add_development_dependency 'fuubar'
end
