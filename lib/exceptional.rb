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
    def eval(input)
      tokens = Exceptional::Scanner.tokenize(input)
      ast = Exceptional::Parser.parse(tokens)
      env = Exceptional::Runtime::Environment.new(
        lexical_scope: Exceptional::Runtime::LexicalScope.new(
          parent_scope: Exceptional::Runtime::LexicalScope::Null,
        )
      )

      [ast,env]
    end
  end
end
