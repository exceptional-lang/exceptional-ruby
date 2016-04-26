module Exceptional
  module Ast
    HashNode = Struct.new(:pair_list) do
      def initialize(pair_list:)
        self.pair_list = pair_list
      end

      def eval(environment)
        hash = pair_list.map do |key, value|
          [key.eval(environment), value.eval(environment)]
        end.to_h
        Exceptional::Values::HashMap.new(value: hash)
      end
    end
  end
end
