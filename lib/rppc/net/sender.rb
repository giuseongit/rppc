require 'socket'

# Class send message and file
# @author Tomasz Tadrzak <italiano.tt@libero.it>
class Sender

    # Class constructor
    # @param port [Fixnum] the port on which send
	def initialize (port)
        @port = port
    end

    # Method send message to address destination
    # @param mesg [String] and destination_address [String] 
    def send mesg, destination_address
    	udp = UDPSocket.new
        udp.setsockopt(:IPPROTO_IP, :IP_MULTICAST_TTL, 1)
    	udp.send mesg, 0, destination_address, @port 
    	udp.close
    end
end
