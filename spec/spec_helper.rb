require 'simplecov'
    SimpleCov.start do
end

#require 'coveralls'
#Coveralls.wear!

$:.unshift File.expand_path("lib/rppc")

require "rppc"

RSpec.configure do |config|
    config.include Rppc
end
