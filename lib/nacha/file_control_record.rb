# frozen_string_literal: true

#
# = nacha/file_control_record.rb
#
# Copyright (c) 2022 Jake Howerton
#
# Written and maintained by Jake Howerton <jake@howmeta.com>.

require_relative "record"

module Nacha
  class FileControlRecord < Record
    attr_accessor :batch_count, :block_count, :entry_addenda_count, :entry_hash,
                  :total_debit_amount, :total_credit_amount

    def self.parse(input, skip_validation: false)
      file_control = new(
        raw_data: input,
        record_type_code: input[0, 1].strip,
        batch_count: input[1, 6].strip.to_i,
        block_count: input[7, 6].strip.to_i,
        entry_addenda_count: input[13, 8].strip.to_i,
        entry_hash: input[21, 10].strip,
        total_debit_amount: input[31, 12].strip.to_i,
        total_credit_amount: input[43, 12].strip.to_i
      )
      file_control.validate! unless skip_validation
      file_control
    end

    def initialize(options = {})
      self.errors = []
      self.raw_data = options.fetch(:raw_data, nil)
      self.record_type_code = options.fetch(:record_type_code, "9")
      self.batch_count = options.fetch(:batch_count, nil)
      self.block_count = options.fetch(:block_count, nil)
      self.entry_addenda_count = options.fetch(:entry_addenda_count, nil)
      self.entry_hash = options.fetch(:entry_hash, nil)
      self.total_debit_amount = options.fetch(:total_debit_amount, nil)
      self.total_credit_amount = options.fetch(:total_credit_amount, nil)
    end

    def generate
      @raw_data = record_type_code.to_s.ljust(1)
      @raw_data += batch_count.to_s.rjust(6, "0")
      @raw_data += block_count.to_s.rjust(6, "0")
      @raw_data += entry_addenda_count.to_s.rjust(8, "0")
      @raw_data += entry_hash.to_s.rjust(10, "0")
      @raw_data += total_debit_amount.to_s.rjust(12, "0")
      @raw_data += total_credit_amount.to_s.rjust(12, "0")
      @raw_data += "".ljust(39)
      @raw_data
    end

    def validate
      record_type_code == "9"
    end

    def to_h
      {
        record_type_code: record_type_code,
        batch_count: batch_count,
        block_count: block_count,
        entry_addenda_count: entry_addenda_count,
        entry_hash: entry_hash,
        total_debit_amount: total_debit_amount,
        total_credit_amount: total_credit_amount
      }
    end
  end
end
