# frozen_string_literal: true

#
# = nacha/fifth_iat_addenda_record.rb
#
# Copyright (c) 2022 Jake Howerton
#
# Written and maintained by Jake Howerton <jake@howmeta.com>.
module Nacha
  class FifthIatAddendaRecord < AddendaRecord
    attr_accessor :receiving_dfi_name, :receiving_dfi_identification_number_qualifier,
                  :receiving_dfi_identification, :receiving_dfi_branch_country_code

    def self.parse(input, skip_validation: false)
      new(
        raw_data: input,
        record_type_code: input[0, 1].strip,
        addenda_type_code: input[1, 2].strip,
        receiving_dfi_name: input[3, 35].strip,
        receiving_dfi_identification_number_qualifier: input[38, 2].strip,
        receiving_dfi_identification: input[40, 34].strip,
        receiving_dfi_branch_country_code: input[74, 3].strip,
        entry_detail_sequence_number: input[87, 7]&.strip
      )
    end

    def initialize(options = {})
      self.errors = []
      self.raw_data = options.fetch(:raw_data, nil)
      self.record_type_code = options.fetch(:record_type_code, "7")
      self.addenda_type_code = options.fetch(:addenda_type_code, "14")
      self.receiving_dfi_name = options.fetch(:receiving_dfi_name, nil)
      self.receiving_dfi_identification_number_qualifier = options.fetch(
        :receiving_dfi_identification_number_qualifier, nil
      )
      self.receiving_dfi_identification = options.fetch(:receiving_dfi_identification, nil)
      self.receiving_dfi_branch_country_code = options.fetch(:receiving_dfi_branch_country_code, nil)
      self.entry_detail_sequence_number = options.fetch(:entry_detail_sequence_number, nil)
    end

    def generate
      @raw_data = record_type_code.to_s.ljust(1)
      @raw_data += addenda_type_code.to_s.ljust(2)
      @raw_data += receiving_dfi_name.to_s.ljust(35)
      @raw_data += receiving_dfi_identification_number_qualifier.to_s.ljust(2)
      @raw_data += receiving_dfi_identification.to_s.ljust(34)
      @raw_data += receiving_dfi_branch_country_code.to_s.ljust(3)
      # reserved
      @raw_data += "".ljust(10)
      @raw_data += entry_detail_sequence_number.to_s.rjust(7, "0")
      @raw_data
    end

    def validate
      @errors << "Expected raw data length to be 94, was #{raw_data.length}" if raw_data.length != 94
      @errors << "Expected record type code to be 7, got #{record_type_code}" unless record_type_code == "7"
      @errors << "Expected addenda type code to be 14, got #{addenda_type_code}" unless addenda_type_code == "14"
      @errors.empty?
    end

    def to_h
      {
        record_type_code: record_type_code,
        addenda_type_code: addenda_type_code,
        receiving_dfi_name: receiving_dfi_name,
        receiving_dfi_identification_number_qualifier: receiving_dfi_identification_number_qualifier,
        receiving_dfi_identification: receiving_dfi_identification,
        receiving_dfi_branch_country_code: receiving_dfi_branch_country_code,
        entry_detail_sequence_number: entry_detail_sequence_number
      }
    end
  end
end
