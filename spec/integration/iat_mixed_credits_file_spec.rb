require "test_helper"

describe "IAT Mixed Credits File" do
  let(:file_contents) { fixture("iat_mixed_credits.ACH") }
  let(:first_batch) { subject.batches.first }
  let(:first_entry) { first_batch.entries.first }

  let(:second_batch) { subject.batches[1] }
  let(:second_entry) { second_batch.entries.first }

  let(:third_batch) { subject.batches[2] }
  let(:third_entry) { third_batch.entries.first }

  subject { ::Nacha::File.parse(file_contents) }

  it "should have a 3 batches" do
    value(subject.batches.length).must_equal 3
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

  it "should have three appropriate batch headers" do
    value(first_batch.header).must_be_instance_of(::Nacha::IatBatchHeaderRecord)
    value(second_batch.header).must_be_instance_of(::Nacha::IatBatchHeaderRecord)
    value(third_batch.header).must_be_instance_of(::Nacha::BatchHeaderRecord)
  end

  it "should have three valid batch headers" do
    value(first_batch.header.validate).must_equal true
    value(second_batch.header.validate).must_equal true
    value(third_batch.header.validate).must_equal true
  end

  it "should have no errors on the batch headers" do
    first_batch.header.validate
    value(first_batch.header.errors).must_be_empty
    second_batch.header.validate
    value(second_batch.header.errors).must_be_empty
    third_batch.header.validate
    value(third_batch.header.errors).must_be_empty
  end

  it "should have a valid BatchControlRecords" do
    value(first_batch.control.validate).must_equal true
    value(second_batch.control.validate).must_equal true
    value(third_batch.control.validate).must_equal true
  end

  it "should have no errors on the BatchControlRecord" do
    first_batch.control.validate
    value(first_batch.control.errors).must_be_empty
    second_batch.control.validate
    value(second_batch.control.errors).must_be_empty
    third_batch.control.validate
    value(third_batch.control.errors).must_be_empty
  end

  it "should have an EntryDetail on each batch" do
    value(first_entry).must_be_instance_of(::Nacha::EntryDetail)
    value(second_entry).must_be_instance_of(::Nacha::EntryDetail)
    value(third_entry).must_be_instance_of(::Nacha::EntryDetail)
  end

  it "should have three valid EntryDetails" do
    value(first_entry.validate).must_equal true
    value(second_entry.validate).must_equal true
    value(third_entry.validate).must_equal true
  end

  it "should have no errors on the EntryDetails" do
    first_entry.validate
    value(first_entry.errors).must_be_empty
    second_entry.validate
    value(second_entry.errors).must_be_empty
    third_entry.validate
    value(third_entry.errors).must_be_empty
  end

  it "should have a correct entry detail record on each entry detail" do
    value(first_entry.record).must_be_instance_of(::Nacha::IatEntryDetailRecord)
    value(second_entry.record).must_be_instance_of(::Nacha::IatEntryDetailRecord)
    value(third_entry.record).must_be_instance_of(::Nacha::EntryDetailRecord)
  end

  it "should have three valid IatEntryDetailRecord" do
    value(first_entry.record.validate).must_equal true
    value(second_entry.record.validate).must_equal true
    value(third_entry.record.validate).must_equal true
  end

  it "should have no errors on the IatEntryDetailRecords" do
    first_entry.record.validate
    value(first_entry.record.errors).must_be_empty
    second_entry.record.validate
    value(second_entry.record.errors).must_be_empty
    third_entry.record.validate
    value(third_entry.record.errors).must_be_empty
  end

  it "should have 7 addenda records on the iat entries" do
    value(first_entry.addenda.length).must_be :>=, 7
    value(second_entry.addenda.length).must_be :>=, 7
  end

  it "should have 0 addenda records on the third entry" do
    value(third_entry.addenda.length).must_equal 0
  end

  it "should have a FirstIatAddendaRecord on the first two entries" do
    value(first_entry.addenda.first).must_be_instance_of(::Nacha::FirstIatAddendaRecord)
    value(second_entry.addenda.first).must_be_instance_of(::Nacha::FirstIatAddendaRecord)
  end

  it "should have a valid FirstIatAddendaRecord on the first two entries" do
    value(first_entry.addenda.first.validate).must_equal true
    value(second_entry.addenda.first.validate).must_equal true
  end

  it "should have no errors on the FirstIatAddendaRecord on the first two entries" do
    first_entry.addenda.first.validate
    value(first_entry.addenda.first.errors).must_be_empty
    second_entry.addenda.first.validate
    value(second_entry.addenda.first.errors).must_be_empty
  end

  it "should have a SecondIatAddendaRecord on the first two entries" do
    value(first_entry.addenda[1]).must_be_instance_of(::Nacha::SecondIatAddendaRecord)
    value(second_entry.addenda[1]).must_be_instance_of(::Nacha::SecondIatAddendaRecord)
  end

  it "should have a valid SecondIatAddendaRecord on the first two entries" do
    value(first_entry.addenda[1].validate).must_equal true
    value(second_entry.addenda[1].validate).must_equal true
  end

  it "should have no errors on the SecondIatAddendaRecord on the first two entries" do
    first_entry.addenda[1].validate
    value(first_entry.addenda[1].errors).must_be_empty
    second_entry.addenda[1].validate
    value(second_entry.addenda[1].errors).must_be_empty
  end

  it "should have a ThirdIatAddendaRecord on the first two entries" do
    value(first_entry.addenda[2]).must_be_instance_of(::Nacha::ThirdIatAddendaRecord)
    value(second_entry.addenda[2]).must_be_instance_of(::Nacha::ThirdIatAddendaRecord)
  end

  it "should have a valid ThirdIatAddendaRecord on the first two entries" do
    value(first_entry.addenda[2].validate).must_equal true
    value(second_entry.addenda[2].validate).must_equal true
  end

  it "should have no errors on the ThirdIatAddendaRecord on the first two entries" do
    first_entry.addenda[2].validate
    value(first_entry.addenda[2].errors).must_be_empty
    second_entry.addenda[2].validate
    value(second_entry.addenda[2].errors).must_be_empty
  end

  it "should have a FourthIatAddendaRecord on the first two entries" do
    value(first_entry.addenda[3]).must_be_instance_of(::Nacha::FourthIatAddendaRecord)
    value(second_entry.addenda[3]).must_be_instance_of(::Nacha::FourthIatAddendaRecord)
  end

  it "should have a valid FourthIatAddendaRecord on the first two entries" do
    value(first_entry.addenda[3].validate).must_equal true
    value(second_entry.addenda[3].validate).must_equal true
  end

  it "should have no errors on the FourthIatAddendaRecord on the first two entries" do
    first_entry.addenda[3].validate
    value(first_entry.addenda[3].errors).must_be_empty
    second_entry.addenda[3].validate
    value(second_entry.addenda[3].errors).must_be_empty
  end

  it "should have a FifthIatAddendaRecord on the first two entries" do
    value(first_entry.addenda[4]).must_be_instance_of(::Nacha::FifthIatAddendaRecord)
    value(second_entry.addenda[4]).must_be_instance_of(::Nacha::FifthIatAddendaRecord)
  end

  it "should have a valid FifthIatAddendaRecord on the first two entries" do
    value(first_entry.addenda[4].validate).must_equal true
    value(second_entry.addenda[4].validate).must_equal true
  end

  it "should have no errors on the FifthIatAddendaRecord on the first two entries" do
    first_entry.addenda[4].validate
    value(first_entry.addenda[4].errors).must_be_empty
    second_entry.addenda[4].validate
    value(second_entry.addenda[4].errors).must_be_empty
  end

  it "should have a SixthIatAddendaRecord on the first two entries" do
    value(first_entry.addenda[5]).must_be_instance_of(::Nacha::SixthIatAddendaRecord)
    value(second_entry.addenda[5]).must_be_instance_of(::Nacha::SixthIatAddendaRecord)
  end

  it "should have a valid SixthIatAddendaRecord on the first two entries" do
    value(first_entry.addenda[5].validate).must_equal true
    value(second_entry.addenda[5].validate).must_equal true
  end

  it "should have no errors on the SixthIatAddendaRecord on the first two entries" do
    first_entry.addenda[5].validate
    value(first_entry.addenda[5].errors).must_be_empty
    second_entry.addenda[5].validate
    value(second_entry.addenda[5].errors).must_be_empty
  end

  it "should have a SeventhIatAddendaRecord on the first two entries" do
    value(first_entry.addenda[6]).must_be_instance_of(::Nacha::SeventhIatAddendaRecord)
    value(second_entry.addenda[6]).must_be_instance_of(::Nacha::SeventhIatAddendaRecord)
  end

  it "should have a valid SeventhIatAddendaRecord on the first two entries" do
    value(first_entry.addenda[6].validate).must_equal true
    value(second_entry.addenda[6].validate).must_equal true
  end

  it "should have no errors on the SeventhIatAddendaRecord on the first two entries" do
    first_entry.addenda[6].validate
    value(first_entry.addenda[6].errors).must_be_empty
    second_entry.addenda[6].validate
    value(second_entry.addenda[6].errors).must_be_empty
  end

  it "should have a RemittanceInfoIatAddendaRecord on the first two entries" do
    value(first_entry.addenda[7]).must_be_instance_of(::Nacha::RemittanceInfoIatAddendaRecord)
    value(second_entry.addenda[7]).must_be_instance_of(::Nacha::RemittanceInfoIatAddendaRecord)
  end

  it "should have a valid RemittanceInfoIatAddendaRecord on the first two entries" do
    value(first_entry.addenda[7].validate).must_equal true
    value(second_entry.addenda[7].validate).must_equal true
  end

  it "should have no errors on the RemittanceInfoIatAddendaRecord on the first two entries" do
    first_entry.addenda[7].validate
    value(first_entry.addenda[7].errors).must_be_empty
    second_entry.addenda[7].validate
    value(second_entry.addenda[7].errors).must_be_empty
  end

  it "should have a ForeignCorrespondentBankIatAddendaRecord on the first two entries" do
    value(first_entry.addenda[8]).must_be_instance_of(::Nacha::ForeignCorrespondentBankIatAddendaRecord)
    value(second_entry.addenda[8]).must_be_instance_of(::Nacha::ForeignCorrespondentBankIatAddendaRecord)
  end

  it "should have a valid ForeignCorrespondentBankIatAddendaRecord on the first two entries" do
    value(first_entry.addenda[8].validate).must_equal true
    value(second_entry.addenda[8].validate).must_equal true
  end

  it "should have no errors on the ForeignCorrespondentBankIatAddendaRecord on the first two entries" do
    first_entry.addenda[8].validate
    value(first_entry.addenda[8].errors).must_be_empty
    second_entry.addenda[8].validate
    value(second_entry.addenda[8].errors).must_be_empty
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
      file_creation_date: "220728",
      file_creation_time: "1647",
      file_id_modifier: "D",
      record_size: "094",
      blocking_factor: 10,
      format_code: "1",
      immediate_destination_name: "JPMORGAN CHASE BANK",
      immediate_origin_name: "ACME CORPORATION"
    )

    file.batches = []
    file.batches << ::Nacha::Batch.new(
      header: ::Nacha::IatBatchHeaderRecord.new(
        batch_number: 1234,
        service_class_code: "200",
        company_entry_description: "PAYMENT",
        effective_entry_date: "220729",
        standard_entry_class_code: "IAT",
        foreign_exchange_indicator: "FF",
        foreign_exchange_reference_indicator: "3",
        go_or_originating_dfi_identification: "11100002",
        iso_destination_country_code: "US",
        iso_destination_currency_code: "USD",
        iso_originating_currency_code: "USD",
        originator_identification: "3121233121",
        originator_status_code: "1",
        settlement_date: "210"
      ),
      entries: [
        ::Nacha::EntryDetail.new(
          record: ::Nacha::IatEntryDetailRecord.new(
            transaction_code: "22",
            addenda_record_indicator: "1",
            amount: 39,
            check_digit: "1",
            foreign_receivers_or_dfi_account_number: "1230000099",
            go_or_receiving_dfi_identification: "02100002",
            number_of_addenda_records: 9,
            secondary_ofac_screening_indicator: "0",
            trace_number: "111000012345678"
          ),
          addenda: [
            ::Nacha::FirstIatAddendaRecord.new(
              entry_detail_sequence_number: 2_131_234,
              foreign_payment_amount: 0,
              receiving_company_or_individual_name: "LUDIE D. EDWARDS",
              transaction_type_code: "MIS"
            ),
            ::Nacha::SecondIatAddendaRecord.new(
              entry_detail_sequence_number: 2_131_234,
              originator_name: "BETA INC",
              originator_street_address: "143 LIND PASSAGE"
            ),
            ::Nacha::ThirdIatAddendaRecord.new(
              addenda_type_code: "12",
              entry_detail_sequence_number: 2_131_234,
              originator_city_and_state: "LUXEMBOURG*LU\\",
              originator_country_and_postal_code: "LU*L-1855\\"
            ),
            ::Nacha::FourthIatAddendaRecord.new(
              entry_detail_sequence_number: 2_131_234,
              originating_dfi_branch_country_code: "US",
              originating_dfi_identification: "121000358",
              originating_dfi_identification_number_qualifier: "01",
              originating_dfi_name: "BANK OF AMERICA NA"
            ),
            ::Nacha::FifthIatAddendaRecord.new(
              entry_detail_sequence_number: 2_131_234,
              receiving_dfi_branch_country_code: "US",
              receiving_dfi_identification: "021000021",
              receiving_dfi_identification_number_qualifier: "01",
              receiving_dfi_name: "JPMorgan Chase Bank"
            ),
            ::Nacha::SixthIatAddendaRecord.new(
              entry_detail_sequence_number: 2_131_234,
              receiver_identification_number: "99123456789",
              receiver_street_address: "123 TREBLE WAY"
            ),
            ::Nacha::SeventhIatAddendaRecord.new(
              entry_detail_sequence_number: 2_131_234,
              receiver_city_and_state: "DHAKA\\",
              receiver_country_and_postal_code: "BD*1400 DHAKA\\"
            ),
            ::Nacha::RemittanceInfoIatAddendaRecord.new(
              addenda_sequence_number: 1,
              entry_detail_sequence_number: 2_131_234,
              payment_related_information: "ABC123456789"
            ),
            ::Nacha::ForeignCorrespondentBankIatAddendaRecord.new(
              entry_detail_sequence_number: 2_131_234,
              addenda_sequence_number: 2,
              foreign_correspondent_bank_branch_country_code: "CA",
              foreign_correspondent_bank_identification_number: "121000358",
              foreign_correspondent_bank_identification_number_qualifier: "01",
              foreign_correspondent_bank_name: "BANK OF AMERICA CANADA"
            )
          ]
        )
      ],
      control: ::Nacha::BatchControlRecord.new(
        batch_number: 1234,
        company_identification: "3121233121",
        entry_addenda_count: 10,
        entry_hash: "0002100002",
        message_authentication_code: "",
        originating_dfi_identification: "11100002",
        total_debit_amount: 0,
        total_credit_amount: 39,
        service_class_code: "200"
      )
    )

    # Second IAT Batch
    file.batches << ::Nacha::Batch.new(
      header: ::Nacha::IatBatchHeaderRecord.new(
        batch_number: 3366,
        service_class_code: "200",
        company_entry_description: "PAYMENT",
        effective_entry_date: "220729",
        standard_entry_class_code: "IAT",
        foreign_exchange_indicator: "FF",
        foreign_exchange_reference_indicator: "3",
        go_or_originating_dfi_identification: "11100002",
        iso_destination_country_code: "US",
        iso_destination_currency_code: "USD",
        iso_originating_currency_code: "USD",
        originator_identification: "3121233121",
        originator_status_code: "1",
        settlement_date: "210"
      ),
      entries: [
        ::Nacha::EntryDetail.new(
          record: ::Nacha::IatEntryDetailRecord.new(
            transaction_code: "22",
            addenda_record_indicator: "1",
            amount: 103,
            check_digit: "1",
            foreign_receivers_or_dfi_account_number: "9991231234",
            go_or_receiving_dfi_identification: "02100002",
            number_of_addenda_records: 9,
            secondary_ofac_screening_indicator: "0",
            trace_number: "111000023210012"
          ),
          addenda: [
            ::Nacha::FirstIatAddendaRecord.new(
              entry_detail_sequence_number: 3_210_012,
              foreign_payment_amount: 0,
              receiving_company_or_individual_name: "ELSA JENNINGS",
              transaction_type_code: "MIS"
            ),
            ::Nacha::SecondIatAddendaRecord.new(
              entry_detail_sequence_number: 3_210_012,
              originator_name: "BETA INC",
              originator_street_address: "143 LIND PASSAGE"
            ),
            ::Nacha::ThirdIatAddendaRecord.new(
              entry_detail_sequence_number: 3_210_012,
              originator_city_and_state: "LUXEMBOURG*LU\\",
              originator_country_and_postal_code: "LU*L-1855\\"
            ),
            ::Nacha::FourthIatAddendaRecord.new(
              entry_detail_sequence_number: 3_210_012,
              originating_dfi_branch_country_code: "US",
              originating_dfi_identification: "121000358",
              originating_dfi_identification_number_qualifier: "01",
              originating_dfi_name: "BANK OF AMERICA NA"
            ),
            ::Nacha::FifthIatAddendaRecord.new(
              entry_detail_sequence_number: 3_210_012,
              receiving_dfi_branch_country_code: "US",
              receiving_dfi_identification: "021000021",
              receiving_dfi_identification_number_qualifier: "01",
              receiving_dfi_name: "JPMorgan Chase Bank"
            ),
            ::Nacha::SixthIatAddendaRecord.new(
              entry_detail_sequence_number: 3_210_012,
              receiver_identification_number: "991234123012",
              receiver_street_address: "MAPLE DRIVE TERRACE"
            ),
            ::Nacha::SeventhIatAddendaRecord.new(
              entry_detail_sequence_number: 3_210_012,
              receiver_city_and_state: "DHAKA\\",
              receiver_country_and_postal_code: "BD*4100 DHAKA\\"
            ),
            ::Nacha::RemittanceInfoIatAddendaRecord.new(
              addenda_sequence_number: 1,
              entry_detail_sequence_number: 3_210_012,
              payment_related_information: "ABC123456789"
            ),
            ::Nacha::ForeignCorrespondentBankIatAddendaRecord.new(
              entry_detail_sequence_number: 3_210_012,
              addenda_sequence_number: 2,
              foreign_correspondent_bank_branch_country_code: "CA",
              foreign_correspondent_bank_identification_number: "121000358",
              foreign_correspondent_bank_identification_number_qualifier: "01",
              foreign_correspondent_bank_name: "BANK OF AMERICA CANADA"
            )
          ]
        )
      ],
      control: ::Nacha::BatchControlRecord.new(
        batch_number: 3366,
        company_identification: "3121233121",
        entry_addenda_count: 10,
        entry_hash: "0002100002",
        message_authentication_code: "",
        originating_dfi_identification: "11100002",
        total_debit_amount: 0,
        total_credit_amount: 103,
        service_class_code: "200"
      )
    )

    # Debit Batch

    file.batches << ::Nacha::Batch.new(
      header: ::Nacha::BatchHeaderRecord.new(
        service_class_code: "200",
        company_name: "ACME U",
        company_discretionary_data: "",
        company_identification: "1233211212",
        standard_entry_class_code: "WEB",
        company_entry_description: "PAYMNT",
        effective_entry_date: "220729",
        settlement_date: "210",
        originator_status_code: "1",
        originating_dfi_identification: "09100001",
        batch_number: 20_123
      ),
      entries: [
        ::Nacha::EntryDetail.new(
          record: ::Nacha::EntryDetailRecord.new(
            addenda_record_indicator: 0,
            amount: 3_123_400,
            check_digit: "1",
            dfi_account_number: "9990000123",
            discretionary_data: "S",
            transaction_code: "27",
            individual_identification_number: "000000123321432",
            individual_name: "BEN NILSON",
            receiving_dfi_identification: "02100002",
            trace_number: "021000013232112"
          )
        )
      ],
      control: ::Nacha::BatchControlRecord.new(
        service_class_code: "200",
        entry_hash: "0002100002",
        entry_addenda_count: 1,
        total_debit_amount: 3_123_400,
        total_credit_amount: 0,
        company_identification: "1233211212",
        originating_dfi_identification: "09100001",
        batch_number: 20_123
      )
    )

    file.control = ::Nacha::FileControlRecord.new(
      batch_count: 3,
      block_count: 3,
      entry_addenda_count: 21,
      entry_hash: "0007821945",
      total_debit_amount: 3_123_400,
      total_credit_amount: 142
    )

    value(file.generate).must_equal file_contents
  end
end
