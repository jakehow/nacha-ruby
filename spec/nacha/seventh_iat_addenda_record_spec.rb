# frozen_string_literal: true

require "test_helper"

describe "Nacha::SeventhIatAddendaRecord" do
  describe ".parse" do
    describe "valid record" do
      let(:raw_data) do
        '716DHAKA*ZZ\                          BD*A1A1A1\                                       0091889'
      end
      let(:subject) { SeventhIatAddendaRecord.parse(raw_data, skip_validation: true) }

      it "should be valid" do
        value(subject.validate).must_equal true
      end

      it "should have no errors" do
        subject.validate
        value(subject.errors).must_be_empty
      end

      it "should set raw_data" do
        value(subject.raw_data).must_equal raw_data
      end

      it "should set the record type code" do
        value(subject.record_type_code).must_equal "7"
      end

      it "should set the addenda type code" do
        value(subject.addenda_type_code).must_equal "16"
      end

      it "should set the receiver city and state" do
        value(subject.receiver_city_and_state).must_equal "DHAKA*ZZ\\"
      end

      it "should set the receiver country and postal code" do
        value(subject.receiver_country_and_postal_code).must_equal "BD*A1A1A1\\"
      end

      it "should set the entry detail sequence number" do
        value(subject.entry_detail_sequence_number).must_equal "0091889"
      end
    end
  end

  describe "#generate" do
    describe "valid record" do
      let(:subject) do
        SeventhIatAddendaRecord.new(
          receiver_city_and_state: "DHAKA*ZZ\\",
          receiver_country_and_postal_code: "BD*A1A1A1\\",
          entry_detail_sequence_number: 91_889
        )
      end

      it "should be valid" do
        subject.generate
        value(subject.validate).must_equal true
      end

      it "should generate valid data" do
        subject.generate
        value(subject.raw_data).must_equal '716DHAKA*ZZ\                          BD*A1A1A1\                                       0091889'
      end
    end
  end
end
