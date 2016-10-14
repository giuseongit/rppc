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
    before :all do
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
end
