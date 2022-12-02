# frozen_string_literal: true

#
# = nacha/remittance_info_iat_addenda_record.rb
#
# Copyright (c) 2022 Jake Howerton
#
# Written and maintained by Jake Howerton <jake@howmeta.com>.

require_relative "record"

module Nacha
  class RemittanceInfoIatAddendaRecord < AddendaRecord
    attr_accessor :payment_related_information, :addenda_sequence_number

    def initialize(options = {})
      self.errors = []
      self.raw_data = options.fetch(:raw_data, nil)
      self.record_type_code = options.fetch(:record_type_code, "7")
      self.addenda_type_code = options.fetch(:addenda_type_code, "17")
      self.payment_related_information = options.fetch(:payment_related_information, nil)
      self.addenda_sequence_number = options.fetch(:addenda_sequence_number, nil)
      self.entry_detail_sequence_number = options.fetch(:entry_detail_sequence_number, nil)
    end

    def self.parse(input, skip_validation: false)
      record = new(
        raw_data: input,
        record_type_code: input[0,1]&.strip,
        addenda_type_code: input[1,2]&.strip,
        payment_related_information: input[3,80]&.strip,
        addenda_sequence_number: input[83,4]&.strip,
        entry_detail_sequence_number: input[87,7]&.strip
      )
      record.validate! unless skip_validation
      record
    end

    def validate
      true
    end

    def generate
      @raw_data = record_type_code.to_s.ljust(1)
      @raw_data += addenda_type_code.to_s.ljust(2)
      @raw_data += payment_related_information.to_s.ljust(80)
      @raw_data += addenda_sequence_number.to_s.rjust(4, "0")
      @raw_data += entry_detail_sequence_number.to_s.rjust(7, "0")
      @raw_data
    end

    def to_h
      {
        record_type_code: record_type_code,
        addenda_type_code: addenda_type_code, 
        payment_related_information: payment_related_information,
        addenda_sequence_number: addenda_sequence_number,
        entry_detail_sequence_number: entry_detail_sequence_number
      }
    end
  end
end
