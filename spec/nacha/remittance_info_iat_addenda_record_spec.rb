# frozen_string_literal: true

require "test_helper"

describe "Nacha::RemittanceInfoIatAddendaRecord" do
  describe ".parse" do
    describe "valid record" do
      let(:raw_data) do
        "717ABC123456789                                                                    00012131234"
      end
      let(:subject) { RemittanceInfoIatAddendaRecord.parse(raw_data, skip_validation: true) }

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
        value(subject.addenda_type_code).must_equal "17"
      end

      it "should set the payment related information" do
        value(subject.payment_related_information).must_equal "ABC123456789"
      end

      it "should set the addenda sequence number" do
        value(subject.addenda_sequence_number).must_equal "0001"
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
