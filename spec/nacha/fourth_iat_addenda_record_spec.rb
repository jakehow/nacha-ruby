# frozen_string_literal: true

require "test_helper"

describe "Nacha::FourthIatAddendaRecord" do
  describe ".parse" do
    describe "valid record" do
      let(:raw_data) do
        "713WELLS FARGO BANK                   01091000019                         US           0091889"
      end
      let(:subject) { FourthIatAddendaRecord.parse(raw_data, skip_validation: true) }

      it "should be valid" do
        value(subject.validate).must_equal true
      end

      it "should not have any errors" do
        subject.validate
        value(subject.errors).must_be_empty
      end

      it "should have the correct raw data" do
        value(subject.raw_data).must_equal raw_data
      end

      it "should have the correct record type code" do
        value(subject.record_type_code).must_equal "7"
      end

      it "should have the correct addenda type code" do
        value(subject.addenda_type_code).must_equal "13"
      end

      it "should have the correct originating dfi name" do
        value(subject.originating_dfi_name).must_equal "WELLS FARGO BANK"
      end

      it "should have the correct originating dfi identification number qualifier" do
        value(subject.originating_dfi_identification_number_qualifier).must_equal "01"
      end

      it "should have the correct originating dfi identification" do
        value(subject.originating_dfi_identification).must_equal "091000019"
      end

      it "should have the correct originating dfi branch country code" do
        value(subject.originating_dfi_branch_country_code).must_equal "US"
      end

      it "should have the correct entry detail sequence number" do
        value(subject.entry_detail_sequence_number).must_equal "0091889"
      end
    end
  end

  describe "#generate" do
    describe "valid record" do
      let(:subject) do
        FourthIatAddendaRecord.new(
          originating_dfi_name: "WELLS FARGO BANK",
          originating_dfi_identification_number_qualifier: "01",
          originating_dfi_identification: "091000019",
          originating_dfi_branch_country_code: "US",
          entry_detail_sequence_number: 91_889
        )
      end

      before { subject.generate }

      it "should not have any errors" do
        subject.validate
        value(subject.errors).must_be_empty
      end

      it "should be valid" do
        value(subject.validate).must_equal true
      end

      it "should generate valid data" do
        value(subject.raw_data).must_equal "713WELLS FARGO BANK                   01091000019                         US           0091889"
      end
    end
  end
end
