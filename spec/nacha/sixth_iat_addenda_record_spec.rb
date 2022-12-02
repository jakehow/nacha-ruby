# frozen_string_literal: true

require "test_helper"

describe "Nacha::SixthIatAddendaRecord" do
  describe ".parse" do
    describe "valid record" do
      let(:raw_data) do
        "715GDX001212301234913 Barton Route                                                     0091889"
      end
      let(:subject) { SixthIatAddendaRecord.parse(raw_data, skip_validation: true) }

      it "should be valid" do
        value(subject.validate).must_equal true
      end

      it "should have no errors" do
        subject.validate
        value(subject.errors).must_be_empty
      end

      it "should have the correct raw data" do
        value(subject.raw_data).must_equal raw_data
      end

      it "should set the record type code" do
        value(subject.record_type_code).must_equal "7"
      end

      it "should set the addenda type code" do
        value(subject.addenda_type_code).must_equal "15"
      end

      it "should set the receiver identification number" do
        value(subject.receiver_identification_number).must_equal "GDX001212301234"
      end

      it "should set the receiver street address" do
        value(subject.receiver_street_address).must_equal "913 Barton Route"
      end

      it "should set the entry detail sequence number" do
        value(subject.entry_detail_sequence_number).must_equal "0091889"
      end
    end
  end

  describe "#generate" do
    describe "valid record" do
      let(:subject) do
        SixthIatAddendaRecord.new(
          receiver_identification_number: "GDX001212301234",
          receiver_street_address: "913 Barton Route",
          entry_detail_sequence_number: 91_889
        )
      end

      before { subject.generate }

      it "should have no errors" do
        subject.validate
        value(subject.errors).must_be_empty
      end

      it "should be valid" do
        value(subject.validate).must_equal true
      end

      it "should generate valid data" do
        value(subject.raw_data).must_equal "715GDX001212301234913 Barton Route                                                     0091889"
      end
    end
  end

  describe "#to_h" do
    let(:subject) do
      SixthIatAddendaRecord.new(
        receiver_identification_number: "GDX001212301234",
        receiver_street_address: "913 Barton Route",
        entry_detail_sequence_number: 91_889
      )
    end

    it "should return a hash" do
      value(subject.to_h).must_be_kind_of Hash
    end

    it "should return a hash with the correct value" do
      h = {
        record_type_code: "7",
        addenda_type_code: "15",
        receiver_identification_number: "GDX001212301234",
        receiver_street_address: "913 Barton Route",
        entry_detail_sequence_number: 91_889
      }
      value(subject.to_h).must_equal h
    end
  end
end
