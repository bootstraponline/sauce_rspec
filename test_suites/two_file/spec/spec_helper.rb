require_relative '../../../lib/sauce_rspec'
require_relative 'sauce_helper'
require 'pry'

$test_count = 0

def write_env
  target = RSpec.current_example
  #target = target.respond_to?(:caps) ? target : target.example_group
  #caps = target.respond_to?(:caps) ? target.caps.to_s : ''

  name   = "test_#{$test_count+=1}_" + File.basename(target.id)# + caps
  output = File.expand_path(File.join(__dir__, '..', name))

  File.open(output, 'w') { |f| f.puts target.location }
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
