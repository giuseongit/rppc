require 'simplecov'
    SimpleCov.start do
end

$:.unshift File.expand_path("lib/rppc")

require "rppc"

RSpec.configure do |config|
    config.include Rppc
end
