module Exceptional
  module Runtime
    class Runtime
      def initialize(block:)
        @block = block
      end

      def run(environment)
        @block.eval(environment)
      end
    end
  end
end
