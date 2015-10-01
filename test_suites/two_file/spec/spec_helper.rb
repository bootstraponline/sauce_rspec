require_relative '../../../lib/sauce_rspec'
require_relative 'sauce_helper'
require 'pry'

def write_env
  example = RSpec.current_example
  return unless example.respond_to?(:test_queue_sauce)

  name = example.test_queue_sauce
  output = File.expand_path(File.join(__dir__, '..', name))

  File.open(output, 'w') {}
end

RSpec.configure do |config|
  # sauce gem injects selenium instance at the before each rspec level
  # we can't use a singleton driver since the driver is created/destroyed
  # for every test
  config.before(:each) do
    # todo: access current test metadata
    write_env
  end

end
