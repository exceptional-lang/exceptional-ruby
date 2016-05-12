module Exceptional
  module Values
    Pattern = Struct.new(:pattern) do
      def initialize(pattern:)
        self.pattern = pattern
      end

      def match?(test_value)
        return true if pattern.value == test_value
        unmatched = pattern.value.reject do |key, value|
          test_value.value[key] == value
        end
        return true if unmatched.empty?
        false
      end

      Literal = Struct.new(:value) do
        def initialize(value:)
          self.value = value
        end
      end

      Variable = Struct.new(:name) do
        def initialize(name:)
          self.name = name
        end
      end
    end
  end
end
