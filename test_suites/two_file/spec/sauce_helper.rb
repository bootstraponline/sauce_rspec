require 'bundler/setup'
require 'sauce_platforms'

SauceRSpec.config do |config|
  config.caps = [
    Platform.windows_8.firefox.v37
  ]
end
