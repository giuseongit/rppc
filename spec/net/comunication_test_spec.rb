require "spec_helper"
require "net/sender"
require "net/receiver"

class MockReceiver
    def initialize
        @elems = []
    end

    def receive(data, addrinfo)
        @elems.push data
    end

    def count_received_element
        @elems.length
    end

    def get_last
        @elems.last
    end
end

describe "Comunication" do
    before :all do
        port = 5000
        @mock = MockReceiver.new
        @sender = Sender.new(port)
        @receiver = Receiver.new(port)
        @msg = "test"
    end

    it "entities can comunicate" do
        count = @mock.count_received_element

        @receiver.register(@mock)

        expect(@mock.count_received_element).to eq(count)
        @receiver.start_listen

        expect(@mock.count_received_element).to eq(count)

        @sender.send(@msg, "127.0.0.1")

        sleep 0.5
        
        expect(@mock.count_received_element).to eq(count + 1)
    end
    
    it "recieves right test" do
        expect(@mock.get_last).to eq(@msg)
    end

    after :all do
        @receiver.stop_listen
    end
end
