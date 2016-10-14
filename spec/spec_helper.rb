require 'simplecov'
require 'coveralls'

SimpleCov.formatter = Coveralls::SimpleCov::Formatter
SimpleCov.start do
    add_filter 'spec/'
end

$:.unshift File.expand_path("lib/rppc")

require "rppc"

RSpec.configure do |config|
    config.include Rppc
end
