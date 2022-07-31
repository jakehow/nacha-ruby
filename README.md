# Nacha

This gem parses and generates Nacha ACH files according to the specification.

Goals:
* Support the complete Nacha specification as closely as possible
* Provide interfaces that map to known patterns for existing ruby developers
* Dedicated Class for every record type in the specification
* Provide access to raw data for manipulation where systems break from the standard
* Provide an extremely thorough test suite
* Provide a stable SemVer compatible release stream for long term production usage

Non-Goals:
* provide high level business operations that are not directly related to the parsing or generating of files
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

### Parsing a File

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake test` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and the created tag, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/jakehow/nacha-ruby. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [code of conduct](https://github.com/jakehow/nacha-ruby/blob/main/CODE_OF_CONDUCT.md).

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the Nacha project's codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/jakehow/nacha-ruby/blob/main/CODE_OF_CONDUCT.md).
