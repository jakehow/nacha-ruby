# frozen_string_literal: true

require "test_helper"

describe "Nacha::File" do
  describe ".parse" do
    describe "valid file: single credit" do
      it "should take a valid ACH string" do
        value(::Nacha::File.parse("test")).must_be_instance_of(::Nacha::File)
      end

      it "should provide access to thre raw file data" do
        value(::Nacha::File.parse("test").raw_data).must_equal "test"
      end
    end

    describe "valid file: single IAT credit" do
      it "should have a single batch" do
        file_contents = fixture("iat_credit.ACH")
        value(::Nacha::File.parse(file_contents).batches.length).must_equal 1
      end
    end

    describe "valid file: mixed standard and IAT credits" do
      let(:file_contents) { fixture("iat_mixed_credits.ACH") }
      let(:subject) { ::Nacha::File.parse(file_contents) }

      it "should have 3 batches" do
        value(subject.batches.length).must_equal 3
      end

      it "should have a valid FileHeaderRecord" do
        value(subject.header.validate).must_equal true
      end

      it "should have no errors on the FileHeaderRecord" do
        subject.header.validate
        value(subject.header.errors).must_be_empty
      end

      it "should have a valid FileControlRecord" do
        value(subject.control.validate).must_equal true
      end
    end
  end
end
