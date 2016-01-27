module Exceptional
  module Ast
    IdentifierNode = Struct.new(:name) do
      def initialize(name:)
        self.name = name
      end
    end
  end
end
