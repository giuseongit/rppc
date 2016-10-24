module Rppc::Net
	require 'socket'

	# Class send message and file
	# @author Tomasz Tadrzak <italiano.tt@libero.it>, Giuseppe Pagano <giuseppe.pagano.p@gmail.com>
	class Sender
    MULTICAST_ADDR = "224.0.0.1"

		# Class constructor
		# @param udp [Fixnum] the port on which send udp datagrams
		# @param tcp [Fixnum] the port on which send tcp packets
		def initialize udp, tcp
			@udp_port = udp
			@tcp_port = tcp
		end

		# Method send message to address via tcp
		# @param packet [Rppc::Packet] and destination_address [string]
		def send_tcp packet, destination_address
			tcp = TCPSocket.new(destination_address, @tcp_port)
			tcp.write(packet.to_str)
			tcp.close
		end

		# Method send message to address via udp
		# @param packet [Rppc::Packet] and destination_address [String]
		def send_udp packet, destination_address
			udp = UDPSocket.new
			udp.setsockopt(:IPPROTO_IP, :IP_MULTICAST_TTL, 1)
			udp.send packet.to_str, 0, destination_address, @udp_port
			udp.close
		end

		# Method send a broadcast message to address via udp
		# @param packet [Rppc::Packet]
		def send_udp_broadcast packet
			udp = UDPSocket.new
			udp.setsockopt(:IPPROTO_IP, :IP_MULTICAST_TTL, 1)
			udp.send packet.to_str, 0, MULTICAST_ADDR, @udp_port
			udp.close
		end
	end
end
