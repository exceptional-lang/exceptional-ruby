require "exceptional/version"
require "pry"

module Exceptional
  require "exceptional/ast"
  require "exceptional/runtime"
  require "exceptional/values"
  require "exceptional/generated_parser"
  require "exceptional/parser"
  require "exceptional/scanner"

  class << self
    def new_environment
      Exceptional::Runtime::Environment.new(
        lexical_scope: Exceptional::Runtime::LexicalScope.new(
          parent_scope: Exceptional::Runtime::LexicalScope::Null,
        )
      )
    end

    def parse(code)
      tokens = Exceptional::Scanner.tokenize(code)
      Exceptional::Parser.parse(tokens)
    end
  end
end
