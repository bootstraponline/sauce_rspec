require 'rspec'

module RSpec
  module Core
    class Example
      # metadata is memoized so define a custom caps method.
      attr_accessor :caps
    end

    class World
      alias_method :rspec_register, :register

      # @api private
      #
      # Register an example group.
      def register(example_group)
        # Use upstream register method if we're not configured to run on Sauce
        config = ::SauceRSpec.config
        return rspec_register(example_group) unless config.sauce?

        # must use `descendant_filtered_examples` to ensure all examples
        # including those from nested example groups are included.
        examples     = example_group.descendant_filtered_examples
        new_examples = []
        examples.each do |ex|
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

        example_group.instance_variable_set(:@examples, new_examples)

        # invoke original register method
        rspec_register(example_group)
      end
    end
  end
end unless RSpec::Core::World.method_defined? :rspec_register
