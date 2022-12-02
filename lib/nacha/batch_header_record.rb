# frozen_string_literal: true

#
# = nacha/batch_header_record.rb
#
# Copyright (c) 2022 Jake Howerton
#
# Written and maintained by Jake Howerton <jake@howmeta.com>.

require_relative "record"

module Nacha
  class BatchHeaderRecord < Record
    attr_accessor :service_class_code, :company_name, :company_discretionary_data, :company_identification,
                  :standard_entry_class_code, :company_entry_description, :company_descriptive_date,
                  :effective_entry_date, :settlement_date, :originator_status_code,
                  :originating_dfi_identification, :batch_number

    def self.parse(input, skip_validation: false)
      new(
        raw_data: input,
        record_type_code: input[0, 1]&.strip,
        service_class_code: input[1, 3]&.strip,
        company_name: input[4, 16]&.strip,
        company_discretionary_data: input[20, 20]&.strip,
        company_identification: input[40, 10]&.strip,
        standard_entry_class_code: input[50, 3]&.strip,
        company_entry_description: input[53, 10]&.strip,
        company_descriptive_date: input[63, 6]&.strip,
        effective_entry_date: input[69, 6]&.strip,
        settlement_date: input[75, 3]&.strip,
        originator_status_code: input[78, 1]&.strip,
        originating_dfi_identification: input[79, 8]&.strip,
        batch_number: input[87, 7]&.strip
      )
    end

    def initialize(options = {})
      self.errors = []
      self.raw_data = options.fetch(:raw_data, nil)
      self.record_type_code = options.fetch(:record_type_code, "5")
      self.service_class_code = options.fetch(:service_class_code, nil)
      self.company_name = options.fetch(:company_name, nil)
      self.company_discretionary_data = options.fetch(:company_discretionary_data, nil)
      self.company_identification = options.fetch(:company_identification, nil)
      self.standard_entry_class_code = options.fetch(:standard_entry_class_code, nil)
      self.company_entry_description = options.fetch(:company_entry_description, nil)
      self.company_descriptive_date = options.fetch(:company_descriptive_date, nil)
      self.effective_entry_date = options.fetch(:effective_entry_date, nil)
      self.settlement_date = options.fetch(:settlement_date, nil)
      self.originator_status_code = options.fetch(:originator_status_code, nil)
      self.originating_dfi_identification = options.fetch(:originating_dfi_identification, nil)
      self.batch_number = options.fetch(:batch_number, nil)
    end

    def iat?
      false
    end

    def validate
      @errors << "Expected raw data length to be 94, was #{raw_data.length}" if raw_data && raw_data.length != 94
      @errors << "Record Type Code must be 5" unless record_type_code == "5"
      unless Nacha::STANDARD_ENTRY_CLASS_CODES.include?(standard_entry_class_code)
        @errors << "Invalid Standard Entry Class Code"
      end
      @errors.empty?
    end

    def generate
      @raw_data = record_type_code.to_s.ljust(1)
      @raw_data += service_class_code.to_s.rjust(3)
      @raw_data += company_name.to_s.ljust(16)
      @raw_data += company_discretionary_data.to_s.ljust(20)
      @raw_data += company_identification.to_s.ljust(10)
      @raw_data += standard_entry_class_code.to_s.ljust(3)
      @raw_data += company_entry_description.to_s.ljust(10)
      @raw_data += company_descriptive_date.to_s.ljust(6)
      @raw_data += effective_entry_date.to_s.ljust(6)
      @raw_data += settlement_date.to_s.ljust(3)
      @raw_data += originator_status_code.to_s.ljust(1)
      @raw_data += originating_dfi_identification.to_s.ljust(8)
      @raw_data += batch_number.to_s.rjust(7, "0")
      @raw_data
    end

    def to_h
      {
        record_type_code: record_type_code,
        service_class_code: service_class_code,
        company_name: company_name,
        company_discretionary_data: company_discretionary_data,
        company_identification: company_identification,
        standard_entry_class_code: standard_entry_class_code,
        company_entry_description: company_entry_description,
        company_descriptive_date: company_descriptive_date,
        effective_entry_date: effective_entry_date,
        settlement_date: settlement_date,
        originator_status_code: originator_status_code,
        originating_dfi_identification: originating_dfi_identification,
        batch_number: batch_number
      }
    end
  end
end
