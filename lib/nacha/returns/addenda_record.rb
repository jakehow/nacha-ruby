# frozen_string_literal: true

#
# = nacha/fifth_iat_addenda_record.rb
#
# Copyright (c) 2022 Jake Howerton
#
# Written and maintained by Jake Howerton <jake@howmeta.com>.
module Nacha
  module Returns
    class AddendaRecord < Nacha::AddendaRecord
      attr_accessor :record_type_code, :addenda_type_code, :return_reason_code, :original_entry_trace_number,
                    :date_of_death, :original_rdfi_identification, :addenda_information, :trace_number

      def self.parse(input, skip_validation: true)
        record = new(
          raw_data: input,
          record_type_code: input[0, 1]&.strip,
          addenda_type_code: input[1, 2]&.strip,
          return_reason_code: input[3, 3]&.strip,
          original_entry_trace_number: input[6, 15]&.strip,
          date_of_death: input[21, 6]&.strip,
          original_rdfi_identification: input[27, 8]&.strip,
          addenda_information: input[35, 44]&.strip,
          trace_number: input[79, 15]&.strip
        )

        record.validate! unless skip_validation
        record
      end

      def initialize(options = {})
        self.errors = []
        self.raw_data = options[:raw_data]
        self.record_type_code = options[:record_type_code]
        self.addenda_type_code = options[:addenda_type_code]
        self.return_reason_code = options[:return_reason_code]
        self.original_entry_trace_number = options[:original_entry_trace_number]
        self.date_of_death = options[:date_of_death]
        self.original_rdfi_identification = options[:original_rdfi_identification]
        self.addenda_information = options[:addenda_information]
        self.trace_number = options[:trace_number]
      end

      def validate
        true
      end

      def generate
        @raw_data = record_type_code.to_s.ljust(1)
        @raw_data += addenda_type_code.to_s.ljust(2)
        @raw_data += return_reason_code.to_s.ljust(3)
        @raw_data += original_entry_trace_number.to_s.ljust(15)
        @raw_data += date_of_death.to_s.ljust(6)
        @raw_data += original_rdfi_identification.to_s.ljust(8)
        @raw_data += addenda_information.to_s.ljust(44)
        @raw_data += trace_number.to_s.rjust(15)
        @raw_data
      end
    end
  end
end
