require 'observer'
require "socket"
require "ipaddr"

# Classh which handles incoming messages
# @author Giuseppe Pagano <giuseppe.pagano.p@gmail.com>
class Receiver
    include Observable
    # Multicast address to reach all connected devices inside the network
    MULTICAST_ADDR = "224.0.0.1"
    # Bind address
    BIND_ADDR = "0.0.0.0"
    
    # Class constructor
    # @param port [Fixnum] the port on which listen
    def initialize(port)
        @port = port
        @running = nil
    end
    
    # Tells if the receiver is running
    # @return [Boolean] the running state
    def is_running?
        @running != nil
    end
    
    # Register observer that handles received messages
    # obj MUST have the method receive(data, addrinfo)
    def register(obj)
        add_observer(obj,:receive)
    end
    
    # Starts the server
    def start_listen
        socket = UDPSocket.new
        membership = IPAddr.new(MULTICAST_ADDR).hton + IPAddr.new(BIND_ADDR).hton

        socket.setsockopt(:IPPROTO_IP, :IP_ADD_MEMBERSHIP, membership)
        begin
            socket.setsockopt(:SOL_SOCKET, :SO_REUSEPORT, 1)
        rescue SocketError  #For kernel which does not support SO_REUSEPORT
        end

        socket.bind(BIND_ADDR, @port)

        @running = Thread.new do
            loop do
                data,addrinfo = socket.recvfrom(1024)
                receive_packet(data, addrinfo)
            end
        end
    end
    
    # Stops the server
    def stop_listen
        Thread.kill(@running)
        @running = nil
    end

private

    def receive_packet(data, addrinfo)
        changed
        notify_observers(data, addrinfo)
    end     
end
