# frozen_string_literal: true

require "test_helper"

describe "Nacha::ThirdIatAddendaRecord" do
  describe ".parse" do
    describe "valid record" do
      let(:raw_data) do
        '712SAO PAULO*ZZ\                      BR*04543000\                                     0091889'
      end
      let(:subject) { ThirdIatAddendaRecord.parse(raw_data, skip_validation: true) }

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
        value(subject.addenda_type_code).must_equal "12"
      end

      it "should set the originator city and state" do
        value(subject.originator_city_and_state).must_equal "SAO PAULO*ZZ\\"
      end

      it "should set the originator country and postal code" do
        value(subject.originator_country_and_postal_code).must_equal "BR*04543000\\"
      end

      it "should set the entry detail sequence number" do
        value(subject.entry_detail_sequence_number).must_equal "0091889"
      end
    end
  end

  describe "#generate" do
    describe "valid record" do
      let(:subject) do
        ThirdIatAddendaRecord.new(
          originator_city_and_state: 'SAO PAULO*ZZ\\',
          originator_country_and_postal_code: 'BR*04543000\\',
          entry_detail_sequence_number: 91_889
        )
      end

      before { subject.generate}

      it "should be valid" do
        value(subject.validate).must_equal true
      end

      it "should have no errors" do
        subject.validate
        value(subject.errors).must_be_empty
      end

      it "should generate valid data" do
        value(subject.raw_data).must_equal '712SAO PAULO*ZZ\                      BR*04543000\                                     0091889'
      end
    end
  end
end
