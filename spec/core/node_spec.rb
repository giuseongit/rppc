require "spec_helper"
require "core/node"

describe Rppc::Node do
    before do
        @node = Rppc::Node.new("127.0.0.1")
        @message = "test"
    end

    it "can instantiate" do
        @node != nil
    end

    it "can access ip"  do
        ip = @node.ip
        expect(ip).not_to be_nil
    end

    it "cannot modify ip" do
        expect{ @node.ip = "0.0.0.0" }.to raise_error NoMethodError
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
        right = "127.0.0.1"
        wrong = "0.0.0.0"
        expect(@node.is_you?(right)).to be true
        expect(@node.is_you?(wrong)).to be false
    end

    it "sends tcp message" do
        expect{@node.send_tcp(@message)}.to raise_error Errno::ECONNREFUSED
    end

    it "sends udp message" do
        @node.send_udp(@message)
    end

    it "sends broadcast message" do
        @node.send_broadcast(@message)
    end
end
