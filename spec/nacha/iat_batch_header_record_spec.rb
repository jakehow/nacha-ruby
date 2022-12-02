# frozen_string_literal: true

require "test_helper"

describe "Nacha::IatBatchHeaderRecord" do
  describe ".new" do
    describe "valid record" do
      let(:subject) do
        ::Nacha::IatBatchHeaderRecord.new(
          service_class_code: "200",
          iat_indicator: "",
          foreign_exchange_indicator: "FF",
          foreign_exchange_reference_indicator: "3",
          foreign_exchange_reference: "",
          iso_destination_country_code: "US",
          originator_identification: "X111222333",
          standard_entry_class_code: "IAT",
          company_entry_description: "EDI PYMNTS",
          iso_originating_currency_code: "USD",
          iso_destination_currency_code: "USD",
          effective_entry_date: "220729",
          settlement_date: "210",
          originator_status_code: "1",
          go_or_originating_dfi_identification: "09100001",
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

      it "should have the correct iat indicator" do
        value(subject.iat_indicator).must_equal ""
      end

      it "should have the correct foreign exchange indicator" do
        value(subject.foreign_exchange_indicator).must_equal "FF"
      end

      it "should have the correct foreign exchange reference indicator" do
        value(subject.foreign_exchange_reference_indicator).must_equal "3"
      end

      it "should have the correct foreign exchange reference" do
        value(subject.foreign_exchange_reference).must_equal ""
      end

      it "should have the correct iso destination country code" do
        value(subject.iso_destination_country_code).must_equal "US"
      end

      it "should have the correct originator identification" do
        value(subject.originator_identification).must_equal "X111222333"
      end

      it "should have the correct standard entry class code" do
        value(subject.standard_entry_class_code).must_equal "IAT"
      end

      it "should have the correct company entry description" do
        value(subject.company_entry_description).must_equal "EDI PYMNTS"
      end

      it "should have the correct iso originating currency code" do
        value(subject.iso_originating_currency_code).must_equal "USD"
      end

      it "should have the correct iso destination currency code" do
        value(subject.iso_destination_currency_code).must_equal "USD"
      end

      it "should have the correct effective entry date" do
        value(subject.effective_entry_date).must_equal "220729"
      end

      it "should have the correct settlement date" do
        value(subject.settlement_date).must_equal "210"
      end

      it "should have the correct originator status code" do
        value(subject.originator_status_code).must_equal "1"
      end

      it "should have the correct go or originator DFI identification" do
        value(subject.go_or_originating_dfi_identification).must_equal "09100001"
      end

      it "should have the correct batch number" do
        value(subject.batch_number).must_equal 1
      end
    end
  end

  describe ".parse" do
    describe "valid record" do
      let(:raw_data) do
        "5200                FF3               USX111222333IATEDI PYMNTSUSDUSD2207292101091000010000445"
      end
      let(:subject) { ::Nacha::IatBatchHeaderRecord.parse(raw_data, skip_validation: true) }

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

      it "should have the correct record type code" do
        value(subject.record_type_code).must_equal "5"
      end

      it "should have the correct service class code" do
        value(subject.service_class_code).must_equal "200"
      end

      it "should have the correct iat indicator" do
        value(subject.iat_indicator).must_equal ""
      end

      it "should have the correct foreign exchange indicator" do
        value(subject.foreign_exchange_indicator).must_equal "FF"
      end

      it "should have the correct foreign exchange reference indicator" do
        value(subject.foreign_exchange_reference_indicator).must_equal "3"
      end

      it "should have the correct foreign exchange reference" do
        value(subject.foreign_exchange_reference).must_equal ""
      end

      it "should have the correct iso destination country code" do
        value(subject.iso_destination_country_code).must_equal "US"
      end

      it "should have the correct originator identification" do
        value(subject.originator_identification).must_equal "X111222333"
      end

      it "should have the correct standard entry class code" do
        value(subject.standard_entry_class_code).must_equal "IAT"
      end

      it "should have the correct company entry description" do
        value(subject.company_entry_description).must_equal "EDI PYMNTS"
      end

      it "should have the correct iso originating currency code" do
        value(subject.iso_originating_currency_code).must_equal "USD"
      end

      it "should have the correct iso destination currency code" do
        value(subject.iso_destination_currency_code).must_equal "USD"
      end

      it "should have the correct effective entry date" do
        value(subject.effective_entry_date).must_equal "220729"
      end

      it "should have the correct settlement date" do
        value(subject.settlement_date).must_equal "210"
      end

      it "should have the correct originator status code" do
        value(subject.originator_status_code).must_equal "1"
      end

      it "should have the correct go or originating DFI identification" do
        value(subject.go_or_originating_dfi_identification).must_equal "09100001"
      end

      it "should have the correct batch number" do
        value(subject.batch_number).must_equal "0000445"
      end
    end
  end

  describe "#generate" do
    describe "valid record" do
      let(:subject) do
        ::Nacha::IatBatchHeaderRecord.new(
          service_class_code: 200,
          iat_indicator: "",
          foreign_exchange_indicator: "FF",
          foreign_exchange_reference_indicator: "3",
          foreign_exchange_reference: "",
          iso_destination_country_code: "US",
          originator_identification: "X111222333",
          standard_entry_class_code: "IAT",
          company_entry_description: "EDI PYMNTS",
          iso_originating_currency_code: "USD",
          iso_destination_currency_code: "USD",
          effective_entry_date: "220729",
          settlement_date: "210",
          originator_status_code: "1",
          go_or_originating_dfi_identification: "09100001",
          batch_number: 445
        )
      end

      it "should generate valid data" do
        subject.generate
        value(subject.validate).must_equal true
      end

      it "should set raw data" do
        subject.generate
        value(subject.raw_data).must_equal "5200                FF3               USX111222333IATEDI PYMNTSUSDUSD2207292101091000010000445"
      end
    end
  end
end
