require 'spec_helper'
require "net/receiver"

class MockObserver
    def receive(data, addrinfo)
    end
end

describe Receiver do
    subject { Receiver.new(5000,5001) }

    it "can istantiate" do
        subject != nil
    end
    
    it "can register observer" do
        subject.register(MockObserver.new)
    end

    it "can start and stop udp" do
        subject.send(:start_listen_udp)
        subject.send(:stop_listen_udp)
    end

    it "can start and stop tcp" do
        subject.send(:start_listen_tcp)
        subject.send(:stop_listen_tcp)
    end
    
    it "can start and stop entire server" do
        subject.start_listen
        subject.stop_listen
    end

    it "should raise an exception on double start" do
        subject.start_listen
        expect{subject.start_listen}.to raise_error
        subject.stop_listen
    end

    it "should raise an exception when calling stop on a non-running server" do
        expect{subject.stop_listen}.to raise_error
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

    it "supports receive_packet" do
        subject.send(:receive_packet, "data", nil)
    end
end
