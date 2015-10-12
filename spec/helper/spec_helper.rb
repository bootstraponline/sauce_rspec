# rubygems
require 'bundler/setup'
require_relative 'trace_helper'

# Ensure specs don't run on Sauce
ENV['SAUCE_USERNAME']  = ''
ENV['AUCE_ACCESS_KEY'] = ''

require 'pry'
require 'ostruct'
require 'webmock/rspec'

require 'coveralls'
Coveralls.wear!

# internal
require_relative '../../lib/sauce_rspec'
require_relative 'sauce_helper'
require_relative 'stub_helper'

RSpec.configure do |config|
  config.include StubHelper
end
