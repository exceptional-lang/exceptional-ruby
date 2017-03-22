module Exceptional
  module Runtime
    module Stdlib
      module Io
        class << self
          def exports
            exports = {
              "read" => method(:read),
              "socket" => method(:socket)
            }.map do |export_name, func|
              [
                Exceptional::Values::CharString.new(value: export_name),
                Exceptional::Runtime::NativeFunction.new(block: func),
              ]
            end.to_h
            Exceptional::Values::HashMap.new(value: exports)
          end

          private

          def read(environment, arguments)
            Exceptional::Values::CharString.new(value: File.read(arguments.first.value))
          end

          def socket(environment, arguments)
          end
        end
      end
    end
  end
end
