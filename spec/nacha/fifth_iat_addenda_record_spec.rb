# frozen_string_literal: true

require "test_helper"

describe "Nacha::FifthIatAddendaRecord" do
    describe ".parse" do
        describe "valid record" do
            let(:raw_data) { "714JPMorgan Chase Bank                01021000021                         US           0091889" }
            let(:subject) { FifthIatAddendaRecord.parse(raw_data, skip_validation: true) }

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

            it "should have the correct record type code" do
                value(subject.record_type_code).must_equal "7"
            end

            it "should have the correct addenda type code" do
                value(subject.addenda_type_code).must_equal "14"
            end

            it "should have the correct receiving dfi name" do
                value(subject.receiving_dfi_name).must_equal "JPMorgan Chase Bank"
            end

            it "should have the correct receiving dfi identification number qualifier" do
                value(subject.receiving_dfi_identification_number_qualifier).must_equal "01"
            end

            it "should have the correct receiving dfi identification" do
                value(subject.receiving_dfi_identification).must_equal "021000021"
            end

            it "should have the correct receiving dfi branch country code" do
                value(subject.receiving_dfi_branch_country_code).must_equal "US"
            end

            it "should have the correct entry detail sequence number" do
                value(subject.entry_detail_sequence_number).must_equal "0091889"
            end
        end
    end

    describe "#generate" do
        describe "valid record" do
            let(:subject) { FifthIatAddendaRecord.new(
                receiving_dfi_name: "JPMorgan Chase Bank ",
                receiving_dfi_identification_number_qualifier: "01",
                receiving_dfi_identification: "021000021",
                receiving_dfi_branch_country_code: "US",
                entry_detail_sequence_number: 91889
            )}

            before { subject.generate }
            
            it "should have no errors" do
                subject.validate
                value(subject.errors).must_be_empty
            end

            it "should be valid" do
                value(subject.validate).must_equal true
            end

            it "should generate valid data" do
                value(subject.raw_data).must_equal "714JPMorgan Chase Bank                01021000021                         US           0091889"
            end
        end
    end
end