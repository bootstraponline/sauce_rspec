# ParallelTests.number_of_running_processes == 0

require 'parallel_tests'

module SauceRSpec
  class SauceParallelTests
    attr_reader :args

    def initialize *args
      @args = args
    end

    def run
      # invoke 'parallel_rspec' command
      ParallelTests::CLI.new.run %w(--type rspec) + args
    end
  end
end
