# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'blockhole/version'

Gem::Specification.new do |gem|
  gem.name          = "blockhole"
  gem.version       = Blockhole::VERSION
  gem.authors       = ["Christian Schlensker"]
  gem.email         = ["christian@cswebartisan.com"]
  gem.description   = %q{This is a simple caching library inspired by the api of VCR. Currently Redis is the only storage mechanism supported but there are more forthcoming.}
  gem.summary       = %q{Caches the result of heavy blocks.}
  gem.homepage      = ""
  gem.license       = "MIT"

  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]

  gem.add_dependency "redis", '~> 2.1'

  gem.add_development_dependency "rake"
  gem.add_development_dependency 'bundler', '>= 1.0.7'
  gem.add_development_dependency 'rspec', '~> 2.11'
end
