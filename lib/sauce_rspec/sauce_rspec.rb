module SauceRSpec
  class << self
    attr_reader :driver

    MUTEX = Mutex.new
    # from: https://github.com/lostisland/hurley/blob/b61f4c96bcfa4fcd51c6718bc05f13e1c2ba01e6/lib/hurley.rb#L17
    def mutex
      MUTEX.synchronize(&Proc.new)
    end

    # Fully initialized Selenium Webdriver.
    def driver= driver
      fail 'Driver must not be nil' unless driver
      @driver                       = driver

      # Attach session_id to the current RSpec example.
      example                       = RSpec.current_example
      session_id                    = driver.session_id
      example.metadata[:session_id] = session_id
      # don't attach sauce link to description because it messes up
      # the sauce jenkin's plugin ability to match job names to junit names
    end

    def run_after_test_hooks timeout: 60, stdout: $stdout
      jenkins(stdout) if jenkins?
      update_job_status_on_sauce(timeout) if SauceRSpec.config.sauce?
    end

    # Returns the caps for the current RSpec example with the Sauce Labs
    # job name set.
    def update_example_caps
      example                     = RSpec.current_example
      meta                        = example.metadata

      # Store a copy of the original description if it's not already saved.
      meta[:old_description]      = example.description unless meta[:old_description]
      meta[:old_full_description] = example.full_description unless meta[:old_full_description]

      # Reset the description to ensure previous runs don't mess with the value
      meta[:description]          = meta[:old_description]
      meta[:full_description]     = meta[:old_full_description]

      caps             = example.caps
      full_description = example.full_description

      browser                  = caps[:browserName].capitalize
      version                  = caps[:platformVersion] || caps[:version]
      platform                 = caps[:platformName] || caps[:platform]

      # Set Sauce Labs job_name
      browser_version_platform = [browser, version, '-', platform].join ' '
      caps[:name]              = [full_description, '-', browser_version_platform].join ' '

      # Add browser info to description to ensure test names are unique
      # Otherwise the same test run on multiple browsers will not have a different name
      extra_description        = " - #{browser_version_platform}"
      meta[:full_description]  += extra_description
      meta[:description]       += extra_description

      caps
    end

    def hurley_client
      mutex do
        return @hurley_client if @hurley_client
        client                              = @hurley_client = Hurley::Client.new 'https://saucelabs.com/rest/v1/'
        client.header[:content_type]        = 'application/json'
        client.request_options.timeout      = 2 * 60
        client.request_options.open_timeout = 2 * 60

        config              = SauceRSpec.config
        client.url.user     = config.user
        client.url.password = config.key

        # Ensure body JSON string is parsed into a hash
        # Detect errors and fail so wait_true will retry the request
        client.after_call do |response|
          response.body = Oj.load(response.body) rescue {}

          client_server_error = %i(client_error server_error).include? response.status_type
          body_error          = response.body['error']

          if client_server_error || body_error
            response_error = body_error || ''
            fail(::Errno::ECONNREFUSED, response_error)
          end
        end

        @hurley_client
      end
    end

    private

    # @param timeout <Integer> timeout in seconds to wait for sauce labs response
    def update_job_status_on_sauce timeout
      # PUT https://saucelabs.com/rest/v1/:username/jobs/:job_id
      # https://docs.saucelabs.com/reference/rest-api/#update-job
      user           = SauceRSpec.config.user
      passed         = RSpec.current_example.exception.nil?
      passed         = { passed: passed }
      passed_json    = Oj.dump(passed)
      update_job_url = "#{user}/jobs/#{driver.session_id}"

      wait_true(timeout) do
        body = hurley_client.put(update_job_url, passed_json).body
        body['passed'] == passed[:passed] ? true : fail(body)
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
