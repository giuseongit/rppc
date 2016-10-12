require "spec_helper"
require "core/node"

class MockSender
    def initialize udp, tcp
    end

    def send_tcp mesg, destination_address
    end

    def send_udp mesg, destination_address
    end

    def send_udp_broadcast mesg
    end
end

class MockUi
end

describe Rppc::Node do
    before :all do
        @ui = MockUi.new
        @sender = MockSender.new(50000,50010)
        @node = Rppc::Node.new("127.0.0.1", @sender, @ui)
    end

    it "can instantiate" do
        @node != nil
    end

    it "can access ip"  do
        ip = @node.ip
        expect(ip).not_to be_nil
    end

    it "cannot modify ip" do
        expect{ @node.ip = "0.0.0.0" }.to raise_error
    end

    it "can read and write state" do
        expect{ @node.state = "test" }.not_to raise_error
        state = @node.state
        expect(state).not_to be_nil
    end

    it "can read and write username" do
        expect{ @node.username = "test" }.not_to raise_error
        state = @node.username
        expect(state).not_to be_nil
    end

    it "recognizes its own ip" do
        right = ["", "", "127.0.0.1"]
        wrong = ["", "", "0.0.0.0"]
        expect(@node.is_you?(right)).to be true
        expect(@node.is_you?(wrong)).to be false

    end
end
