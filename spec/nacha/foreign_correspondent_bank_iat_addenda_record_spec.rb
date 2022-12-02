# frozen_string_literal: true

require "test_helper"

describe "Nacha::ForeignCorrespondentBankIatAddendaRecord" do
  describe ".parse" do
    describe "valid record" do
      let(:raw_data) do
        "718BANK OF AMERICA CANADA             01121000358                         CA       00022131234"
      end
      let(:subject) { ForeignCorrespondentBankIatAddendaRecord.parse(raw_data, skip_validation: true) }

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
        value(subject.addenda_type_code).must_equal "18"
      end

      it "should set the foreign correspondent bank name" do
        value(subject.foreign_correspondent_bank_name).must_equal "BANK OF AMERICA CANADA"
      end

      it "should set the foreign correspondent bank identification number qualifier" do
        value(subject.foreign_correspondent_bank_identification_number_qualifier).must_equal "01"
      end

      it "should set the foreign correspondent bank identification number" do
        value(subject.foreign_correspondent_bank_identification_number).must_equal "121000358"
      end

      it "should set the foreign correspondent bank branch country code" do
        value(subject.foreign_correspondent_bank_branch_country_code).must_equal "CA"
      end

      it "should set the addenda sequence number" do
        value(subject.addenda_sequence_number).must_equal "0002"
      end

      it "should set the entry detail sequence number" do
        value(subject.entry_detail_sequence_number).must_equal "2131234"
      end

      it "should generate the correct raw data" do
        value(subject.generate).must_equal raw_data
      end
    end
  end
end
