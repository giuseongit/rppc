require 'observer'
require "socket"
require "ipaddr"

class Socket
     # ruby < v 2.0.0-p195
     SO_REUSEPORT = 15 unless const_defined? :SO_REUSEPORT
end

class Receiver
    include Observable
    MULTICAST_ADDR = "224.0.0.1"
    BIND_ADDR = "0.0.0.0"

    def initialize(port)
        @port = port
        @running = nil
    end
    
    def is_running?
        @running != nil
    end

    def register(obj)
        add_observer(obj,:receive)
    end

    def receive(data, addrinfo)
        changed
        notify_observers(data, addrinfo)
    end 
    
    def start_listen
        socket = UDPSocket.new
        membership = IPAddr.new(MULTICAST_ADDR).hton + IPAddr.new(BIND_ADDR).hton

        socket.setsockopt(:IPPROTO_IP, :IP_ADD_MEMBERSHIP, membership)
        socket.setsockopt(:SOL_SOCKET, :SO_REUSEPORT, 1)

        socket.bind(BIND_ADDR, @port)

        @running = Thread.new do
            loop do
                data,addrinfo = socket.recvfrom(1024)
                receive(data, addrinfo)
            end
        end
    end

    def stop_listen
        Thread.kill(@running)
        @running = nil
    end
end
