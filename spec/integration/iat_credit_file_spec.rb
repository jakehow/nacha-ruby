require "test_helper"

describe "IAT Credit File" do
  let(:file_contents) { fixture("iat_credit.ACH") }
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

  it "should have a IatBatchHeaderRecord" do
    value(batch.header).must_be_instance_of(::Nacha::IatBatchHeaderRecord)
  end

  it "should have a valid IatBatchHeaderRecord" do
    value(batch.header.validate).must_equal true
  end

  it "should have no errors on the IatBatchHeaderRecord" do
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

  it "should have an IatEntryDetailRecord" do
    value(entry.record).must_be_instance_of(::Nacha::IatEntryDetailRecord)
  end

  it "should have a valid IatEntryDetailRecord" do
    value(entry.record.validate).must_equal true
  end

  it "should have no errors on the IatEntryDetailRecord" do
    entry.record.validate
    value(entry.record.errors).must_be_empty
  end

  it "should have 7 addenda records on the entry" do
    value(entry.addenda.length).must_equal 7
  end

  it "should have a FirstIatAddendaRecord on the entry" do
    value(entry.addenda.first).must_be_instance_of(::Nacha::FirstIatAddendaRecord)
  end

  it "should have a valid FirstIatAddendaRecord" do
    value(entry.addenda.first.validate).must_equal true
  end

  it "should have no errors on the FirstIatAddendaRecord" do
    entry.addenda.first.validate
    value(entry.addenda.first.errors).must_be_empty
  end

  it "should generate identical data when no modification has been made to the content of the file" do
    value(subject.generate).must_equal file_contents
  end

  it "should generate identical data when constructed manually" do
    file = ::Nacha::File.new
    file.header = ::Nacha::FileHeaderRecord.new(
      priority_code: "01",
      immediate_destination: "021000021",
      immediate_origin: "123012321",
      file_creation_date: "220727",
      file_creation_time: "1648",
      file_id_modifier: "D",
      record_size: "094",
      blocking_factor: 10,
      format_code: "1",
      immediate_destination_name: "WELLS FARGO BANK",
      immediate_origin_name: "ACME CORPORATION"
    )

    file.batches = []
    file.batches << ::Nacha::Batch.new(
      header: ::Nacha::IatBatchHeaderRecord.new(
        batch_number: 445,
        service_class_code: "200",
        company_entry_description: "EDI PYMNTS",
        effective_entry_date: "220729",
        standard_entry_class_code: "IAT",
        foreign_exchange_indicator: "FF",
        foreign_exchange_reference_indicator: "3",
        go_or_originating_dfi_identification: "09100001",
        iso_destination_country_code: "US",
        iso_destination_currency_code: "USD",
        iso_originating_currency_code: "USD",
        originator_identification: "X111222333",
        originator_status_code: "1",
        settlement_date: "210"
      ),
      entries: [
        ::Nacha::EntryDetail.new(
          record: ::Nacha::IatEntryDetailRecord.new(
            transaction_code: "22",
            addenda_record_indicator: "1",
            amount: 234,
            check_digit: "1",
            foreign_receivers_or_dfi_account_number: "1234567898",
            go_or_receiving_dfi_identification: "02100002",
            number_of_addenda_records: 7,
            trace_number: "091000010091889"
          ),
          addenda: [
            ::Nacha::FirstIatAddendaRecord.new(
              addenda_type_code: "10",
              entry_detail_sequence_number: 91_889,
              foreign_payment_amount: 234,
              receiving_company_or_individual_name: "DARON BERGSTROM",
              transaction_type_code: "DEP"
            ),
            ::Nacha::SecondIatAddendaRecord.new(
              addenda_type_code: "11",
              entry_detail_sequence_number: 91_889,
              originator_name: "ACME CORPORATION",
              originator_street_address: "8992 Chantal Flat"
            ),
            ::Nacha::ThirdIatAddendaRecord.new(
              addenda_type_code: "12",
              entry_detail_sequence_number: 91_889,
              originator_city_and_state: "SAO PAULO*ZZ\\",
              originator_country_and_postal_code: "BR*04543000\\"
            ),
            ::Nacha::FourthIatAddendaRecord.new(
              addenda_type_code: "13",
              entry_detail_sequence_number: 91_889,
              originating_dfi_branch_country_code: "US",
              originating_dfi_identification: "091000019",
              originating_dfi_identification_number_qualifier: "01",
              originating_dfi_name: "WELLS FARGO BANK"
            ),
            ::Nacha::FifthIatAddendaRecord.new(
              addenda_type_code: "14",
              entry_detail_sequence_number: 91_889,
              receiving_dfi_branch_country_code: "US",
              receiving_dfi_identification: "021000021",
              receiving_dfi_identification_number_qualifier: "01",
              receiving_dfi_name: "JPMorgan Chase Bank"
            ),
            ::Nacha::SixthIatAddendaRecord.new(
              addenda_type_code: "15",
              entry_detail_sequence_number: 91_889,
              receiver_identification_number: "GDX001212301234",
              receiver_street_address: "913 Barton Route"
            ),
            ::Nacha::SeventhIatAddendaRecord.new(
              addenda_type_code: "16",
              entry_detail_sequence_number: 91_889,
              receiver_city_and_state: "DHAKA*ZZ\\",
              receiver_country_and_postal_code: "BD*A1A1A1\\"
            )
          ]
        )
      ],
      control: ::Nacha::BatchControlRecord.new(
        batch_number: 445,
        company_identification: "X111222333",
        entry_addenda_count: 8,
        entry_hash: "0002100002",
        message_authentication_code: "",
        originating_dfi_identification: "09100001",
        total_debit_amount: 0,
        total_credit_amount: 234,
        service_class_code: "200"
      )
    )

    file.control = ::Nacha::FileControlRecord.new(
      batch_count: 1,
      block_count: 2,
      entry_addenda_count: 8,
      entry_hash: "0002100002",
      total_debit_amount: 0,
      total_credit_amount: 234
    )

    value(file.generate).must_equal file_contents
  end
end
