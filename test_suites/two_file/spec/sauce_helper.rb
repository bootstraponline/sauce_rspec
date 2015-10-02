require 'bundler/setup'
require 'sauce_platforms'

SauceRSpec.config do |config|
  config.caps = [
    Platform.windows_8.firefox.v37,
    Platform.mac_10_11.safari.v8_1
  ]
end
