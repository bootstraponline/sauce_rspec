require 'rspec'

module RSpec
  module Core
    class Example
      # metadata is memoized so define a custom caps method.
      attr_accessor :caps
    end

    class World
      alias_method :rspec_record, :record

      # @api private
      #
      # record an example group.
      def record(example_group)
        # Use upstream record method if we're not configured to run on Sauce
        config = ::SauceRSpec.config
        return rspec_record(example_group) unless config.sauce?

        # must iterate through descendants to handle nested describes
        example_group.descendants.each do |desc_group|
          new_examples = []
          desc_group.examples.each do |ex|
            # Use index to allow multiple duplicate caps to have unique ids
            # ex: 1_firefox, 2_firefox
            config.caps.each_with_index do |cap, index|
              ex_with_cap = ex.clone
              new_id      = "#{ex_with_cap.id}_#{index}_#{cap}"
              ex_with_cap.instance_variable_set(:@id, new_id)
              # can *not* use metadata[:caps] because rspec will memoize the
              # value and then reuse it for all the examples.
              ex_with_cap.caps = cap
              new_examples << ex_with_cap
            end
          end
          desc_group.instance_variable_set(:@examples, new_examples)
        end

        # invoke original record method
        rspec_record(example_group)
      end
    end
  end
end unless RSpec::Core::World.method_defined? :rspec_record
