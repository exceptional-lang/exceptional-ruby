module Exceptional
  module Ast
    PairListNode = Struct.new(:pairs) do
      def initialize(pairs:)
        @pairs = pairs
      end
    end
  end
end
