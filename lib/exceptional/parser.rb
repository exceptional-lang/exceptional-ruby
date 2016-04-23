module Exceptional
  class Parser < Exceptional::GeneratedParser
    class << self
      def parse(tokens)
        new(tokens).do_parse
      end
    end

    protected

    def initialize(tokens)
      @tokens = tokens
    end

    def next_token
      @tokens.shift
    end
  end
end
