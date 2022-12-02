# Nacha

This gem parses and generates standard Nacha ACH files according to the specification.

Current Status: Under Development

Goals:
* Support the complete Nacha specification as closely as possible
* Provide up to date support for changes to the specification while keeping support for historical variations
* Provide interfaces that map to familiar patterns for ruby developers
* Provide a serializable format for storage and communication in modern systems
* Provide access to raw data for manipulation where systems break from the standard
* Provide a fully documented code base
* Provide type signatures for all interfaces 
* Provide an extremely thorough test suite
* minimal/no runtime dependencies outside of the stdlib
* Provide a stable SemVer compatible release stream for long term production usage
* Serve as an example for best practices in open source development of a ruby gem

Non-Goals:
* provide high level business operations that are not directly related to the parsing or generation of files
* provide direct support for non-standard formats

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'nacha'
```

And then execute:

    $ bundle install

Or install it yourself as:

    $ gem install nacha

## Usage

### Generating a File

```ruby

file = ::Nacha::File.new

file.header = ::Nacha::FileHeaderRecord.new(
    priority_code: "01",
    immediate_destination: "021000021",
    immediate_origin: "321000123",
    file_creation_date: "220929",
    file_creation_time: "1648",
    file_id_modifier: "D",
    record_size: "094",
    blocking_factor: 10,
    format_code: "1",
    immediate_destination_name: "WELLS FARGO BANK",
    immediate_origin_name: "ACME CORPORATION"
)

file.batches << ::Nacha::Batch.new.tap do |batch|
    batch.header = ::Nacha::BatchHeaderRecord.new(
        service_class_code: "200",
        company_name: "ACME CORPORATION",
        company_discretionary_data: " ",
        company_identification: "1233211212",
        standard_entry_class_code: "WEB",
        company_entry_description: "ONLINEPYMT",
        company_descriptive_date: "220929",
        effective_entry_date: "220930",
        settlement_date: "273",
        originator_status_code: "1",
        originating_dfi_identification: "01200012",
        batch_number: 261
    )

    batch.entries << ::Nacha::EntryDetail.new.tap do |entry|
        entry.record = ::Nacha::EntryDetailRecord.new(
            addenda_record_indicator: 0,
            amount: 1_000_000,
            check_digit: "1",
            dfi_account_number: "1230000099",
            discretionary_data: "S",
            transaction_code: "27",
            individual_identification_number: "3213211234",
            individual_name: "DARON BERGSTROM",
            receiving_dfi_identification: "02100002",
            trace_number: "012345678912345"
        )

        batch.control = ::Nacha::BatchControlRecord.new(
            service_class_code: "200",
            entry_hash: "0002100002",
            entry_addenda_count: 1,
            total_debit_amount: 1_000_000,
            total_credit_amount: 0,
            company_identification: "1233211212",
            originating_dfi_identification: "01200012",
            batch_number: 261
        )
    end
end

file.control = ::Nacha::FileControlRecord.new(
    batch_count: 1,
    block_count: 1,
    entry_addenda_count: 1,
    entry_hash: "0002100002",
    total_debit_amount: 1_000_000,
    total_credit_amount: 0
)

puts file.generate
```

### Parsing a File

```ruby

file_contents = File.read(filename)

ach_file = ::Nacha::File.parse(file_contents)

ach_file.batches.each do |batch|
  # do your thing
end

```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake test` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and the created tag, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/jakehow/nacha-ruby. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [code of conduct](https://github.com/jakehow/nacha-ruby/blob/main/CODE_OF_CONDUCT.md).

## Resources

A Primer for Developers from Nacha: https://achdevguide.nacha.org/
BofA ACH Guide: https://files.nc.gov/ncosc/documents/eCommerce/bank_of_america_nacha_file_specs.pdf
The Official Network Rules: 

## Acknowledgments

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the Nacha ruby project's codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/jakehow/nacha-ruby/blob/main/CODE_OF_CONDUCT.md).
