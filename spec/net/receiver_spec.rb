require 'spec_helper'
require "net/receiver"

class MockObserver
    def receive(data, addrinfo)
    end
end

describe Receiver do
    subject { Receiver.new(58427) }

    it "can istantiate" do
        subject != nil
    end
    
    it "can register observer" do
        subject.register(MockObserver.new)
    end

    it "can start and stop" do
        subject.start_listen
        subject.stop_listen
    end

    it "has is_running? function" do
        expect(subject).to respond_to :is_running?
    end

    it "responds properly to is_running" do
        expect(subject.is_running?).to eq(false)
        subject.start_listen
        expect(subject.is_running?).to eq(true)
        subject.stop_listen
        expect(subject.is_running?).to eq(false)
    end
end
