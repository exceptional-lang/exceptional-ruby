module Exceptional
  module Ast
    ParamListNode = Struct.new(:bindings) do
      def initialize(bindings:)
        @bindings = bindings
      end
    end
  end
end
