require 'socket'

# Class send message and file
# @author Tomasz Tadrzak <italiano.tt@libero.it>
class Sender

    # Class constructor
    # @param port [Fixnum] the port on which send
	def initialize (udp, tcp)
        @udp_port = udp
        @tcp_port = tcp
    end

    # Method send message to address via tcp
    # @param mesg [String] and destination_address [string]
    def send_tcp mesg, destination_address
        tcp = TCPSocket.new(destination_address, @tcp_port)
        tcp.write(mesg)
        tcp.close
    end

    # Method send message to address via udp
    # @param mesg [String] and destination_address [String] 
    def send_udp mesg, destination_address
    	udp = UDPSocket.new
        udp.setsockopt(:IPPROTO_IP, :IP_MULTICAST_TTL, 1)
    	udp.send mesg, 0, destination_address, @udp_port 
    	udp.close
    end
end
