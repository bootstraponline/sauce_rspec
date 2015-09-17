require_relative 'spec_helper'

describe 'one' do
  it 'one' do
    puts 'test one'
    fail if rand > 0.50
  end
end
