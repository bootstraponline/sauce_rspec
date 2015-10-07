module SauceRSpec
  class Config
    attr_reader :caps
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

    def caps= value
      fail 'caps must be an array' unless value && value.is_a?(Array)
      @caps = value
    end

    def clear
      @caps = []
      @opts = {}
      @user = sauce_user
      @key  = sauce_key
      @host = 'ondemand.saucelabs.com'
      @port = '80'
    end

    def sauce?
      @user && @key
    end

    def to_h
      { caps: @caps.dup, opts: @opts.dup }
    end
  end # class Config

  @config = SauceRSpec::Config.new

  class << self
    def config &block
      return @config unless block_given?
      block.call @config
      @config
    end
  end # class << self
end # module SauceRSpec
