require 'spec_helper'
require "net/sender"

describe Sender do
  
  before :each do 
  	@sender = Sender.new "5000"
  end

  it "can istantiate" do 
    @sender != nil
  end

  it "send a messege with two parameters" do
  		@sender.send "hi", "127.0.0.1"
  end	
	
end
