module SauceRSpec
  class Config
    attr_reader :caps
    attr_accessor :opts

    def initialize
      clear
    end

    def caps= value
      fail 'caps must be an array' unless value && value.is_a?(Array)
      @caps = value
    end

    def clear
      @caps = []
      @opts = {}
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
