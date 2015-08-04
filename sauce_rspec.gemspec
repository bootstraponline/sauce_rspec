# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'sauce_rspec/version'

Gem::Specification.new do |spec|
  spec.name          = "sauce_rspec"
  spec.version       = SauceRspec::VERSION
  spec.authors       = ["bootstraponline"]
  spec.email         = ["code@bootstraponline.com"]

  spec.summary       = 'Sauce rspec integration'
  spec.description   = spec.summary += '.'
  spec.homepage      = 'https://github.com/bootstraponline/sauce_rspec'


  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.9"
  spec.add_development_dependency "rake", "~> 10.0"
end
