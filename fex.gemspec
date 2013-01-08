# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'fex/version'

Gem::Specification.new do |gem|
  gem.name          = "fex"
  gem.version       = Fex::VERSION
  gem.authors       = ["iain"]
  gem.email         = ["iain@iain.nl"]
  gem.description   = %q{Small wrapper around Savon for using FedEx Web Services}
  gem.summary       = %q{Small wrapper around Savon for using FedEx Web Services}
  gem.homepage      = "https://github.com/yourkarma/fex"

  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]

  gem.add_dependency 'savon', '~> 2.0'
  gem.add_development_dependency "rspec"
  gem.add_development_dependency "pry-nav"
end
