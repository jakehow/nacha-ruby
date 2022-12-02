# frozen_string_literal: true

#
# = nacha/iat_batch_header_record.rb
#
# Copyright (c) 2022 Jake Howerton
#
# Written and maintained by Jake Howerton <jake@howmeta.com>.

require_relative "record"

module Nacha
  class IatBatchHeaderRecord < Record
    attr_accessor :service_class_code, :iat_indicator, :foreign_exchange_indicator,
                  :foreign_exchange_reference_indicator, :foreign_exchange_reference,
                  :iso_destination_country_code, :originator_identification, :standard_entry_class_code,
                  :company_entry_description, :iso_originating_currency_code, :iso_destination_currency_code,
                  :effective_entry_date, :settlement_date, :originator_status_code, :go_or_originating_dfi_identification,
                  :batch_number

    def self.parse(input, skip_validation: false)
      new(
        raw_data: input,
        record_type_code: input[0, 1].strip,
        service_class_code: input[1, 3].strip,
        iat_indicator: input[4, 16].strip,
        foreign_exchange_indicator: input[20, 2].strip,
        foreign_exchange_reference_indicator: input[22, 1].strip,
        foreign_exchange_reference: input[23, 15].strip,
        iso_destination_country_code: input[38, 2].strip,
        originator_identification: input[40, 10].strip,
        standard_entry_class_code: input[50, 3].strip,
        company_entry_description: input[53, 10].strip,
        iso_originating_currency_code: input[63, 3].strip,
        iso_destination_currency_code: input[66, 3].strip,
        effective_entry_date: input[69, 6].strip,
        settlement_date: input[75, 3].strip,
        originator_status_code: input[78, 1].strip,
        go_or_originating_dfi_identification: input[79, 8].strip,
        batch_number: input[87, 7]&.strip
      )
    end

    def initialize(options = {}, _skip_validation = false)
      self.errors = []
      self.raw_data = options.fetch(:raw_data, nil)
      self.record_type_code = options.fetch(:record_type_code, "5")
      self.service_class_code = options.fetch(:service_class_code, nil)
      self.iat_indicator = options.fetch(:iat_indicator, nil)
      self.foreign_exchange_indicator = options.fetch(:foreign_exchange_indicator, nil)
      self.foreign_exchange_reference_indicator = options.fetch(:foreign_exchange_reference_indicator, nil)
      self.foreign_exchange_reference = options.fetch(:foreign_exchange_reference, nil)
      self.iso_destination_country_code = options.fetch(:iso_destination_country_code, nil)
      self.originator_identification = options.fetch(:originator_identification, nil)
      self.standard_entry_class_code = options.fetch(:standard_entry_class_code, nil)
      self.company_entry_description = options.fetch(:company_entry_description, nil)
      self.iso_originating_currency_code = options.fetch(:iso_originating_currency_code, nil)
      self.iso_destination_currency_code = options.fetch(:iso_destination_currency_code, nil)
      self.effective_entry_date = options.fetch(:effective_entry_date, nil)
      self.settlement_date = options.fetch(:settlement_date, nil)
      self.originator_status_code = options.fetch(:originator_status_code, nil)
      self.go_or_originating_dfi_identification = options.fetch(:go_or_originating_dfi_identification, nil)
      self.batch_number = options.fetch(:batch_number, nil)
    end

    def iat?
      true
    end

    def validate
      true
    end

    def generate
      @raw_data = record_type_code.to_s.ljust(1)
      @raw_data += service_class_code.to_s.ljust(3)
      @raw_data += iat_indicator.to_s.ljust(16)
      @raw_data += foreign_exchange_indicator.to_s.ljust(2)
      @raw_data += foreign_exchange_reference_indicator.to_s.ljust(1)
      @raw_data += foreign_exchange_reference.to_s.ljust(15)
      @raw_data += iso_destination_country_code.to_s.ljust(2)
      @raw_data += originator_identification.to_s.ljust(10)
      @raw_data += standard_entry_class_code.to_s.ljust(3)
      @raw_data += company_entry_description.to_s.ljust(10)
      @raw_data += iso_originating_currency_code.to_s.ljust(3)
      @raw_data += iso_destination_currency_code.to_s.ljust(3)
      @raw_data += effective_entry_date.to_s.ljust(6)
      @raw_data += settlement_date.to_s.ljust(3)
      @raw_data += originator_status_code.to_s.ljust(1)
      @raw_data += go_or_originating_dfi_identification.to_s.ljust(8)
      @raw_data += batch_number.to_s.rjust(7, "0")
      @raw_data
    end

    def to_h
      {
        record_type_code: record_type_code,
        service_class_code: service_class_code,
        iat_indicator: iat_indicator,
        foreign_exchange_indicator: foreign_exchange_indicator,
        foreign_exchange_reference_indicator: foreign_exchange_reference_indicator,
        foreign_exchange_reference: foreign_exchange_reference,
        iso_destination_country_code: iso_destination_country_code,
        originator_identification: originator_identification,
        standard_entry_class_code: standard_entry_class_code,
        company_entry_description: company_entry_description,
        iso_originating_currency_code: iso_originating_currency_code,
        iso_destination_currency_code: iso_destination_currency_code,
        effective_entry_date: effective_entry_date,
        settlement_date: settlement_date,
        originator_status_code: originator_status_code,
        go_or_originating_dfi_identification: go_or_originating_dfi_identification,
        batch_number: batch_number
      }
    end
  end
end
