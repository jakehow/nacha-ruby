# frozen_string_literal: true

#
# = nacha/file_header_record.rb
#
# Copyright (c) 2022 Jake Howerton
#
# Written and maintained by Jake Howerton <jake@howmeta.com>.

require_relative "record"

module Nacha
  class FileHeaderRecord < Record
    attr_accessor :priority_code, :immediate_destination, :immediate_origin,
                  :file_creation_date, :file_creation_time, :file_id_modifier, :record_size, :blocking_factor,
                  :format_code, :immediate_destination_name, :immediate_origin_name, :reference_code, :errors

    def initialize(params = {})
      self.errors = []
      self.record_type_code = "1"
      self.priority_code = params.fetch(:priority_code, nil)
      self.immediate_destination = params.fetch(:immediate_destination, nil)
      self.immediate_origin = params.fetch(:immediate_origin, nil)
      self.file_creation_date = params.fetch(:file_creation_date, nil)
      self.file_creation_time = params.fetch(:file_creation_time, nil)
      self.file_id_modifier = params.fetch(:file_id_modifier, nil)
      self.record_size = params.fetch(:record_size, nil)
      self.blocking_factor = params.fetch(:blocking_factor, 10)
      self.format_code = params.fetch(:format_code, nil)
      self.immediate_destination_name = params.fetch(:immediate_destination_name, nil)
      self.immediate_origin_name = params.fetch(:immediate_origin_name, nil)
      self.reference_code = params.fetch(:reference_code, nil)
    end

    def self.parse(input, skip_validation: false)
      file_header = new
      file_header.raw_data = input
      file_header.record_type_code = input[0, 1].strip
      file_header.priority_code = input[1, 2].strip
      file_header.immediate_destination = input[3, 10].strip
      file_header.immediate_origin = input[13, 10].strip
      file_header.file_creation_date = input[23, 6].strip
      file_header.file_creation_time = input[29, 4].strip
      file_header.file_id_modifier = input[33, 1].strip
      file_header.record_size = input[34, 3].strip
      file_header.blocking_factor = input[37, 2].strip.to_i
      file_header.format_code = input[39, 1].strip
      file_header.immediate_destination_name = input[40, 23].strip
      file_header.immediate_origin_name = input[63, 23].strip
      file_header.reference_code = input[86, 8].strip
      file_header.validate unless skip_validation
      file_header
    end

    def validate
      errors << "Expected raw data length to be 94, was #{raw_data.length}" if raw_data.length != 94
      errors << "Expected blocking factor to be 10, was #{blocking_factor}" if blocking_factor != 10
      errors << "Expected format code to be 1, was #{format_code}" if format_code != "1"
      errors << "Expected record size to be 094, was #{record_size}" if record_size != "094"
      errors << "Expected creation time to be between 0000 and 2359, was #{file_creation_time}" unless file_creation_time.to_i.between?(
        0, 2359
      )
      errors.empty?
    end

    def generate
      @raw_data = record_type_code.to_s.ljust(1)
      @raw_data << priority_code.to_s.ljust(2)
      @raw_data << immediate_destination.to_s.rjust(10)
      @raw_data << immediate_origin.to_s.rjust(10)
      @raw_data << file_creation_date.to_s.ljust(6)
      @raw_data << file_creation_time.to_s.ljust(4)
      @raw_data << file_id_modifier.to_s.ljust(1)
      @raw_data << record_size.to_s.ljust(3)
      @raw_data << blocking_factor.to_s.ljust(2)
      @raw_data << format_code.to_s.ljust(1)
      @raw_data << immediate_destination_name.to_s.ljust(23)
      @raw_data << immediate_origin_name.to_s.ljust(23)
      @raw_data << reference_code.to_s.ljust(8)
      @raw_data
    end

    def to_h
      {
        record_type_code: record_type_code,
        priority_code: priority_code,
        immediate_destination: immediate_destination,
        immediate_origin: immediate_origin,
        file_creation_date: file_creation_date,
        file_creation_time: file_creation_time,
        file_id_modifier: file_id_modifier,
        record_size: record_size,
        blocking_factor: blocking_factor,
        format_code: format_code,
        immediate_destination_name: immediate_destination_name,
        immediate_origin_name: immediate_origin_name,
        reference_code: reference_code
      }
    end
  end
end
