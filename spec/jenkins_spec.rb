require_relative 'helper/spec_helper'

describe 'SauceRSpec Jenkins' do
  before do
    SauceRSpec.config.clear
    SauceRSpec.config do |config|
      config.user = 'appium_user'
      config.key  = 'appium_key'
    end
  end

  def stub_run_after_test_hooks
    passed_true_json = '{"passed":true}'

    stub_request(:put, 'https://appium_user:appium_key@saucelabs.com/rest/v1/appium_user/jobs/123')
      .with(body: passed_true_json)
      .to_return(body: passed_true_json)
  end

  def stub_run_after_test_hooks_error
    passed_true_json = '{"passed":true}'

    stub_request(:put, 'https://appium_user:appium_key@saucelabs.com/rest/v1/appium_user/jobs/123')
      .with(body: passed_true_json)
      .to_return(body: '{"error": "Not authorized"}')
  end

  it 'integrates with Jenkins properly' do
    ENV['JENKINS_SERVER_COOKIE'] = 'true'
    SauceRSpec.driver            = Class.new do
      def session_id
        '123'
      end
    end.new

    stdout = StringIO.new

    # Verify connection refused error returns immediately
    stub_run_after_test_hooks_error
    expect { SauceRSpec.run_after_test_hooks timeout: 999, stdout: stdout }.to raise_error ::Errno::ECONNREFUSED

    # make sure running the hook more than once works as expected.
    stub_run_after_test_hooks
    SauceRSpec.run_after_test_hooks timeout: 1, stdout: stdout

    stub_run_after_test_hooks
    # clear StringIO
    stdout.rewind
    stdout.truncate 0
    SauceRSpec.run_after_test_hooks timeout: 1, stdout: stdout

    actual_data = stdout.string.strip
    stdout.close

    expected_data = 'SauceOnDemandSessionID=123 job-name=SauceRSpec Jenkins' +
    ' integrates with Jenkins properly - https://saucelabs.com/beta/tests/123'
    expect(actual_data).to eq(expected_data)
  end
end
