require "spec_helper"

include Exceptional::Values

describe Pattern do
  describe :match do
    subject do
      described_class.new(
        pattern: HashMap.new(
          value: {

          }
        )
      )
    end
  end
end
