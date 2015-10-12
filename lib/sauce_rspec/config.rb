module SauceRSpec
  class Config
    attr_reader :caps, :concurrency_timeout
    attr_accessor :opts, :user, :key, :host, :port

    public

    def initialize
      clear
    end

    # Sauce URL
    def url
      fail 'Missing user' unless user
      fail 'Missing key' unless key
      fail 'Missing host' unless host
      fail 'Missing port' unless port
      "http://#{user}:#{key}@#{host}:#{port}/wd/hub"
    end

    def concurrency_timeout= value
      fail 'concurrency_timeout must be a numeric' unless value.is_a?(Numeric)
      @concurrency_timeout = value
    end

    def caps= value
      fail 'caps must be an array' unless value && value.is_a?(Array)
      @caps = value
    end

    # After defining the specific caps, the default_caps method may be used
    # to add default values to all previously defined caps. If a cap is already
    # present then the default will be ignored.
    def default_caps default
      fail 'default caps must be a hash' unless default && default.is_a?(Hash)
      @caps.each { |cap| cap.merge!(default) { |_key, oldval, _newval| oldval } }
    end

    def clear
      @caps = []
      @opts = {}
      @user = sauce_user
      @key  = sauce_key
      @host = 'ondemand.saucelabs.com'
      @port = '80'
    end

    # We're able to run on sauce if we have a user, key, host, and port
    # caps and opts aren't required to run on sauce because the user may
    # provide the caps outside of the SauceRSpec config.
    def sauce?
      !!(@user && @key && @host && @port)
    end

    def to_h
      {
        caps: @caps.dup,
        opts: @opts.dup,
        user: @user.dup,
        key:  @key.dup,
        host: @host.dup,
        port: @port.dup
      }
    end
  end # class Config

  @config = SauceRSpec::Config.new

  class << self
    def config &block
      return @config unless block_given?
      block.call @config

      # Set test-queue-split workers to the Sauce concurrency limit by default
      test_queue_workers = 'TEST_QUEUE_WORKERS'
      if SauceRSpec.config.sauce? && (!ENV[test_queue_workers] || ENV[test_queue_workers].empty?)
        user                = SauceRSpec.config.user
        hurley_client       = SauceRSpec.hurley_client
        concurrency_url     = "users/#{user}/concurrency"
        concurrency_timeout = SauceRSpec.config.concurrency_timeout || 2 * 60

        wait_true(concurrency_timeout) do
          body = hurley_client.get(concurrency_url).body
          concurrency = body['concurrency'][user]['remaining']['overall'] rescue false
          ENV[test_queue_workers] = concurrency.to_s if concurrency

          concurrency ? true : fail(body)
        end
      end

      @config
    end
  end # class << self
end # module SauceRSpec
