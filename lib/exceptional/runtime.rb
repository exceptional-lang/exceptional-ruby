module Exceptional
  class Runtime
    def initialize(block:)
      @block = block
    end

    def run(context)
      @block.visit(context)
    end
  end
end
