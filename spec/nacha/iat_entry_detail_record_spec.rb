# frozen_string_literal: true

require "test_helper"

describe "Nacha::IatEntryDetailRecord" do
    describe ".parse" do
        let(:raw_data) { "6220210000210007             00000002341234567898                             1091000010091889" }
        let(:subject) { ::Nacha::IatEntryDetailRecord.parse(raw_data, skip_validation: true) }

        it "should set raw data" do
            value(subject.raw_data).must_equal raw_data
        end

        it "should have no errors" do
            subject.validate
            value(subject.errors).must_be_empty
        end

        it "should validate" do
            value(subject.validate).must_equal true
        end

        it "should set the record type code" do
            value(subject.record_type_code).must_equal "6"
        end

        it "should set the transaction code" do
            value(subject.transaction_code).must_equal "22"
        end

        it "should set the GO or RDFI identification" do
            value(subject.go_or_receiving_dfi_identification).must_equal "02100002"
        end

        it "should set the check digit" do
            value(subject.check_digit).must_equal "1"
        end

        it "should set the number of addenda records" do
            value(subject.number_of_addenda_records).must_equal "0007"
        end

        it "should set the amount" do
            value(subject.amount).must_equal 234
        end

        it "should set the foreign receivers account number or DFI account number" do
            value(subject.foreign_receivers_or_dfi_account_number).must_equal "1234567898"
        end

        it "should set the gateway operator OFAC screening indicator" do
            value(subject.gateway_operator_ofac_screening_indicator).must_equal ""
        end

        it "should set the secondary OFAC screening indicator" do
            value(subject.secondary_ofac_screening_indicator).must_equal ""
        end

        it "should set the addenda record indicator" do
            value(subject.addenda_record_indicator).must_equal "1"
        end

        it "should set the trace number" do
            value(subject.trace_number).must_equal "091000010091889"
        end
    end

    describe ".new" do
        describe "when the record is valid" do
            let(:subject) { ::Nacha::IatEntryDetailRecord.new(
                transaction_code: "22",
                go_or_receiving_dfi_identification: "01201232",
                check_digit: "1",
                number_of_addenda_records: "0007",
                amount: 234,
                foreign_receivers_or_dfi_account_number: "1234567898",
                gateway_operator_ofac_screening_indicator: "",
                secondary_ofac_screening_indicator: "",
                addenda_record_indicator: "1",
                trace_number: "091000010091889"
            ) }

            it "should be valid" do
                value(subject.validate).must_equal true
            end

            it "should have no errors" do
                subject.validate
                value(subject.errors).must_be_empty
            end

            it "should set the record type code" do
                value(subject.record_type_code).must_equal "6"
            end

            it "should set the transaction code" do
                value(subject.transaction_code).must_equal "22"
            end

            it "should set the GO or RDFI identification" do
                value(subject.go_or_receiving_dfi_identification).must_equal "01201232"
            end

            it "should set the check digit" do
                value(subject.check_digit).must_equal "1"
            end

            it "should set the number of addenda records" do
                value(subject.number_of_addenda_records).must_equal "0007"
            end

            it "should set the amount" do
                value(subject.amount).must_equal 234
            end

            it "should set the foreign receivers account number or DFI account number" do
                value(subject.foreign_receivers_or_dfi_account_number).must_equal "1234567898"
            end

            it "should set the gateway operator OFAC screening indicator" do
                value(subject.gateway_operator_ofac_screening_indicator).must_equal ""
            end

            it "should set the secondary OFAC screening indicator" do
                value(subject.secondary_ofac_screening_indicator).must_equal ""
            end

            it "should set the addenda record indicator" do
                value(subject.addenda_record_indicator).must_equal "1"
            end

            it "should set the trace number" do
                value(subject.trace_number).must_equal "091000010091889"
            end
        end
    end

    describe "#generate" do
        describe "when the record is valid" do
            let(:subject) { ::Nacha::IatEntryDetailRecord.new(
                transaction_code: "22",
                go_or_receiving_dfi_identification: "02100002",
                check_digit: "1",
                number_of_addenda_records: "0007",
                amount: 234,
                foreign_receivers_or_dfi_account_number: "1234567898",
                gateway_operator_ofac_screening_indicator: "",
                secondary_ofac_screening_indicator: "",
                addenda_record_indicator: "1",
                trace_number: "091000010091889"
            ) }

            it "should generate a valid record" do
                value(subject.generate).must_equal "6220210000210007             00000002341234567898                             1091000010091889"
            end
        end
    end
end
