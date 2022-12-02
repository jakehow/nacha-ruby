# frozen_string_literal: true

#
# = nacha/file.rb
#
# Copyright (c) 2022 Jake Howerton
#
# Written and maintained by Jake Howerton <jake@howmeta.com>.

module Nacha
  class File
    attr_accessor :raw_data, :batches, :header, :control, :current_batch

    def self.parse(input)
      parsed_file = new
      parsed_file.raw_data = input

      parsed_file.parse_raw_data
      parsed_file
    end

    def initialize
      self.batches = []
    end

    def parse_raw_data
      raw_data.lines(chomp:true).each do |line|
        parse_line(line)
      end
    end

    def parse_line(line)
      case line[0]
      when "1"
        self.header = FileHeaderRecord.parse(line)
      when "5"
        self.current_batch = Batch.new
        standard_entry_class_code = line[50, 3]
        if standard_entry_class_code == "IAT"
          current_batch.header = IatBatchHeaderRecord.parse(line)
        else
          current_batch.header = BatchHeaderRecord.parse(line)
        end
      when "6"
        current_batch.current_entry = EntryDetail.new
        current_batch.entries << current_batch.current_entry
        if current_batch.iat?
          current_batch.current_entry.record = IatEntryDetailRecord.parse(line)
        else
          current_batch.current_entry.record = EntryDetailRecord.parse(line)
        end
      when "7"
        if current_batch.iat?
          addenda_type_code = line[1, 2]
          case addenda_type_code
          when "10"
            current_batch.current_entry.addenda << FirstIatAddendaRecord.parse(line)
          when "11"
            current_batch.current_entry.addenda << SecondIatAddendaRecord.parse(line)
          when "12"
            current_batch.current_entry.addenda << ThirdIatAddendaRecord.parse(line)
          when "13"
            current_batch.current_entry.addenda << FourthIatAddendaRecord.parse(line)
          when "14"
            current_batch.current_entry.addenda << FifthIatAddendaRecord.parse(line)
          when "15"
            current_batch.current_entry.addenda << SixthIatAddendaRecord.parse(line)
          when "16"
            current_batch.current_entry.addenda << SeventhIatAddendaRecord.parse(line)
          when "17"
            current_batch.current_entry.addenda << RemittanceInfoIatAddendaRecord.parse(line)
          when "18"
            current_batch.current_entry.addenda << ForeignCorrespondentBankIatAddendaRecord.parse(line)
          end
        else
          if current_batch.current_entry.is_return?
            current_batch.current_entry.addenda << Returns::AddendaRecord.parse(line)
          else
            current_batch.current_entry.addenda << AddendaRecord.parse(line)
          end
        end
      when "8"
        current_batch.control = BatchControlRecord.parse(line)
        batches << current_batch
        current_batch.current_entry = nil
        self.current_batch = nil
      when "9"
        self.control = FileControlRecord.parse(line) unless line.strip.chars.all? {|c| c == "9" }
      end
    end

    def generate
      raw_data = header.generate
      raw_data << LINE_ENDING
      batches.each do |batch|
        raw_data << batch.generate
        raw_data << LINE_ENDING
      end
      raw_data << control.generate
      raw_data << LINE_ENDING
      raw_data << padding(raw_data.lines.length)
      raw_data
    end

    def padding(length)
      over = length % header.blocking_factor
      if over > 0
        (header.blocking_factor - over).times.map { "9" * 94 }.join(LINE_ENDING)
      else
        ""
      end
    end

    def to_h
      {
        header: header.to_h,
        batches: batches.map(&:to_h), 
        control: control.to_h
      }
    end
  end
end
