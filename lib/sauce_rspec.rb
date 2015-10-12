require 'rubygems'
require 'oj'
# Ensure Hash symbols are serialized as JSON strings
# {:passed=>true} => "{\"passed\":true}" not "{\":passed\":true}"
Oj.default_options = { mode: :compat }

require 'webdriver_utils'
require 'addressable/uri'
require 'hurley'
require 'hurley/addressable'

require_relative 'sauce_rspec/version'
require_relative 'sauce_rspec/config'
require_relative 'sauce_rspec/sauce_rspec'
