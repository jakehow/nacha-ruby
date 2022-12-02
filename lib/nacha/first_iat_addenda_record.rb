# frozen_string_literal: true

#
# = nacha/addenda_record.rb
#
# Copyright (c) 2022 Jake Howerton
#
# Written and maintained by Jake Howerton <jake@howmeta.com>.

module Nacha
  class FirstIatAddendaRecord < AddendaRecord
    
    attr_accessor :raw_data, :transaction_type_code, :foreign_payment_amount, :foreign_trace_number,
                  :receiving_company_or_individual_name

    def self.parse(input, skip_validation: false)
      record = new(
        raw_data: input,
        record_type_code: input[0,1].strip,
        addenda_type_code: input[1,2].strip,
        transaction_type_code: input[3,3].strip,
        foreign_payment_amount: input[6,18].strip.to_i,
        foreign_trace_number: input[24,22].strip,
        receiving_company_or_individual_name: input[46,35].strip,
        entry_detail_sequence_number: input[87,7]&.strip
      )
      record
    end

    def initialize(options = {})
      self.errors = []
      self.raw_data = options.fetch(:raw_data, nil)
      self.record_type_code = options.fetch(:record_type_code,'7')
      self.addenda_type_code = options.fetch(:addenda_type_code, "10")
      self.transaction_type_code = options.fetch(:transaction_type_code, nil)
      self.foreign_payment_amount = options.fetch(:foreign_payment_amount, nil)
      self.foreign_trace_number = options.fetch(:foreign_trace_number, nil)
      self.receiving_company_or_individual_name = options.fetch(:receiving_company_or_individual_name, nil)
      self.entry_detail_sequence_number = options.fetch(:entry_detail_sequence_number, nil)
    end

    def generate
      @raw_data = record_type_code.to_s.ljust(1)
      @raw_data += addenda_type_code.to_s.ljust(2)
      @raw_data += transaction_type_code.to_s.ljust(3)
      @raw_data += foreign_payment_amount.to_s.rjust(18, "0")
      @raw_data += foreign_trace_number.to_s.rjust(22)
      @raw_data += receiving_company_or_individual_name.to_s.ljust(35)
      # reserved
      @raw_data += ''.ljust(6)
      @raw_data += entry_detail_sequence_number.to_s.rjust(7, '0')
      @raw_data
    end

    def validate
      @errors << "Expected raw data length to be 94, was #{raw_data.length}" if raw_data.length != 94
      @errors << "Expected record_type_code to be '7' but got '#{record_type_code}'" unless record_type_code == '7'
      @errors << "Expected addenda_type_code to be '10' but got '#{addenda_type_code}'" unless addenda_type_code == '10'
      @errors.empty?
    end

    def to_h
      {
        record_type_code: record_type_code,
        addenda_type_code: addenda_type_code, 
        transaction_type_code: transaction_type_code,
        foreign_payment_amount: foreign_payment_amount,
        foreign_trace_number: foreign_trace_number,
        receiving_company_or_individual_name: receiving_company_or_individual_name,
        entry_detail_sequence_number: entry_detail_sequence_number
      }
    end
  end
end
