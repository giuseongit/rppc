require "spec_helper"
require "core/engine"
require "net/sender"

class MockGui
    def initialize
        @elems = []
    end

    def received(node, data)
        @elems.push data
    end

    def count_received_element
        @elems.length
    end

    def get_last
        @elems.last
    end
end

class WrongGui
end

describe Rppc::Core::Engine do
    before do
        @mock = MockGui.new
        @engine = Rppc::Core::Engine.new(@mock)
    end

    it "can instantiate" do
        @engine != nil
    end

    it "raises error on a gui which has not the received method" do
        expect{Rppc::Core::Engine.new(WrongGui.new)}.to raise_error Rppc::Errors::WrongObjectError
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

    it "can send announce exit packet" do
        expect{ @engine.announce_exit() }.not_to raise_error
    end

    it "responds to node functions" do
        expect(@engine.respond_to?(:new_node)).to eq true
        expect(@engine.respond_to?(:get_nodes)).to eq true
        expect(@engine.respond_to?(:remove_node)).to eq true
    end

    it "receives first message and adds node" do
        helo = Rppc::Net::Packet::PacketData::HELO
        msg = "#{helo}|#|"
        addrinfo = ["", "", "127.0.0.1"]

        known = @engine.instance_variable_get(:@known_nodes)

        expect(known.length).to eq 0
        @engine.receive(msg, addrinfo)
        expect(known.length).to eq 1
    end

    it "raises an exception on double node add" do
        helo = Rppc::Net::Packet::PacketData::HELO
        msg = "#{helo}|#|"
        addrinfo = ["", "", "127.0.0.1"]
        @engine.receive(msg, addrinfo)

        expect{@engine.new_node(addrinfo)}.to raise_error Rppc::Errors::NodeAlreadyKnownError
    end

    it "raises error on crafted hello message"  do
        msg = "nope|#|"
        addrinfo = ["", "", "127.0.0.1"]
        expect{@engine.receive(msg, addrinfo)}.to raise_error Rppc::Errors::CraftedMessageError

        helo = Rppc::Net::Packet::PacketData::HELO
        msg = "#{helo}|#|crafted"
        expect{@engine.receive(msg, addrinfo)}.to raise_error Rppc::Errors::CraftedMessageError
    end

    it "sets correct username" do
        helo = Rppc::Net::Packet::PacketData::HELO
        usr_name = Rppc::Net::Packet::PacketData::USR_NAME

        username = "testUserName"

        msg = "#{helo}|#|"
        addrinfo = ["", "", "127.0.0.1"]
        @engine.receive(msg, addrinfo)

        known = @engine.instance_variable_get(:@known_nodes)

        expect(known.last.username).to be_nil
        msg = "#{usr_name}|#|#{username}"
        @engine.receive(msg, addrinfo)
        expect(known.last.username).not_to be_nil
        expect(known.last.username).to eq username
    end

    it "sets correct state" do
        helo = Rppc::Net::Packet::PacketData::HELO
        usr_state = Rppc::Net::Packet::PacketData::USR_STATE

        username = "testUserState"

        msg = "#{helo}|#|"
        addrinfo = ["", "", "127.0.0.1"]
        @engine.receive(msg, addrinfo)

        known = @engine.instance_variable_get(:@known_nodes)

        expect(known.last.state).to be_nil
        msg = "#{usr_state}|#|#{username}"
        @engine.receive(msg, addrinfo)
        expect(known.last.state).not_to be_nil
        expect(known.last.state).to eq username
    end

    it "removes node correctly" do
        ip = "127.0.0.1"
        helo = Rppc::Net::Packet::PacketData::HELO
        bye = Rppc::Net::Packet::PacketData::BYE
        msg = "#{helo}|#|"
        addrinfo = ["", "", ip]
        @engine.receive(msg, addrinfo)
        msg = "#{bye}|#|"

        known = @engine.instance_variable_get(:@known_nodes)

        expect(known.length).to eq 1
        expect{@engine.receive(msg, addrinfo)}.to_not raise_error
        expect(known.length).to eq 0
    end

    it "raises error when trying to remove a non-existing node" do
        expect{@engine.remove_node("127.0.0.1")}.to raise_error Rppc::Errors::NodeNotFoundError
    end

    it "gives known nodes" do
        expect(@engine.get_nodes).not_to be_nil
    end
end
