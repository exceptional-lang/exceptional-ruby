module Exceptional
  module Ast
    ImportNode = Struct.new(:name) do
      def initialize(name:)
        # raise if more than one name
        self.name = name
      end

      def eval(environment)
        file_name = name.eval(environment)
        raise unless file_name.is_a?(Exceptional::Values::CharString)

        if import = native_import[file_name.value]
          return import.exports
        end

        local_import(file_name)
      end

      private

      def local_import(file_name)
        import_env = Exceptional.new_environment
        import_env.lexical_scope.local_set(
          "export", Exceptional::Values::HashMap.new(value: {})
        )
        import_env.stackframe.setup_handler(
          pattern: pattern,
          block_node: block_node,
          parent_scope: import_env.lexical_scope,
        )
        source = File.read(Pathname.new(".").join(file_name.value + ".!"))
        import_ast = Exceptional.parse(source)
        import_ast.eval(import_env)
        import_env.lexical_scope.get("export")
      end

      def native_import
        {
          "io" => Exceptional::Runtime::Stdlib::Io,
        }
      end

      def pattern
        Exceptional::Values::Pattern.new(
          pattern: [
            [
              Exceptional::Values::Pattern::Literal.new(
                value: Exceptional::Values::CharString.new(value: "export"),
              ),
              Exceptional::Values::Pattern::Variable.new(name: "export_value")
            ],
          ]
        )
      end

      def block_node
        Exceptional::Ast::BlockNode.new(
          expressions: [
            AssignNode.new(
              binding_name: IdentifierNode.new(name: "export"),
              value: IdentifierNode.new(name: "export_value"),
            ),
          ],
        )
      end
    end
  end
end
