# frozen_string_literal: true

#
# = nacha/entry_detail.rb
#
# Copyright (c) 2022 Jake Howerton
#
# Written and maintained by Jake Howerton <jake@howmeta.com>.

module Nacha
  class EntryDetail < Record
    attr_accessor :record, :addenda

    def initialize(options = {})
      self.record = options[:record]
      self.addenda = options[:addenda] || []
    end

    def is_return?
      record.transaction_code == "26" || record.transaction_code == "36"
    end

    def generate
      rows = []
      rows << record.generate
      addenda.each do |addendum|
        rows << addendum.generate
      end
      rows.join(LINE_ENDING)
    end

    def validate
      record.validate && addenda.all?(&:validate)
    end

    def errors
      record.errors + addenda.map(&:errors).flatten
    end

    def to_h
      record.to_h.merge(addenda: addenda.map(&:to_h))
    end
  end
end
