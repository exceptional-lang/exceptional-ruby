module Exceptional
  module Ast
    PatternNode = Struct.new(:value) do
      def initialize(value:)
        self.value = value
      end

      def eval(environment)
        pattern_value(value, environment)
      end

      private

      def build_pattern(pair_list, environment)
        Exceptional::Values::Pattern.new(
          pattern: pair_list.map do |key, value|
            [
              pattern_value(key, environment),
              pattern_value(value, environment),
            ]
          end
        )
      end

      def pattern_value(value, environment)
        case value
        when IdentifierNode
          Exceptional::Values::Pattern::Variable.new(name: value.name)
        when HashNode
          build_pattern(value.pair_list, environment)
        else
          Exceptional::Values::Pattern::Literal.new(value: value.eval(environment))
        end
      end
    end
  end
end
