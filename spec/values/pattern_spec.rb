require "spec_helper"

include Exceptional::Values

describe Pattern do
  include ValuesHelper

  describe "#match" do
    context "on simple literal matches" do
      subject do
        described_class.new(
          pattern: [
            [
              v_pat_literal(v_char_string("x")),
              v_pat_literal(v_number(3)),
            ],
          ]
        )
      end

      let(:similar) do
        v_hashmap({
          v_char_string("x") => v_number(3),
        })
      end

      let(:different) do
        v_hashmap({
          v_char_string("y") => v_number(3),
        })
      end

      let(:superset) do
        v_hashmap({
          v_char_string("x") => v_number(3),
          v_char_string("y") => v_number(3),
        })
      end

      it "matches similar hashes" do
        expect(subject.match(similar)).to eq({})
      end

      it "matches superset hashes" do
        expect(subject.match(superset)).to eq({})
      end

      it "doesn't match different hashes" do
        expect(subject.match(different)).to eq(false)
      end
    end

    context "on simple hashes with variable keys" do
      subject do
        described_class.new(
          pattern: [
            [
              v_pat_literal(v_char_string("x")),
              v_pat_variable("y"),
            ],
          ]
        )
      end

      let(:similar) do
        v_hashmap({
          v_char_string("x") => v_number(3),
        })
      end

      let(:different) do
        v_hashmap({
          v_char_string("y") => v_number(3),
        })
      end

      it "matches similar hashes and returns bindings" do
        expect(subject.match(similar)).to eq(
          { "y" => v_number(3) },
        )
      end

      it "doesn't match different hashes" do
        expect(subject.match(different)).to eq(false)
      end
    end

    context "on simple hashes with variable values" do
      subject do
        described_class.new(
          pattern: [
            [
              v_pat_variable("y"),
              v_pat_literal(v_char_string("x")),
            ],
          ]
        )
      end

      let(:similar) do
        v_hashmap({
          v_number(3) => v_char_string("x"),
        })
      end

      let(:different) do
        v_hashmap({
          v_number(3) => v_char_string("y"),
        })
      end

      it "matches similar hashes and returns bindings" do
        expect(subject.match(similar)).to eq(
          { "y" => v_number(3) },
        )
      end

      it "doesn't match different hashes" do
        expect(subject.match(different)).to eq(false)
      end
    end

    context "simple hashes with double bindings" do
      subject do
        described_class.new(
          pattern: [
            [
              v_pat_literal(v_char_string("x")),
              v_pat_variable("y"),
            ],
            [
              v_pat_variable("y"),
              v_pat_literal(v_char_string("y")),
            ],
          ]
        )
      end

      let(:similar) do
        v_hashmap({
          v_char_string("x") => v_number(3),
          v_number(3) => v_char_string("y"),
        })
      end

      let(:different) do
        v_hashmap({
          v_char_string("x") => v_number(3),
          v_number(2) => v_char_string("y"),
        })
      end

      it "matches similar hashes and returns bindings" do
        expect(subject.match(similar)).to eq(
          { "y" => v_number(3) },
        )
      end

      it "doesn't match different hashes" do
        expect(subject.match(different)).to eq(false)
      end
    end
  end
end
