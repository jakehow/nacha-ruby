# frozen_string_literal: true

#
# = nacha.rb
#
# Copyright (c) 2022 Jake Howerton
#
# Written and maintained by Jake Howerton <jake@howmeta.com>.

require_relative "nacha/addenda_record"
require_relative "nacha/batch"
require_relative "nacha/batch_control_record"
require_relative "nacha/batch_header_record"
require_relative "nacha/entry_detail"
require_relative "nacha/entry_detail_record"
require_relative "nacha/file"
require_relative "nacha/file_control_record"
require_relative "nacha/file_header_record"
require_relative "nacha/first_iat_addenda_record"
require_relative "nacha/second_iat_addenda_record"
require_relative "nacha/third_iat_addenda_record"
require_relative "nacha/fourth_iat_addenda_record"
require_relative "nacha/fifth_iat_addenda_record"
require_relative "nacha/sixth_iat_addenda_record"
require_relative "nacha/seventh_iat_addenda_record"
require_relative "nacha/remittance_info_iat_addenda_record"
require_relative "nacha/foreign_correspondent_bank_iat_addenda_record"
require_relative "nacha/iat_entry_detail_record"
require_relative "nacha/iat_batch_header_record"
require_relative "nacha/version"
require_relative "nacha/returns/addenda_record"

module Nacha
  class Error < StandardError; end
  LINE_ENDING = "\n"

  STANDARD_ENTRY_CLASS_CODES = [
    "ACK",
    "ADV",
    "ARC", 
    "ATX", 
    "BOC", 
    "CCD",
    "CIE", 
    "COR", 
    "CTX", 
    "DNE", 
    "ENR", 
    "IAT", 
    "MTE", 
    "POP",
    "POS", 
    "PPD", 
    "RCK",
    "SHR",
    "TEL", 
    "TRC",
    "TRX", 
    "WEB",
    "XCK"
  ]

  SERVICE_CLASS_CODES = [
    "200",
    "220",
    "225",
  ]

  TRANSACTION_CODES = [
    "21",
    "22",
    "23",
    "26",
    "27",
    "28",
    "31",
    "32",
    "33",
    "36",
    "37",
    "38"
  ]

  NOC_CODES = [
    "C01",
    "C02",
    "C03",
    "C04",
    "C05",
    "C06",
    "C07"
  ]

  RETURN_CODES = [

  ]
end
