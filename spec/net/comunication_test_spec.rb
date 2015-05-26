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

describe "Communication" do
    before :all do
        udp = 5000
        tcp = 5001
        @mock = MockReceiver.new
        @sender = Sender.new(udp, tcp)
        @receiver = Receiver.new(udp, tcp)
        @udp_msg = "test"
        @tcp_msg = "__test__"
        @count = 0
        @receiver.register(@mock)
    end

    it "entities can communicate via udp" do
        @count = @mock.count_received_element

        expect(@mock.count_received_element).to eq @count
        @receiver.start_listen

        expect(@mock.count_received_element).to eq @count

        @sender.send_udp(@udp_msg, "127.0.0.1")

        sleep 0.5
        
        expect(@mock.count_received_element).to eq(@count + 1)

        @receiver.stop_listen
    end
    
    it "recieves right message via udp" do
        expect(@mock.get_last).to eq @udp_msg
    end

    it "entities can communicate via tcp" do
        @count = @mock.count_received_element

        expect(@mock.count_received_element).to eq @count
        @receiver.start_listen

        expect(@mock.count_received_element).to eq @count

        @sender.send_tcp(@tcp_msg, "127.0.0.1")

        sleep 0.5
        
        expect(@mock.count_received_element).to eq(@count + 1)

        @receiver.stop_listen
    end

    it "receives right message via tcp" do
        expect(@mock.get_last).to eq @tcp_msg
    end
end
