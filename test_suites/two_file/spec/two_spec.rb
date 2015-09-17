require_relative 'spec_helper'

describe 'two' do
  it 'two' do
    puts 'test two'
    fail if rand > 0.50
  end
end
