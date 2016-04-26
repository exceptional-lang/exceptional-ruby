module Exceptional
  module Ast
    RaiseNode = Struct.new(:value) do
      def initialize(value:)
        self.value = value
      end

      def eval(environment)
        handler = find_handler(environment)
        return unless handler
        environment.reset_frame(handler.stackframe)
        handler.call(environment, value)
      end

      private

      def find_handler(environment)
        environment.stackframes.reverse.each do |frame|
          frame.exception_handlers.each do |handler|
            next unless handler.match?(value)
            return handler
          end
        end
        nil
      end
    end
  end
end
