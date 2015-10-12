require_relative 'lib/sauce_rspec/version'

Gem::Specification.new do |spec|
  spec.required_ruby_version = '>= 2.2.2'

  spec.name          = 'sauce_rspec'
  spec.version       = SauceRSpec::VERSION
  spec.date          = SauceRSpec::DATE
  spec.license       = 'http://www.apache.org/licenses/LICENSE-2.0.txt'
  spec.description   = spec.summary = 'Sauce rspec integration'
  spec.description   += '.' # avoid identical warning
  spec.authors       = spec.email = ['code@bootstraponline.com']
  spec.homepage      = 'https://github.com/bootstraponline/sauce_rspec'
  spec.require_paths = ['lib']

  spec.files = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end

  spec.add_runtime_dependency 'rspec', '~> 3.3.0'
  spec.add_runtime_dependency 'webdriver_utils', '~> 1.0.2'
  # Recommended way of doing parallel execution
  spec.add_runtime_dependency 'test-queue-split', '~> 0.3.2'
  spec.add_runtime_dependency 'hurley', '~> 0.2'
  spec.add_runtime_dependency 'addressable', '~> 2.3.8'
  spec.add_runtime_dependency 'oj', '~> 2.12.14'

  spec.add_development_dependency 'webmock', '~> 1.21.0'
  spec.add_development_dependency 'appium_thor', '~> 1.0.1'
  spec.add_development_dependency 'coveralls', '~> 0.8.3'
  spec.add_development_dependency 'pry', '~> 0.10.2'
  spec.add_development_dependency 'sauce_platforms', '~> 2.0.0'
  spec.add_development_dependency 'bundler', '~> 1.10.6'
  spec.add_development_dependency 'rake', '~> 10.4.2'
  spec.add_development_dependency 'rubocop', '~> 0.34.2'
end
