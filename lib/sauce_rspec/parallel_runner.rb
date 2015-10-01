# Simple test to verify the Runner proxy functionality works as expected
require 'parallel_tests'

ParallelTests::RSpecDynamic::Runner.proxy = Class.new do
  class << self
    def process_options options
      puts 'process options!'
      # options.merge!(env: env) # sauce rspec gem has to calculate the options
    end

    # todo: group by sauce env
    #
    # code from parallel_tests gem
    # finds all tests and partitions them into groups
    def tests_in_groups(tests, num_groups, options={})
      tests = tests_with_size(tests, options)
      Grouper.in_even_groups_by_size(tests, num_groups, options)
    end
  end
end

=begin
roadmap:

 - run test_suites/spec via parallel_tests fork.
 - run test_suites/spec multiplied by environment count.





# --type rspec_dynamic
#
# # can set custom env options
# def process_options options
#   # options.merge!(env: env)
# end
#
# # from test/runner.rb
# # finds all tests and partitions them into groups
# def tests_in_groups(tests, num_groups, options={})
#
#   # todo: reject empty groups
#   # todo: respond to groups.index -- Sauce::TestBroker
# end

=end
