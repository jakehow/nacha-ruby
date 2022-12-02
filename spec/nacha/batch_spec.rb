# frozen_string_literal: true

require "test_helper"

describe "Nacha::Batch" do
  describe "#iat?" do
    describe "iat header is set" do
      let(:raw_data) do
        "5200                FF3               USX111222333IATEDI PYMNTSUSDUSD2207292101091000010000445"
      end

      let(:header) { IatBatchHeaderRecord.parse(raw_data, skip_validation: true) }
      let(:subject) { Batch.new(header: header) }

      it "should be true" do
        value(subject.iat?).must_equal true
      end
    end

    describe "non iat header is set" do
      let(:raw_data) do
        "5200                FF3               USX111222333IATEDI PYMNTSUSDUSD2207292101091000010000445"
      end

      let(:header) { BatchHeaderRecord.parse(raw_data, skip_validation: true) }
      let(:subject) { Batch.new(header: header) }

      it "should be false" do
        value(subject.iat?).must_equal false
      end
    end
  end

  describe "#generate" do
    describe "valid batch: single IAT credit" do
      let(:header) { IatBatchHeaderRecord.new }
      let(:entries) { [IatEntryDetailRecord.new] }
      let(:control) { BatchControlRecord.new }
      let(:subject) { Batch.new(header: header, entries: entries, control: control) }

      it "should generate valid data" do
        subject.generate
        value(subject.validate).must_equal true
      end
    end
  end
end
