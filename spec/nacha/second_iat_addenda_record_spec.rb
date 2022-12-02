# frozen_string_literal: true

require "test_helper"

describe "Nacha::SecondIatAddendaRecord" do
    describe ".parse" do
        describe "valid record" do
            let(:raw_data) { "711ACME SE3211234                     8992 Chantal Flat                                0091889" }
            let(:subject) { SecondIatAddendaRecord.parse(raw_data, skip_validation: true) }

            it "should have no errors" do
                subject.validate
                value(subject.errors).must_be_empty
            end
            
            it "should be valid" do
                value(subject.validate).must_equal true
            end

            it "should set the record type code" do
                value(subject.record_type_code).must_equal "7"
            end

            it "should set the addenda type code" do
                value(subject.addenda_type_code).must_equal "11"
            end

            it "should set the originator name" do
                value(subject.originator_name).must_equal "ACME SE3211234"
            end

            it "should set the originator street address" do
                value(subject.originator_street_address).must_equal "8992 Chantal Flat"
            end

            it "should set the entry detail sequence number" do
                value(subject.entry_detail_sequence_number).must_equal "0091889"
            end
        end
    end

    describe "#generate" do
        describe "valid record" do
            let(:subject) { SecondIatAddendaRecord.new(
                addenda_type_code: "11",
                originator_name: "ACME SE3211234",
                originator_street_address: "8992 Chantal Flat",
                entry_detail_sequence_number: "0091889"
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
                value(subject.raw_data).must_equal "711ACME SE3211234                     8992 Chantal Flat                                0091889"
            end
        end
    end
end