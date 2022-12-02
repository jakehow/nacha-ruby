# frozen_string_literal: true

#
# = nacha/file_control_record.rb
#
# Copyright (c) 2022 Jake Howerton
#
# Written and maintained by Jake Howerton <jake@howmeta.com>.

module Nacha
    class Record
      attr_accessor :raw_data, :record_type_code, :errors

      def self.parse(input, skip_validation: true)
        raise Error.new("Parse must be implemented in subclass of Record")
      end

      def validate!
        raise ::Nacha::Error.new("#{self.class} Record Invalid") unless validate
      end
    end
end