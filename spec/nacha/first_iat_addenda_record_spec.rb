# frozen_string_literal: true

require "test_helper"

describe "Nacha::FirstIatAddendaRecord" do
    describe ".parse" do
        describe "valid record" do
            let(:raw_data) { "710DEP000000000000000234                      DARON BERGSTROM                          0091889" }
            let(:subject) { FirstIatAddendaRecord.parse(raw_data, skip_validation: true) }

            it "should have no errors" do
                subject.validate
                value(subject.errors).must_be_empty
            end
            
            it "should be valid" do
                value(subject.validate).must_equal true
            end

            it "should have the correct record type code" do
                value(subject.record_type_code).must_equal "7"
            end

            it "should have the correct addenda type code" do
                value(subject.addenda_type_code).must_equal "10"
            end

            it "should have the correct transaction type code" do
                value(subject.transaction_type_code).must_equal "DEP"
            end

            it "should have the correct foreign payment amount" do
                value(subject.foreign_payment_amount).must_equal 234
            end

            it "should have the correct foreign trace number" do
                value(subject.foreign_trace_number).must_equal ""
            end

            it "should have the correct receiving company or individual name" do
                value(subject.receiving_company_or_individual_name).must_equal "DARON BERGSTROM"
            end

            it "should have the correct entry detail sequence number" do
                value(subject.entry_detail_sequence_number).must_equal "0091889"
            end
        end
    end

    describe "#generate" do
        describe "valid record" do
            let(:subject) { FirstIatAddendaRecord.new(
                addenda_type_code: "10",
                transaction_type_code: "DEP",
                foreign_payment_amount: 234,
                foreign_trace_number: "",
                receiving_company_or_individual_name: "DARON BERGSTROM",
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
                value(subject.raw_data).must_equal "710DEP000000000000000234                      DARON BERGSTROM                          0091889"
            end
        end
    end
end