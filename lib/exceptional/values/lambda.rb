module Exceptional
  module Values
    Lambda = Struct.new(:param_list, :block, :lexical_scope) do
      def initialize(param_list:, block:, lexical_scope:)
        self.param_list = param_list
        self.block = block
        self.lexical_scope = lexical_scope
      end

      def call(environment, arguments)
        environment.lexical_scope = Exceptional::Runtime::LexicalScope.new(
          parent_scope: lexical_scope,
        )
        param_list.zip(arguments).each do |binding_name, value|
          environment.lexical_scope.local_set(binding_name, value)
        end
      end
    end
  end
end
