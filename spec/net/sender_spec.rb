require 'spec_helper'
require "net/sender"

describe Sender do
  subject {Sender.new(5000,5001)}

  before :all do
    @msg = "test"
  end

  it "can istantiate" do 
    subject != nil
  end

  it "send a messege with two parameters via udp" do
  	subject.send_udp @msg, "127.0.0.1"
  end

  it "send a messege with two parameters via tcp" do
    subject.respond_to? :send_tcp
  end 
	
end
