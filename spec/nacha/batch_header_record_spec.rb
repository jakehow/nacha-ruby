# frozen_string_literal: true

require "test_helper"

describe "Nacha::BatchHeaderRecord" do
  describe ".parse" do
    describe "valid record" do
      let(:raw_data) do
        "5200ACME CORPORATION                    1233211212WEBONLINEPYMT2209292209302731012000120000261"
      end
      let(:subject) { ::Nacha::BatchHeaderRecord.parse(raw_data) }

      it "should have the correct record type code" do
        value(subject.record_type_code).must_equal "5"
      end

      it "should have the correct service class code" do
        value(subject.service_class_code).must_equal "200"
      end

      it "should have the correct company name" do
        value(subject.company_name).must_equal "ACME CORPORATION"
      end

      it "should have the correct company identification" do
        value(subject.company_identification).must_equal "1233211212"
      end

      it "should have the correct standard entry class code" do
        value(subject.standard_entry_class_code).must_equal "WEB"
      end

      it "should have the correct company entry description" do
        value(subject.company_entry_description).must_equal "ONLINEPYMT"
      end

      it "should have the correct company desciption date" do
        value(subject.company_descriptive_date).must_equal "220929"
      end

      it "should have the correct effective entry date" do
        value(subject.effective_entry_date).must_equal "220930"
      end

      it "should have the correct originator status code" do
        value(subject.originator_status_code).must_equal "1"
      end

      it "should have the correct originator identification" do
        value(subject.originating_dfi_identification).must_equal "01200012"
      end

      it "should have the correct batch number" do
        value(subject.batch_number).must_equal "0000261"
      end
    end
  end

  describe ".new" do
    describe "valid record" do
      let(:subject) do
        ::Nacha::BatchHeaderRecord.new(
          service_class_code: "200",
          company_name: "ACME CORP",
          company_discretionary_data: "",
          company_identification: "123012321",
          standard_entry_class_code: "WEB",
          company_entry_description: "PAYROLL",
          company_descriptive_date: "190101",
          effective_entry_date: "190101",
          settlement_date: "190101",
          originator_status_code: "1",
          originating_dfi_identification: "23123112",
          batch_number: 1
        )
      end

      it "should generate valid data" do
        value(subject.validate).must_equal true
      end

      it "should have no errors" do
        subject.validate
        value(subject.errors).must_be_empty
      end

      it "should have the correct record type code" do
        value(subject.record_type_code).must_equal "5"
      end

      it "should have the correct service class code" do
        value(subject.service_class_code).must_equal "200"
      end

      it "should have the correct company name" do
        value(subject.company_name).must_equal "ACME CORP"
      end

      it "should have the correct company discretionary data" do
        value(subject.company_discretionary_data).must_equal ""
      end

      it "should have the correct company identification" do
        value(subject.company_identification).must_equal "123012321"
      end

      it "should have the correct standard entry class code" do
        value(subject.standard_entry_class_code).must_equal "WEB"
      end

      it "should have the correct company entry description" do
        value(subject.company_entry_description).must_equal "PAYROLL"
      end

      it "should have the correct company descriptive date" do
        value(subject.company_descriptive_date).must_equal "190101"
      end

      it "should have the correct effective entry date" do
        value(subject.effective_entry_date).must_equal "190101"
      end

      it "should have the correct settlement date" do
        value(subject.settlement_date).must_equal "190101"
      end

      it "should have the correct originator status code" do
        value(subject.originator_status_code).must_equal "1"
      end

      it "should have the correct originating dfi identification" do
        value(subject.originating_dfi_identification).must_equal "23123112"
      end

      it "should have the correct batch number" do
        value(subject.batch_number).must_equal 1
      end
    end
  end

  describe "#generate" do
    describe "valid record" do
      let(:subject) do
        ::Nacha::BatchHeaderRecord.new(
          service_class_code: "200",
          company_name: "ACME CORP",
          company_discretionary_data: "",
          company_identification: "1230123210",
          standard_entry_class_code: "WEB",
          company_entry_description: "PAYROLL",
          company_descriptive_date: "190101",
          effective_entry_date: "190101",
          settlement_date: "001",
          originator_status_code: "1",
          originating_dfi_identification: "23123112",
          batch_number: 1
        )
      end

      it "should generate valid data" do
        value(subject.generate).must_equal "5200ACME CORP                           1230123210WEBPAYROLL   1901011901010011231231120000001"
      end
    end
  end
end
