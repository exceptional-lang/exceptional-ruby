module Exceptional
  module Values
    Pattern = Struct.new(:pattern) do
      def initialize(pattern:)
        self.pattern = pattern
      end

      def match(test_value)
        return false unless test_value.is_a?(Exceptional::Values::HashMap)
        bindings = {}
        pattern.each do |(key, value)|
          match = nil
          test_value.value.each do |other_key, other_value|
            key_match = key.match(other_key)
            value_match = value.match(other_value)
            next unless key_match && value_match
            match = [key_match, value_match].select(&:any?)
            break
          end
          return false unless match
          match.each do |new_values|
            bindings.merge!(new_values) do |_, left, right|
              return false unless left == right
              left
            end
          end
        end

        bindings
      end
    end

    class Pattern
      Literal = Struct.new(:value) do
        def initialize(value:)
          self.value = value
        end

        def match(test_value)
          return {} if test_value == value
          false
        end
      end

      Variable = Struct.new(:name) do
        def initialize(name:)
          self.name = name
        end

        def match(test_value)
          { self.name => test_value }
        end
      end
    end
  end
end
