# rubygems
require 'bundler/setup'
require 'pry'

require 'coveralls'
Coveralls.wear!

# internal
require_relative '../../lib/sauce_rspec'
require_relative 'sauce_helper'
