module Exceptional
  module Values
    Pattern = Struct.new(:pattern) do
      def initialize(pattern:)
      end

      def match?(value)
        true
      end
    end
  end
end
