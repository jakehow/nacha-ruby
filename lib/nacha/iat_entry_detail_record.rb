# frozen_string_literal: true

#
# = nacha/iat_entry_detail_record.rb
#
# Copyright (c) 2022 Jake Howerton
#
# Written and maintained by Jake Howerton <jake@howmeta.com>.

require_relative "record"

module Nacha
  class IatEntryDetailRecord < Record
    attr_accessor :transaction_code, :go_or_receiving_dfi_identification, :check_digit, :number_of_addenda_records,
                  :amount, :foreign_receivers_or_dfi_account_number, :gateway_operator_ofac_screening_indicator,
                  :secondary_ofac_screening_indicator, :addenda_record_indicator, :trace_number

    def self.parse(input, skip_validation = false)
      new(
        raw_data: input,
        record_type_code: input[0, 1].strip,
        transaction_code: input[1, 2].strip,
        go_or_receiving_dfi_identification: input[3, 8].strip,
        check_digit: input[11, 1].strip,
        number_of_addenda_records: input[12, 4].strip,
        amount: input[29, 10].strip.to_i,
        foreign_receivers_or_dfi_account_number: input[39, 35].strip,
        gateway_operator_ofac_screening_indicator: input[76, 1].strip,
        secondary_ofac_screening_indicator: input[77, 1].strip,
        addenda_record_indicator: input[78, 1].strip,
        trace_number: input[79, 15].strip
      )
    end

    def initialize(options = {})
      self.errors = []
      self.raw_data = options.fetch(:raw_data, nil)
      self.record_type_code = options.fetch(:record_type_code, "6")
      self.transaction_code = options.fetch(:transaction_code, nil)
      self.go_or_receiving_dfi_identification = options.fetch(:go_or_receiving_dfi_identification, nil)
      self.check_digit = options.fetch(:check_digit, nil)
      self.number_of_addenda_records = options.fetch(:number_of_addenda_records, nil)
      self.amount = options.fetch(:amount, nil)
      self.foreign_receivers_or_dfi_account_number = options.fetch(:foreign_receivers_or_dfi_account_number, nil)
      self.gateway_operator_ofac_screening_indicator = options.fetch(:gateway_operator_ofac_screening_indicator, nil)
      self.secondary_ofac_screening_indicator = options.fetch(:secondary_ofac_screening_indicator, nil)
      self.addenda_record_indicator = options.fetch(:addenda_record_indicator, nil)
      self.trace_number = options.fetch(:trace_number, nil)
    end

    def sequence_number
      trace_number[9, 5]
    end

    def validate
      errors << "Expected raw data length to be 94, was #{raw_data.length}" if raw_data && raw_data.length != 94
      errors.empty?
    end

    def generate
      @raw_data = record_type_code.to_s.ljust(1)
      @raw_data += transaction_code.to_s.ljust(2)
      @raw_data += go_or_receiving_dfi_identification.to_s.ljust(8)
      @raw_data += check_digit.to_s.ljust(1)
      @raw_data += number_of_addenda_records.to_s.rjust(4, "0")
      @raw_data += "".ljust(13)
      @raw_data += amount.to_s.rjust(10, "0")
      @raw_data += foreign_receivers_or_dfi_account_number.to_s.ljust(35)
      @raw_data += "".to_s.ljust(2)
      @raw_data += gateway_operator_ofac_screening_indicator.to_s.rjust(1)
      @raw_data += secondary_ofac_screening_indicator.to_s.rjust(1)
      @raw_data += addenda_record_indicator.to_s.rjust(1)
      @raw_data += trace_number.to_s.rjust(15)
      @raw_data
    end

    def to_h
      {
        record_type_code: record_type_code,
        transaction_code: transaction_code,
        go_or_receiving_dfi_identification: go_or_receiving_dfi_identification,
        check_digit: check_digit,
        number_of_addenda_records: number_of_addenda_records,
        amount: amount,
        foreign_receivers_or_dfi_account_number: foreign_receivers_or_dfi_account_number,
        gateway_operator_ofac_screening_indicator: gateway_operator_ofac_screening_indicator,
        secondary_ofac_screening_indicator: secondary_ofac_screening_indicator,
        addenda_record_indicator: addenda_record_indicator,
        trace_number: trace_number
      }
    end
  end
end
