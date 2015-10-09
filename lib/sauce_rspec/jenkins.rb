require 'rubygems'
require 'curb'
require 'json'

module SauceRSpec
  class << self
    attr_reader :driver

    # Fully initialized Selenium Webdriver.
    def driver= driver
      fail 'Driver must not be nil' unless driver
      @driver                             = driver

      # Attach session_id to the current RSpec example.
      example                             = RSpec.current_example
      session_id                          = driver.session_id
      example.metadata[:session_id]       = session_id
      example.metadata[:full_description] += " - https://saucelabs.com/beta/tests/#{session_id}"
    end

    def run_after_test_hooks timeout: 60, stdout: $stdout
      jenkins(stdout) if jenkins?
      update_job_status_on_sauce(timeout) if SauceRSpec.config.sauce?
    end

    # Returns the caps for the current RSpec example with the Sauce Labs
    # job name set.
    def update_example_caps
      example = RSpec.current_example
      meta    = example.metadata

      # Store a copy of the original description if it's not already saved.
      unless meta[:old_full_description]
        meta[:old_description]      = example.description
        meta[:old_full_description] = example.full_description
      end

      # Reset the description to ensure previous runs don't mess with the value
      meta[:description]      = meta[:old_description]
      meta[:full_description] = meta[:old_full_description]

      caps             = example.caps
      full_description = example.full_description

      browser                  = caps[:browserName].capitalize
      version                  = caps[:platformVersion] || caps[:version]
      platform                 = caps[:platformName] || caps[:platform]

      # Set Sauce Labs job_name
      browser_version_platform = [browser, version, '-', platform].join ' '
      caps[:name]              = [full_description, '-', browser_version_platform].join ' '

      # Add browser info to full description for RSpec progress reporter.
      meta[:full_description]  += "\n#{' ' * 5 + browser_version_platform}"
      meta[:description]       += " - #{browser_version_platform}"

      caps
    end

    private

    attr_reader :update_job

    # @param timeout <Integer> timeout in seconds to wait for sauce labs response
    def update_job_status_on_sauce timeout
      # https://docs.saucelabs.com/reference/rest-api/#update-job
      # https://saucelabs.com/rest/v1/:username/jobs/:job_id
      config = SauceRSpec.config
      user   = config.user
      unless update_job
        key = config.key

        request                 = Curl::Easy.new('')
        request.http_auth_types = :basic
        request.username        = user
        request.password        = key

        @update_job = request
      end

      passed = RSpec.current_example.exception.nil?
      passed = { passed: passed }
      url    = "https://saucelabs.com/rest/v1/#{user}/jobs/#{driver.session_id}"

      update_job.url = url

      wait_true(timeout) do
        update_job.http_put passed.to_json
        response = JSON.parse(update_job.body_str) rescue {}
        response_passed = response['passed']
        response_error  = response['error'] || ''

        if response_error.include? 'Not authorized'
          fail(::Errno::ECONNREFUSED, response_error)
        end

        response_passed == passed[:passed] ? true : fail(response)
      end
    end

    def jenkins stdout
      session_id = driver.session_id
      job_name   = RSpec.current_example.full_description
      # https://github.com/jenkinsci/sauce-ondemand-plugin/blob/2dbf9cf057d03480d020050a842aa23f595e4a3d/src/main/java/hudson/plugins/sauce_ondemand/SauceOnDemandBuildAction.java#L44
      stdout.puts "SauceOnDemandSessionID=#{session_id} job-name=#{job_name}"
    end
  end
end
