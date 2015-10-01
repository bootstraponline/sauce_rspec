# ParallelTests.number_of_running_processes == 0

require 'parallel_tests'
require_relative 'parallel_runner'

module SauceRSpec
  class Parallel
    attr_reader :args

    def initialize *args
      @args = args
    end

    def run
      # invoke 'parallel_rspec' command using rspec_dynamic type
      # to avoid having to monkey patch the parallel tests runner
      ParallelTests::CLI.new.run %w(--type rspec_dynamic) + args
    end
  end
end
