module Exceptional
  module Values
    CharString = Struct.new(:value) do
      def initialize(value:)
        self.value = value
      end
    end
  end
end
