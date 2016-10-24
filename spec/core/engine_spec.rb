require "spec_helper"
require "core/engine"
require "net/sender"

class MockGui
    def initialize
        @elems = []
    end

    def receive(data, node)
        @elems.push data
    end

    def count_received_element
        @elems.length
    end

    def get_last
        @elems.last
    end
end

describe Rppc::Engine do
    before do
        @mock = MockGui.new
        @engine = Rppc::Engine.new(@mock)
    end

    it "can instantiate" do
        @engine != nil
    end

    it "has a receiver instance" do
        recv = @engine.instance_variable_get(:@receiver)
        expect(recv).not_to be_nil
    end

    it "has a self node instance" do
        snd = @engine.instance_variable_get(:@myself)
        expect(snd).not_to be_nil
    end

    it "can send discovery packet" do
        expect{ @engine.discover() }.not_to raise_error
    end

    it "responds to node functions" do
        expect(@engine.respond_to?(:new_node)).to eq true
        expect(@engine.respond_to?(:get_nodes)).to eq true
        expect(@engine.respond_to?(:remove_node)).to eq true
    end

    it "receives first message and adds node" do
        msg = Rppc::Net::Packet::PacketData::HELO
        addrinfo = ["", "", "127.0.0.1"]
        expect(@engine.instance_variable_get(:@known_nodes).length).to eq 0
        @engine.receive(msg, addrinfo)
        expect(@engine.instance_variable_get(:@known_nodes).length).to eq 1
    end

    it "raises an exception on double node add" do
        msg = Rppc::Net::Packet::PacketData::HELO
        addrinfo = ["", "", "127.0.0.1"]
        @engine.receive(msg, addrinfo)

        expect{@engine.new_node(addrinfo)}.to raise_error Rppc::Errors::NodeAlreadyKnownError
    end

    it "raises error on crafted hello message"  do
        msg = "nope"
        addrinfo = ["", "", "127.0.0.1"]
        expect{@engine.receive(msg, addrinfo)}.to raise_error Rppc::Errors::CraftedMessageError
    end

    it "removes node correctly" do
        ip = "127.0.0.1"
        msg = Rppc::Net::Packet::PacketData::HELO
        addrinfo = ["", "", ip]
        @engine.receive(msg, addrinfo)

        expect(@engine.instance_variable_get(:@known_nodes).length).to eq 1
        expect{@engine.remove_node(ip)}.to_not raise_error
        expect(@engine.instance_variable_get(:@known_nodes).length).to eq 0
    end

    it "raises error when trying to remove a non-existing node" do
        expect{@engine.remove_node("127.0.0.1")}.to raise_error Rppc::Errors::NodeNotFoundError
    end

    it "gives known nodes" do
        expect(@engine.get_nodes).not_to be_nil
    end
end
