# frozen_string_literal: true

#
# = nacha/batch.rb
#
# Copyright (c) 2022 Jake Howerton
#
# Written and maintained by Jake Howerton <jake@howmeta.com>.

module Nacha
  class Batch
    attr_accessor :header, :current_entry, :control, :entries

    def initialize(header: nil, entries: [], control: nil)
      self.control = control
      self.entries = entries
      self.header = header
    end

    def iat?
      header && header.iat?
    end

    def generate
      rows = []
      rows << header.generate
      entries.each do |entry|
        rows << entry.generate
      end
      rows << control.generate
      rows.join(Nacha::LINE_ENDING)
    end

    def validate
      header.validate && entries.all?(&:validate) && control.validate
    end

    def errors
      {
        header: header.errors,
        entries: entries.map(&:errors),
        control: control.errors
      }
    end

    def to_h
      {
        header: header.to_h,
        entries: entries.map(&:to_h),
        control: control.to_h
      }
    end
  end
end
