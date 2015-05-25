require 'socket'

class Sender
	
	attr_accessor :port

	def initialize (port)
        @port = port
    end

    def send mesg, destination_address
    	udp = UDPSocket.new
        udp.setsockopt(:IPPROTO_IP, :IP_MULTICAST_TTL, 1)
    	udp.send mesg, 0, destination_address, @port #flag e' un bitwise se posto a 0 altrimenti e' un Socket::MSG_* constants
    	udp.close
    end
end
