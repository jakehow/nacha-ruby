# frozen_string_literal: true

require "test_helper"

describe "Nacha::EntryDetail" do
    describe "#generate" do
        describe "valid entry: single IAT credit" do
            let(:subject) do 
                entry = EntryDetail.new
                entry.record = IatEntryDetailRecord.parse("6220210000210007             00000002341234567898                             1091000010091889")
                entry.addenda << FirstIatAddendaRecord.parse("710DEP000000000000000234                      DARON BERGSTROM                          0091889")
                entry.addenda << SecondIatAddendaRecord.parse("711ACME SE3211234                     8992 Chantal Flat                                0091889")
                entry.addenda << ThirdIatAddendaRecord.parse("712SAO PAULO*ZZ\\                      BR*04543000\\                                     0091889")
                entry.addenda << FourthIatAddendaRecord.parse("713WELLS FARGO BANK                   01091000019                         US           0091889")
                entry.addenda << FifthIatAddendaRecord.parse("714JPMorgan Chase Bank                01021000021                         US           0091889")
                entry.addenda << SixthIatAddendaRecord.parse("715GDX001212301234913 Barton Route                                                     0091889")
                entry.addenda << SeventhIatAddendaRecord.parse("716DHAKA*ZZ\\                          BD*A1A1A1\\                                       0091889")
                entry
            end

            it "should generate expected data" do
                value(subject.generate + "\n").must_equal <<~DATA
                6220210000210007             00000002341234567898                             1091000010091889
                710DEP000000000000000234                      DARON BERGSTROM                          0091889
                711ACME SE3211234                     8992 Chantal Flat                                0091889
                712SAO PAULO*ZZ\\                      BR*04543000\\                                     0091889
                713WELLS FARGO BANK                   01091000019                         US           0091889
                714JPMorgan Chase Bank                01021000021                         US           0091889
                715GDX001212301234913 Barton Route                                                     0091889
                716DHAKA*ZZ\\                          BD*A1A1A1\\                                       0091889
                DATA
            end

            it 'should be valid' do
                value(subject.validate).must_equal true
            end

            it 'should have no errors' do
                subject.validate
                value(subject.errors).must_be_empty
            end
        end
    end
end