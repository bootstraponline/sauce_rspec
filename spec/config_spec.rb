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
    custom_value   = '1'
    custom_2_value = '2'
    SauceRSpec.config do |config|
      config.opts[:sauce_custom]   = custom_value
      config.opts[:sauce_custom_2] = custom_2_value
    end

    actual_opts   = SauceRSpec.config.opts
    expected_opts = { sauce_custom: custom_value, sauce_custom_2: custom_2_value }

    expect(actual_opts).to eq(expected_opts)
  end

  it 'supports first class options' do
    user_value = 'some user'
    key_value  = 'some key'
    port_value = 'some port'
    host_value = 'some host'
    SauceRSpec.config do |config|
      config.user = user_value
      config.key  = key_value
      config.port = port_value
      config.host = host_value
    end

    actual_config = SauceRSpec.config

    expected_config = OpenStruct.new(user: user_value,
                                     key:  key_value,
                                     port: port_value,
                                     host: host_value)

    expect(actual_config.user).to eq(expected_config.user)
    expect(actual_config.key).to eq(expected_config.key)
    expect(actual_config.port).to eq(expected_config.port)
    expect(actual_config.host).to eq(expected_config.host)
  end
end