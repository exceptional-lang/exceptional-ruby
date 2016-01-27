module Exceptional
  module Ast
    HashNode = Struct.new(:pair_list) do
      def initialize(pair_list:)
        @pair_list = pair_list
      end
    end
  end
end
