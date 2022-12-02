# frozen_string_literal: true

#
# = nacha/sixth_iat_addenda_record.rb
#
# Copyright (c) 2022 Jake Howerton
#
# Written and maintained by Jake Howerton <jake@howmeta.com>.
module Nacha
  class SixthIatAddendaRecord < AddendaRecord
    attr_accessor :receiver_identification_number, :receiver_street_address
                  
    def self.parse(input, skip_validation: false)
      record = new(
        raw_data: input,
        record_type_code: input[0,1].strip,
        addenda_type_code: input[1,2].strip,
        receiver_identification_number: input[3,15].strip,
        receiver_street_address: input[18,35].strip,
        entry_detail_sequence_number: input[87,7]&.strip
      )
      record.raw_data = input
      record.record_type_code = input[0, 1].strip
      record.addenda_type_code = input[1, 2].strip
      record.receiver_identification_number = input[3, 15].strip
      record.receiver_street_address = input[18, 35].strip
      record.entry_detail_sequence_number = input[87, 7].strip
      record
    end

    def initialize(options = {})
      self.errors = []
      self.raw_data = options.fetch(:raw_data, nil)
      self.record_type_code = options.fetch(:record_type_code, '7')
      self.addenda_type_code = options.fetch(:addenda_type_code, "15")
      self.receiver_identification_number = options.fetch(:receiver_identification_number, nil)
      self.receiver_street_address = options.fetch(:receiver_street_address, nil)
      self.entry_detail_sequence_number = options.fetch(:entry_detail_sequence_number, nil)
    end

    def generate
      @raw_data = record_type_code.to_s.ljust(1)
      @raw_data += addenda_type_code.to_s.ljust(2)
      @raw_data += receiver_identification_number.to_s.ljust(15)
      @raw_data += receiver_street_address.to_s.ljust(35)
      # reserved
      @raw_data += "".ljust(34)
      @raw_data += entry_detail_sequence_number.to_s.rjust(7, "0")
      @raw_data
    end

    def validate
      @errors << "Expected raw data length to be 94, was #{raw_data.length}" if raw_data.length != 94
      @errors << "Expected record type code to be 7, got #{record_type_code}" unless record_type_code == '7'
      @errors << "Expected addenda type code to be 15, got #{addenda_type_code}" unless addenda_type_code == '15'
      @errors.empty?
    end

    def to_h
      {
        record_type_code: record_type_code,
        addenda_type_code: addenda_type_code, 
        receiver_identification_number: receiver_identification_number,
        receiver_street_address: receiver_street_address, 
        entry_detail_sequence_number: entry_detail_sequence_number
      }
    end
  end
end
