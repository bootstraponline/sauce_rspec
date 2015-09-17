require_relative '../../../lib/sauce_rspec'
require_relative 'sauce_helper'

require 'rspec/retry'

RSpec.configure do |config|
  config.verbose_retry = true # show retry status in spec process
  config.default_retry_count = 3
end

