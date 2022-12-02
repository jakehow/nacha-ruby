# frozen_string_literal: true

require "simplecov"
SimpleCov.start do
  add_filter "/spec/"
end

require "debug"

$LOAD_PATH.unshift File.expand_path("../lib", __dir__)
require "nacha"

include ::Nacha

require "minitest/autorun"
require "minitest/reporters"
Minitest::Reporters.use! [Minitest::Reporters::DefaultReporter.new(color: true)]

def fixture(filename)
  File.read(File.join(File.dirname(__FILE__), "fixtures", filename))
end
