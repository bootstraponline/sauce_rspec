require_relative 'helper/spec_helper'

describe SauceRSpec::Config do
  let(:cap_array) { [Platform.windows_8.firefox.v37] }

  before do
    SauceRSpec.config do |config|
      config.caps = cap_array
    end
  end

  after do
    SauceRSpec.config.clear
  end

  it 'sets a configuration correctly' do
    expect(SauceRSpec.config.caps).to eq(cap_array)
  end

  it 'clears a configuration correctly' do
    SauceRSpec.config.clear
    expect(SauceRSpec.config.caps).to eq([])
    expect(SauceRSpec.config.opts).to eq({})
  end

  it 'supports custom opts' do
    sauce_user = 'sauce_user'
    sauce_key  = 'sauce_password'
    SauceRSpec.config do |config|
      config.opts[:sauce_username]   = sauce_user
      config.opts[:sauce_access_key] = sauce_key
    end

    actual_opts   = SauceRSpec.config.opts
    expected_opts = { sauce_username: sauce_user, sauce_access_key: sauce_key }

    expect(actual_opts).to eq(expected_opts)
  end
end
