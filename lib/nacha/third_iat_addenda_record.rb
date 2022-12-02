# frozen_string_literal: true

#
# = nacha/third_iat_addenda_record.rb
#
# Copyright (c) 2022 Jake Howerton
#
# Written and maintained by Jake Howerton <jake@howmeta.com>.

module Nacha
  class ThirdIatAddendaRecord < AddendaRecord
    attr_accessor :originator_city_and_state, :originator_country_and_postal_code

    def self.parse(input, skip_validation: false)
      new(
        raw_data: input,
        record_type_code: input[0, 1].strip,
        addenda_type_code: input[1, 2].strip,
        originator_city_and_state: input[3, 35].strip,
        originator_country_and_postal_code: input[38, 35].strip,
        entry_detail_sequence_number: input[87, 7]&.strip
      )
    end

    def initialize(options = {})
      self.errors = []
      self.raw_data = options.fetch(:raw_data, nil)
      self.record_type_code = options.fetch(:record_type_code, "7")
      self.addenda_type_code = options.fetch(:addenda_type_code, "12")
      self.originator_city_and_state = options.fetch(:originator_city_and_state, nil)
      self.originator_country_and_postal_code = options.fetch(:originator_country_and_postal_code, nil)
      self.entry_detail_sequence_number = options.fetch(:entry_detail_sequence_number, nil)
    end

    def generate
      @raw_data = record_type_code.to_s.ljust(1)
      @raw_data += addenda_type_code.to_s.ljust(2)
      @raw_data += originator_city_and_state.to_s.ljust(35)
      @raw_data += originator_country_and_postal_code.to_s.ljust(35)
      # reserved
      @raw_data += "".ljust(14)
      @raw_data += entry_detail_sequence_number.to_s.rjust(7, "0")
      @raw_data
    end

    def validate
      errors << "Expected raw data length to be 94, was #{raw_data.length}" if raw_data.length != 94
      errors << "Expected record type code to be 7, got #{record_type_code}" unless record_type_code == "7"
      errors << "Expected addenda type code to be 12, got #{addenda_type_code}" unless addenda_type_code == "12"
      if originator_city_and_state.nil? || originator_city_and_state.strip.empty?
        errors << "Expected originator city and state to be set"
      end
      if originator_country_and_postal_code.nil? || originator_country_and_postal_code.strip.empty?
        errors << "Expected originator country and postal code to be set"
      end
      errors.empty?
    end

    def to_h
      {
        record_type_code: record_type_code,
        addenda_type_code: addenda_type_code,
        originator_city_and_state: originator_city_and_state,
        originator_country_and_postal_code: originator_country_and_postal_code,
        entry_detail_sequence_number: entry_detail_sequence_number
      }
    end
  end
end
