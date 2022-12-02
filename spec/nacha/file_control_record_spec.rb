# frozen_string_literal: true

require "test_helper"

describe "Nacha::FileControlRecord" do
  describe ".parse" do
    describe "valid record" do
      let(:raw_data) do
        "9000003000003000000210007821945000003123400000000000142                                       "
      end
      let(:subject) { ::Nacha::FileControlRecord.parse(raw_data, skip_validation: true) }

      it "should set raw data" do
        value(subject.raw_data).must_equal raw_data
      end

      it "should have no errors" do
        subject.validate
        value(subject.errors).must_be_empty
      end

      it "should be valid" do
        value(subject.validate).must_equal true
      end

      it "should set record type code" do
        value(subject.record_type_code).must_equal "9"
      end

      it "should set batch count" do
        value(subject.batch_count).must_equal 3
      end

      it "should set block count" do
        value(subject.block_count).must_equal 3
      end

      it "should set the entry addenda count" do
        value(subject.entry_addenda_count).must_equal 21
      end

      it "should set the entry hash" do
        value(subject.entry_hash).must_equal "0007821945"
      end

      it "should set the total debit entry dollar amount" do
        value(subject.total_debit_amount).must_equal 3123400
      end

      it "should set the total credit entry dollar amount" do
        value(subject.total_credit_amount).must_equal 142
      end
    end
  end

  describe ".new" do
    describe "valid record" do
      let(:subject) do
        ::Nacha::FileControlRecord.new(
          batch_count: 3,
          block_count: 3,
          entry_addenda_count: 21,
          entry_hash: "0007821945",
          total_debit_amount: 3123400,
          total_credit_amount: 142
        )
      end

      it "should be valid" do
        value(subject.validate).must_equal true
      end

      it "should have no errors" do
        subject.validate
        value(subject.errors).must_be_empty
      end

      it "should set record type code" do
        value(subject.record_type_code).must_equal "9"
      end

      it "should set batch count" do
        value(subject.batch_count).must_equal 3
      end

      it "should set block count" do
        value(subject.block_count).must_equal 3
      end

      it "should set the entry addenda count" do
        value(subject.entry_addenda_count).must_equal 21
      end

      it "should set the entry hash" do
        value(subject.entry_hash).must_equal "0007821945"
      end

      it "should set the total debit entry dollar amount" do
        value(subject.total_debit_amount).must_equal 3123400
      end

      it "should set the total credit entry dollar amount" do
        value(subject.total_credit_amount).must_equal 142
      end
    end
  end

  describe "#generate" do
    describe "valid record" do
      let(:subject) do
        ::Nacha::FileControlRecord.new(
          batch_count: 3,
          block_count: 3,
          entry_addenda_count: 21,
          entry_hash: "0007821945",
          total_debit_amount: 3123400,
          total_credit_amount: 142
        )
      end

      it "should generate the correct raw data" do
        value(subject.generate).must_equal "9000003000003000000210007821945000003123400000000000142                                       "
      end
    end
  end
end
