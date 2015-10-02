require 'rspec'

module RSpec
  module Core
    class World
      alias_method :rspec_register, :register

      # @api private
      #
      # Register an example group.
      def register(example_group)
        @caps ||= ::SauceRSpec.config.caps

        examples     = example_group.examples
        new_examples = []
        examples.each do |ex|
          @caps.each do |cap|
            ex_with_cap = ex.clone
            ex_with_cap.instance_variable_set(:@id, ex_with_cap.id + cap.to_s)
            ex_with_cap.instance_eval "def caps; #{cap}; end"
            new_examples << ex_with_cap
          end
        end

        example_group.instance_variable_set(:@examples, new_examples)

        # invoke original register method
        rspec_register(example_group)
      end
    end
  end
end
