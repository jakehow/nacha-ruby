require "test_helper"

describe "Nacha::BatchControlRecord" do
  describe ".parse" do
    describe "valid record" do
      let(:raw_data) do
        "82000000080001201232000000000000000000000234X111222333                         091000010000445"
      end
      let(:subject) { ::Nacha::BatchControlRecord.parse(raw_data, skip_validation: true) }

      it "should set raw data" do
        value(subject.raw_data).must_equal raw_data
      end

      it "should set service class code" do
        value(subject.service_class_code).must_equal "200"
      end

      it "should set entry addenda count" do
        value(subject.entry_addenda_count).must_equal 8
      end

      it "should set entry hash" do
        value(subject.entry_hash).must_equal "0001201232"
      end

      it "should set total debit amount" do
        value(subject.total_debit_amount).must_equal 0
      end

      it "should set total credit amount" do
        value(subject.total_credit_amount).must_equal 234
      end

      it "should set company identification" do
        value(subject.company_identification).must_equal "X111222333"
      end

      it "should set message authentication code" do
        value(subject.message_authentication_code).must_equal ""
      end

      it "should set originating dfi identification" do
        value(subject.originating_dfi_identification).must_equal "09100001"
      end

      it "should set batch number" do
        value(subject.batch_number).must_equal "0000445"
      end

      it "should have a hash output" do
        value(subject.to_h).must_equal({
                                         record_type_code: "8",
                                         service_class_code: "200",
                                         entry_addenda_count: 8,
                                         entry_hash: "0001201232",
                                         total_debit_amount: 0,
                                         total_credit_amount: 234,
                                         company_identification: "X111222333",
                                         message_authentication_code: "",
                                         originating_dfi_identification: "09100001",
                                         batch_number: "0000445"
                                       })
      end
    end
  end

  describe "#generate" do
    describe "valid record" do
      let(:subject) do
        ::Nacha::BatchControlRecord.new(
          service_class_code: "200",
          entry_addenda_count: 8,
          entry_hash: "0001201232",
          total_debit_amount: 0,
          total_credit_amount: 234,
          company_identification: "X111222333",
          originating_dfi_identification: "09100001",
          batch_number: 445
        )
      end

      it "should generate valid data" do
        subject.generate
        value(subject.raw_data).must_equal "82000000080001201232000000000000000000000234X111222333                         091000010000445"
      end

      it "should have a hash output" do
        value(subject.to_h).must_equal({
                                         record_type_code: "8",
                                         service_class_code: "200",
                                         entry_addenda_count: 8,
                                         entry_hash: "0001201232",
                                         total_debit_amount: 0,
                                         total_credit_amount: 234,
                                         company_identification: "X111222333",
                                         message_authentication_code: nil,
                                         originating_dfi_identification: "09100001",
                                         batch_number: 445
                                       })
      end
    end
  end
end
