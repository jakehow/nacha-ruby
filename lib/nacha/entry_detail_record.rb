# frozen_string_literal: true

#
# = nacha/entry_detail_record.rb
#
# Copyright (c) 2022 Jake Howerton
#
# Written and maintained by Jake Howerton <jake@howmeta.com>.

require_relative "record"

module Nacha
  class EntryDetailRecord < Record
    attr_accessor :transaction_code, :receiving_dfi_identification, :check_digit, :dfi_account_number, :amount,
                  :individual_identification_number, :individual_name, :discretionary_data, :addenda_record_indicator,
                  :trace_number

    def self.parse(input, skip_validation: true)
      record = new(
        raw_data: input,
        record_type_code: input[0, 1]&.strip,
        transaction_code: input[1, 2]&.strip,
        receiving_dfi_identification: input[3, 8]&.strip,
        check_digit: input[11, 1]&.strip,
        dfi_account_number: input[12, 17]&.strip,
        amount: input[29, 10]&.strip.to_i,
        individual_identification_number: input[39, 15]&.strip,
        individual_name: input[54, 22]&.strip,
        discretionary_data: input[76, 2]&.strip,
        addenda_record_indicator: input[78, 1]&.strip,
        trace_number: input[79, 15]&.strip
      )
      record.validate! unless skip_validation
      record
    end

    def initialize(options = {})
      self.errors = []
      self.raw_data = options.fetch(:raw_data, nil)
      self.record_type_code = options.fetch(:record_type_code, "6")
      self.transaction_code = options.fetch(:transaction_code, nil)
      self.receiving_dfi_identification = options.fetch(:receiving_dfi_identification, nil)
      self.check_digit = options.fetch(:check_digit, nil)
      self.dfi_account_number = options.fetch(:dfi_account_number, nil)
      self.amount = options.fetch(:amount, nil)
      self.individual_identification_number = options.fetch(:individual_identification_number, nil)
      self.individual_name = options.fetch(:individual_name, nil)
      self.discretionary_data = options.fetch(:discretionary_data, nil)
      self.addenda_record_indicator = options.fetch(:addenda_record_indicator, nil)
      self.trace_number = options.fetch(:trace_number, nil)
    end

    def validate
      true
    end

    def generate
      @raw_data = record_type_code.to_s.ljust(1)
      @raw_data += transaction_code.to_s.ljust(2)
      @raw_data += receiving_dfi_identification.to_s.ljust(8)
      @raw_data += check_digit.to_s.ljust(1)
      @raw_data += dfi_account_number.to_s.ljust(17)
      @raw_data += amount.to_s.rjust(10, "0")
      @raw_data += individual_identification_number.to_s.ljust(15)
      @raw_data += individual_name.to_s.ljust(22)
      @raw_data += discretionary_data.to_s.ljust(2)
      @raw_data += addenda_record_indicator.to_s.ljust(1)
      @raw_data += trace_number.to_s.rjust(15)
      @raw_data
    end

    def to_h
      {
        record_type_code: record_type_code,
        transaction_code: transaction_code,
        receiving_dfi_identification: receiving_dfi_identification,
        check_digit: check_digit,
        dfi_account_number: dfi_account_number,
        amount: amount,
        individual_identification_number: individual_identification_number,
        individual_name: individual_name,
        discretionary_data: discretionary_data,
        addenda_record_indicator: addenda_record_indicator,
        trace_number: trace_number
      }
    end
  end
end
