# frozen_string_literal: true

require "test_helper"

describe "Nacha::FileHeaderRecord" do
  describe ".parse" do
    describe "valid record" do
      let(:raw_data) do
        "101 021000021 3210001232207271648D094101JPMORGAN CHASE BANK    ACME CORPORATION               "
      end
      let(:subject) { ::Nacha::FileHeaderRecord.parse(raw_data, skip_validation: true) }

      it "should set raw data" do
        value(subject.raw_data).must_equal raw_data
      end

      it "should be valid" do
        value(subject.validate).must_equal true
      end

      it "should set record type code" do
        value(subject.record_type_code).must_equal "1"
      end

      it "should set priority code" do
        value(subject.priority_code).must_equal "01"
      end

      it "should set immediate destination" do
        value(subject.immediate_destination).must_equal "021000021"
      end

      it "should set immediate origin" do
        value(subject.immediate_origin).must_equal "321000123"
      end

      it "should set file creation date" do
        value(subject.file_creation_date).must_equal "220727"
      end

      it "should set file creation time" do
        value(subject.file_creation_time).must_equal "1648"
      end

      it "should set the file id modifier" do
        value(subject.file_id_modifier).must_equal "D"
      end

      it "should set the record size" do
        value(subject.record_size).must_equal "094"
      end

      it "should set the blocking factor" do
        value(subject.blocking_factor).must_equal 10
      end

      it "should set the format code" do
        value(subject.format_code).must_equal "1"
      end

      it "should set the immediate destination name" do
        value(subject.immediate_destination_name).must_equal "JPMORGAN CHASE BANK"
      end

      it "should set the immediate origin name" do
        value(subject.immediate_origin_name).must_equal "ACME CORPORATION"
      end

      it "should set the reference code" do
        value(subject.reference_code).must_equal ""
      end
    end
  end

  describe ".new" do
    describe "valid record" do
      let(:subject) do
        ::Nacha::FileHeaderRecord.new(
          priority_code: "01",
          immediate_destination: "021000021",
          immediate_origin: "321000123",
          file_creation_date: "220727",
          file_creation_time: "1648",
          file_id_modifier: "D",
          record_size: "094",
          blocking_factor: 10,
          format_code: "1",
          immediate_destination_name: "JPMORGAN CHASE BANK",
          immediate_origin_name: "ACME CORPORATION",
          reference_code: ""
        )
      end

      it "should be valid after generation" do
        subject.generate
        value(subject.validate).must_equal true
      end

      it "should set record type code" do
        value(subject.record_type_code).must_equal "1"
      end

      it "should set priority code" do
        value(subject.priority_code).must_equal "01"
      end

      it "should set immediate destination" do
        value(subject.immediate_destination).must_equal "021000021"
      end

      it "should set immediate origin" do
        value(subject.immediate_origin).must_equal "321000123"
      end

      it "should set file creation date" do
        value(subject.file_creation_date).must_equal "220727"
      end

      it "should set file creation time" do
        value(subject.file_creation_time).must_equal "1648"
      end

      it "should set the file id modifier" do
        value(subject.file_id_modifier).must_equal "D"
      end

      it "should set the record size" do
        value(subject.record_size).must_equal "094"
      end

      it "should set the blocking factor" do
        value(subject.blocking_factor).must_equal 10
      end

      it "should set the format code" do
        value(subject.format_code).must_equal "1"
      end

      it "should set the immediate destination name" do
        value(subject.immediate_destination_name).must_equal "JPMORGAN CHASE BANK"
      end

      it "should set the immediate origin name" do
        value(subject.immediate_origin_name).must_equal "ACME CORPORATION"
      end

      it "should set the reference code" do
        value(subject.reference_code).must_equal ""
      end
    end
  end

  describe "#generate" do
    describe "valid record" do
      let(:subject) { ::Nacha::FileHeaderRecord.new({
        priority_code: "01",
        immediate_destination: "021000021",
        immediate_origin: "321000123",
        file_creation_date: "220727",
        file_creation_time: "1648",
        file_id_modifier: "D",
        record_size: "094",
        blocking_factor: 10,
        format_code: "1",
        immediate_destination_name: "JPMORGAN CHASE BANK",
        immediate_origin_name: "ACME CORPORATION",
        reference_code: ""
      }) }

      it "should be valid after generation" do
        subject.generate
        value(subject.validate).must_equal true
      end

      it "should generate raw data" do
        value(subject.generate).must_equal "101 021000021 3210001232207271648D094101JPMORGAN CHASE BANK    ACME CORPORATION               "
      end
    end
  end
end
