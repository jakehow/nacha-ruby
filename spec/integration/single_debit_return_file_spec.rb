require "test_helper"

describe "Single Debit Return File" do
  let(:file_contents) { fixture("single_debit_return.ACH") }
  let(:batch) { subject.batches.first }
  let(:entry) { batch.entries.first }

  subject { ::Nacha::File.parse(file_contents) }

  it "should have a single batch" do
    value(subject.batches.length).must_equal 1
  end

  it "should have a valid FileHeaderRecord" do
    value(subject.header.validate).must_equal true
  end

  it "should have no errors on the FileHeaderRecord" do
    subject.header.validate
    value(subject.header.errors).must_be_empty
  end

  it "should have a valid FileControlRecord" do
    value(subject.control.validate).must_equal true
  end

  it "should have no errors on the FileControlRecord" do
    subject.control.validate
    value(subject.control.errors).must_be_empty
  end

  it "should have a BatchHeaderRecord" do
    value(batch.header).must_be_instance_of(::Nacha::BatchHeaderRecord)
  end

  it "should have a valid BatchHeaderRecord" do
    value(batch.header.validate).must_equal true
  end

  it "should have no errors on the BatchHeaderRecord" do
    batch.header.validate
    value(batch.header.errors).must_be_empty
  end

  it "should have a valid BatchControlRecord" do
    value(batch.control.validate).must_equal true
  end

  it "should have no errors on the BatchControlRecord" do
    batch.control.validate
    value(batch.control.errors).must_be_empty
  end

  it "should have an EntryDetail" do
    value(entry).must_be_instance_of(::Nacha::EntryDetail)
  end

  it "should have a valid EntryDetail" do
    value(entry.validate).must_equal true
  end

  it "should have no errors on the EntryDetail" do
    entry.validate
    value(entry.errors).must_be_empty
  end

  it "should have an EntryDetailRecord" do
    value(entry.record).must_be_instance_of(::Nacha::EntryDetailRecord)
  end

  it "should have a valid EntryDetailRecord" do
    value(entry.record.validate).must_equal true
  end

  it "should have no errors on the EntryDetailRecord" do
    entry.record.validate
    value(entry.record.errors).must_be_empty
  end

  it "should generate identical data when no modification has been made to the content of the file" do
    value(subject.generate).must_equal file_contents
  end

  it "should generate identical data when constructed manually" do
    file = ::Nacha::File.new
    file.header = ::Nacha::FileHeaderRecord.new(
      priority_code: "01",
      immediate_destination: "021000021",
      immediate_origin: "321000123",
      file_creation_date: "221110",
      file_creation_time: "1449",
      file_id_modifier: "C",
      record_size: "094",
      blocking_factor: 10,
      format_code: "1",
      immediate_destination_name: "JPMORGAN CHASE BANK",
      immediate_origin_name: "ACME CORPORATION"
    )

    file.batches = [
      ::Nacha::Batch.new(
        header: ::Nacha::BatchHeaderRecord.new(
          service_class_code: "225",
          company_name: "ACME INC",
          company_discretionary_data: "ABCDEFGHIJKLMNOPQRST",
          company_identification: "1233211212",
          standard_entry_class_code: "CCD",
          company_entry_description: "VAT TOP UP",
          company_descriptive_date: "221109",
          effective_entry_date: "221109",
          settlement_date: "314",
          originator_status_code: "1",
          originating_dfi_identification: "01200012",
          batch_number: 44
        ),
        entries: [
          ::Nacha::EntryDetail.new(
            record: ::Nacha::EntryDetailRecord.new(
              addenda_record_indicator: 1,
              amount: 2832,
              check_digit: "1",
              dfi_account_number: "1230000099",
              transaction_code: "26",
              individual_identification_number: "3213211234",
              individual_name: "KIRLIN AND SONS",
              receiving_dfi_identification: "02100002",
              trace_number: "012000120000003"
            ),
            addenda: [
              ::Nacha::Returns::AddendaRecord.new(
                record_type_code: "7",
                addenda_type_code: "99",
                original_entry_trace_number: "021000021000001",
                original_rdfi_identification: "01200012",
                return_reason_code: "R20",
                trace_number: "012000120000003"
              )
            ]
          )
        ],
        control: ::Nacha::BatchControlRecord.new(
          batch_number: 44,
          service_class_code: "225",
          entry_hash: "0002100002",
          entry_addenda_count: 2,
          total_debit_amount: 2832,
          total_credit_amount: 0,
          company_identification: "1233211212",
          originating_dfi_identification: "01200012"
        )
      )
    ]

    file.control = ::Nacha::FileControlRecord.new(
      batch_count: 1,
      block_count: 1,
      entry_addenda_count: 2,
      entry_hash: "0002100002",
      total_debit_amount: 2832,
      total_credit_amount: 0
    )

    value(file.generate).must_equal file_contents
  end
end
