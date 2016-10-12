require "spec_helper"
require "core/engine"

class MockGui
    def initialize
        @elems = []
        @known_users = []
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

    def new_user(username, addrinfo)
        @known_users << [username, addrinfo]
    end

    def delete_user(username, addrinfo)
        @known_users.delete([username, addrinfo])
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
end
