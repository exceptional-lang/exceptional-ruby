module Exceptional
  module Ast
    SymbolNode = Struct.new(:name) do
      def initialize(name:)
        @name = name
      end
    end
  end
end
