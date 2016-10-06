require 'spec_helper'
require "net/sender"

describe Rppc::Sender do
  subject { Rppc::Sender.new(5000,5001) }

  before :all do
    @msg = "test"
  end

  it "can istantiate" do
    subject != nil
  end

  it "send a message with two parameters via udp" do
  	subject.send_udp @msg, "127.0.0.1"
  end

  it "send a broadcast message via udp" do
    subject.send_udp_broadcast @msg    
  end

  it "send a messege with two parameters via tcp" do
    subject.respond_to? :send_tcp
  end

end
