# frozen_string_literal: true

#
# = nacha/batch_control_record.rb
#
# Copyright (c) 2022 Jake Howerton
#
# Written and maintained by Jake Howerton <jake@howmeta.com>.

require_relative "record"

module Nacha
  class BatchControlRecord < Record
    attr_accessor :raw_data, :service_class_code, :entry_addenda_count, :entry_hash, :total_debit_amount, :total_credit_amount,
                  :company_identification, :message_authentication_code, :originating_dfi_identification,
                  :batch_number

    def self.parse(input, skip_validation: false)
      new(
        raw_data: input,
        record_type_code: input[0, 1].strip,
        service_class_code: input[1, 3].strip,
        entry_addenda_count: input[4, 6].strip.to_i,
        entry_hash: input[10, 10].strip,
        total_debit_amount: input[20, 12].strip.to_i,
        total_credit_amount: input[32, 12].strip.to_i,
        company_identification: input[44, 10].strip,
        message_authentication_code: input[54, 19].strip,
        originating_dfi_identification: input[79, 8].strip,
        batch_number: input[87, 7].strip
      )
    end

    def initialize(options = {})
      self.errors = []
      self.raw_data = options[:raw_data]
      self.record_type_code = options.fetch(:record_type_code, "8")
      self.service_class_code = options.fetch(:service_class_code, nil)
      self.entry_addenda_count = options.fetch(:entry_addenda_count, nil)
      self.entry_hash = options.fetch(:entry_hash, nil)
      self.total_debit_amount = options.fetch(:total_debit_amount, nil)
      self.total_credit_amount = options.fetch(:total_credit_amount, nil)
      self.company_identification = options.fetch(:company_identification, nil)
      self.message_authentication_code = options.fetch(:message_authentication_code, nil)
      self.originating_dfi_identification = options.fetch(:originating_dfi_identification, nil)
      self.batch_number = options.fetch(:batch_number, nil)
    end

    def validate
      true
    end

    def generate
      @raw_data = record_type_code.to_s.ljust(1)
      @raw_data += service_class_code.to_s.ljust(3)
      @raw_data += entry_addenda_count.to_s.rjust(6, "0")
      @raw_data += entry_hash.to_s.rjust(10, "0")
      @raw_data += total_debit_amount.to_s.rjust(12, "0")
      @raw_data += total_credit_amount.to_s.rjust(12, "0")
      @raw_data += company_identification.to_s.ljust(10)
      @raw_data += message_authentication_code.to_s.ljust(19)
      # reserved
      @raw_data += "".ljust(6)
      @raw_data += originating_dfi_identification.to_s.ljust(8)
      @raw_data += batch_number.to_s.rjust(7, "0")
      @raw_data
    end

    def to_h
      {
        record_type_code: record_type_code,
        service_class_code: service_class_code,
        entry_addenda_count: entry_addenda_count,
        entry_hash: entry_hash,
        total_debit_amount: total_debit_amount,
        total_credit_amount: total_credit_amount,
        company_identification: company_identification,
        message_authentication_code: message_authentication_code,
        originating_dfi_identification: originating_dfi_identification,
        batch_number: batch_number
      }
    end
  end
end
