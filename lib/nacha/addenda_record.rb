# frozen_string_literal: true

#
# = nacha/addenda_record.rb
#
# Copyright (c) 2022 Jake Howerton
#
# Written and maintained by Jake Howerton <jake@howmeta.com>.

require_relative "record"

module Nacha
  class AddendaRecord < Record
    attr_accessor :addenda_type_code, :entry_detail_sequence_number

    def self.parse(input)
      record = new
      record.raw_data = input
      record
    end
  end
end
