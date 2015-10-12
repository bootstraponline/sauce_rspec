require_relative 'helper/spec_helper'

describe SauceRSpec::Config do
  let(:cap_array) { [Platform.windows_8.firefox.v37] }

  before do
    SauceRSpec.config do |config|
      config.caps                = cap_array
      config.concurrency_timeout = 0.5
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
    config_with_user_key_port_host
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

  it 'converts to a hash successfully' do
    config_with_user_key_port_host
    actual_config = SauceRSpec.config

    expected_hash = { caps: expected_cap_value,
                      opts: {},
                      user: user_value,
                      key:  key_value,
                      host: host_value,
                      port: port_value }
    expect(actual_config.to_h).to eq(expected_hash)
  end

  it 'allows default caps' do
    actual_config = SauceRSpec.config
    expected_caps = expected_cap_value
    expect(actual_config.caps).to eq(expected_caps)

    job_cap = { build: 'job-name-4' }
    SauceRSpec.config.default_caps job_cap
    new_expected_caps = expected_caps.clone.each { |cap| cap.merge!(job_cap) }
    expect(actual_config.caps).to eq(new_expected_caps)

    expect { SauceRSpec.config.default_caps nil }.to raise_exception 'default caps must be a hash'
  end

  it 'supports generating a sauce url' do
    SauceRSpec.config do |config|
      config.user = nil
      config.key  = nil
      config.port = nil
      config.host = nil
    end

    expect { SauceRSpec.config.url }.to raise_error 'Missing user'
    SauceRSpec.config { |c| c.user = 'user1' }
    expect { SauceRSpec.config.url }.to raise_error 'Missing key'
    SauceRSpec.config { |c| c.key = 'key2' }
    expect { SauceRSpec.config.url }.to raise_error 'Missing host'
    SauceRSpec.config { |c| c.host = 'host3' }
    expect { SauceRSpec.config.url }.to raise_error 'Missing port'
    SauceRSpec.config { |c| c.port = 'port4' }

    expect(SauceRSpec.config.url).to eq('http://user1:key2@host3:port4/wd/hub')
  end
end
