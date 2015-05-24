require 'spec_helper'
require "net/receiver"

RSpec.describe "Receiver" do
    it "can istantiate" do
        @rec = Receiver.new("5000"
    end

    it "can receive data" do
        should @rec.receive_data("incoming data")
    end
end
