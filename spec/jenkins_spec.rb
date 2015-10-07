require_relative 'helper/spec_helper'

describe ' SauceRSpec Jenkins' do
  before do
    SauceRSpec.config.clear
    SauceRSpec.config do |config|
      config.user = 'appium_user'
      config.key  = 'appium_key'
    end
  end

  def stub_run_after_test_hooks
    passed_true_json = %q({"passed":true})

    stub_request(:put, 'https://appium_user:appium_key@saucelabs.com/rest/v1/appium_user/jobs/123').
      with(body: passed_true_json).
      to_return(body: passed_true_json)
  end

  it 'integrates with Jenkins properly' do
    ENV['JENKINS_SERVER_COOKIE'] = 'true'
    SauceRSpec.driver            = Class.new do
      def session_id
        '123'
      end
    end.new

    # make sure running the hook more than once works as expected.
    stub_run_after_test_hooks
    SauceRSpec.run_after_test_hooks timeout: 1

    stub_run_after_test_hooks
    stdout = StringIO.new
    SauceRSpec.run_after_test_hooks timeout: 1, stdout: stdout

    stdout.flush
    stdout.rewind
    stdout_data = stdout.read.strip
    stdout.close

    expect(stdout_data).to eq('SauceOnDemandSessionID=123 job-name=integrates with Jenkins properly')
  end
end
