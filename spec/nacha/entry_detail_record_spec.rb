require "test_helper"

describe "Nacha::EntryDetailRecord" do
  describe ".parse" do
    let(:raw_data) do
      "6270210000211230000099       00010000003213211234     DARON BERGSTROM       S 0012345678912345"
    end
    let(:subject) { ::Nacha::EntryDetailRecord.parse(raw_data, skip_validation: true) }

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
      value(subject.transaction_code).must_equal "27"
    end

    it "should set the RDFI identification" do
      value(subject.receiving_dfi_identification).must_equal "02100002"
    end

    it "should set the check digit" do
      value(subject.check_digit).must_equal "1"
    end

    it "should set the DFI account number" do
      value(subject.dfi_account_number).must_equal "1230000099"
    end

    it "should set the amount" do
      value(subject.amount).must_equal 1_000_000
    end

    it "should set the individual identification number" do
      value(subject.individual_identification_number).must_equal "3213211234"
    end

    it "should set the individual name" do
      value(subject.individual_name).must_equal "DARON BERGSTROM"
    end

    it "should set the discretionary data" do
      value(subject.discretionary_data).must_equal "S"
    end

    it "should set the addenda record indicator" do
      value(subject.addenda_record_indicator).must_equal "0"
    end

    it "should set the trace number" do
      value(subject.trace_number).must_equal "012345678912345"
    end

    it "should generate valid raw data" do
      value(subject.generate).must_equal raw_data
    end
  end
end
