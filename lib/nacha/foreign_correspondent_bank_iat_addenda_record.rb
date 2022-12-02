# frozen_string_literal: true

#
# = nacha/addenda_record.rb
#
# Copyright (c) 2022 Jake Howerton
#
# Written and maintained by Jake Howerton <jake@howmeta.com>.

require_relative "record"

module Nacha
  class ForeignCorrespondentBankIatAddendaRecord < AddendaRecord
    attr_accessor :foreign_correspondent_bank_name, :foreign_correspondent_bank_identification_number_qualifier,
                  :foreign_correspondent_bank_identification_number, :foreign_correspondent_bank_branch_country_code,
                  :addenda_sequence_number

    def self.parse(input, skip_validation: true)
      record = new(
        raw_data: input,
        record_type_code: input[0, 1]&.strip,
        addenda_type_code: input[1, 2]&.strip,
        foreign_correspondent_bank_name: input[3, 35]&.strip,
        foreign_correspondent_bank_identification_number_qualifier: input[38, 2]&.strip,
        foreign_correspondent_bank_identification_number: input[40, 34]&.strip,
        foreign_correspondent_bank_branch_country_code: input[74, 3]&.strip,
        addenda_sequence_number: input[83, 4]&.strip,
        entry_detail_sequence_number: input[87, 7]&.strip
      )
      record.validdate! unless skip_validation
      record
    end

    def initialize(options = {})
      self.errors = []
      self.raw_data = options.fetch(:raw_data, nil)
      self.record_type_code = options.fetch(:record_type_code, "7")
      self.addenda_type_code = options.fetch(:addenda_type_code, "18")
      self.foreign_correspondent_bank_name = options.fetch(:foreign_correspondent_bank_name, nil)
      self.foreign_correspondent_bank_identification_number_qualifier = options.fetch(
        :foreign_correspondent_bank_identification_number_qualifier, nil
      )
      self.foreign_correspondent_bank_identification_number = options.fetch(
        :foreign_correspondent_bank_identification_number, nil
      )
      self.foreign_correspondent_bank_branch_country_code = options.fetch(
        :foreign_correspondent_bank_branch_country_code, nil
      )
      self.addenda_sequence_number = options.fetch(:addenda_sequence_number, nil)
      self.entry_detail_sequence_number = options.fetch(:entry_detail_sequence_number, nil)
    end

    def validate
      true
    end

    def generate
      @raw_data = record_type_code.to_s.ljust(1)
      @raw_data += addenda_type_code.to_s.ljust(2)
      @raw_data += foreign_correspondent_bank_name.to_s.ljust(35)
      @raw_data += foreign_correspondent_bank_identification_number_qualifier.to_s.ljust(2)
      @raw_data += foreign_correspondent_bank_identification_number.to_s.ljust(34)
      @raw_data += foreign_correspondent_bank_branch_country_code.to_s.ljust(3)
      @raw_data += "".ljust(6)
      @raw_data += addenda_sequence_number.to_s.rjust(4, "0")
      @raw_data += entry_detail_sequence_number.to_s.rjust(7)
      @raw_data
    end

    def to_h
      {
        record_type_code: record_type_code,
        addenda_type_code: addenda_type_code,
        foreign_correspondent_bank_name: foreign_correspondent_bank_name,
        foreign_correspondent_bank_identification_number_qualifier: foreign_correspondent_bank_identification_number_qualifier,
        foreign_correspondent_bank_identification_number: foreign_correspondent_bank_identification_number,
        foreign_correspondent_bank_branch_country_code: foreign_correspondent_bank_branch_country_code,
        addenda_sequence_number: addenda_sequence_number,
        entry_detail_sequence_number: entry_detail_sequence_number
      }
    end
  end
end
