module Exceptional
  class Parser < Exceptional::GeneratedParser
    def initialize(tokens)
      @tokens = tokens
    end

    def parse
      do_parse
    end

    def next_token
      @tokens.shift
    end
  end
end
