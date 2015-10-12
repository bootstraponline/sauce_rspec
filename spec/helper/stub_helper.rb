module StubHelper
  def user_value
    'some_user'
  end

  def key_value
    'some_key'
  end

  def port_value
    'some_port'
  end

  def host_value
    'some_host'
  end

  def stub_concurrency_request
    response_json = <<-'JSON'
    {
  "timestamp": 1444671564.115373,
  "concurrency": {
    "some_org": {
      "current": {
        "overall": 0,
        "mac": 0,
        "manual": 0
      },
      "remaining": {
        "overall": 20,
        "mac": 20,
        "manual": 5
      }
    },
    "some_user": {
      "current": {
        "overall": 0,
        "mac": 0,
        "manual": 0
      },
      "remaining": {
        "overall": 20,
        "mac": 20,
        "manual": 5
      }
    }
  }
}
    JSON

    stub_request(:get, "https://#{user_value}:#{key_value}@saucelabs.com/rest/v1/users/#{user_value}/concurrency")
      .with(headers: { 'Content-Type' => 'application/json' })
      .to_return(status: 200, body: response_json)
  end

  def config_with_user_key_port_host
    stub_concurrency_request
    SauceRSpec.config do |config|
      config.user                = user_value
      config.key                 = key_value
      config.port                = port_value
      config.host                = host_value
      config.concurrency_timeout = 0.5
    end
  end

  def expected_cap_value
    [{ browserName: 'firefox', platform: 'Windows 2012', version: '37' }]
  end
end
