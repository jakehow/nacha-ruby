# frozen_string_literal: true

require "test_helper"

describe "Nacha" do
  it "has a version number" do
    value(::Nacha::VERSION).wont_be_nil
  end

  it "does something useful" do
    value(false).must_equal 8
  end
end
