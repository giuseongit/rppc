module Rppc::Net
    require 'observer'
    require "socket"
    require "ipaddr"
    require "core/errors"

    # Class which handles incoming messages
    # @author Giuseppe Pagano <giuseppe.pagano.p@gmail.com>
    class Receiver
        include Observable
        MULTICAST_ADDR = "224.0.0.1" # Multicast address to reach all connected devices inside the network
        BIND_ADDR = "0.0.0.0" # Bind address

        # Class constructor
        #
        # @param udp [Fixnum] the port on which listen udp connections
        # @param tcp [Fixnum] the port on which listen tcp connections
        def initialize(udp, tcp)
            @udp_port = udp
            @tcp_port = tcp
            @running_udp = nil
            @running_tcp = nil
        end
        
        # Tells if the receiver is running
        #
        # @return [Boolean] the running state
        def is_running?
            @running_udp != nil && @running_tcp != nil
        end

        # Register observer that handles received messages
        #
        # @param obj MUST have the method receive(data, addrinfo)
        def register(obj)
            if obj.respond_to?(:receive)
                add_observer(obj,:receive)
            else
                raise Rppc::Errors::WrongObjectError, "Observer must respond to receive"
            end
        end

        # Starts the server
        def start_listen
            if @running_udp || @running_tcp
                raise Rppc::Errors::ServerAlreadyRunningError, "Server already running!"
            end

            start_listen_tcp
            start_listen_udp
        end

        # Stops the server
        def stop_listen
            unless @running_udp && @running_tcp
                raise Rppc::Errors::ServerNotRunningError, "Server not running!"
            end

            stop_listen_udp
            stop_listen_tcp
        end

        private
        # Starts the udp component
        def start_listen_udp
            @udp_server = socket = UDPSocket.new
            membership = IPAddr.new(MULTICAST_ADDR).hton + IPAddr.new(BIND_ADDR).hton

            socket.setsockopt(:IPPROTO_IP, :IP_ADD_MEMBERSHIP, membership)
            begin
                socket.setsockopt(:SOL_SOCKET, :SO_REUSEPORT, 1)
            rescue SocketError  #For kernel which does not support SO_REUSEPORT
            end

            socket.bind(BIND_ADDR, @udp_port)

            @running_udp = Thread.new do
                loop do
                    data,addrinfo = socket.recvfrom(1024)
                    receive_packet(data, addrinfo)
                end
            end
        end

        # Stops the udp component
        def stop_listen_udp
            Thread.kill(@running_udp)
            @running_udp = nil
            @udp_server.close
        end

        # Starts the tcp component
        def start_listen_tcp
            @tcp_server = TCPServer.new @tcp_port
            @running_tcp = Thread.new do
                loop do
                    Thread.start(@tcp_server.accept) do |client|
                        addrinfo = client.addr
                        data = client.gets("\0").chomp("\0")
                        receive_packet(data, addrinfo)
                    end
                end
            end
        end

        # Stops the udp component
        def stop_listen_tcp
            Thread.kill(@running_tcp)
            @running_tcp = nil
            @tcp_server.close
        end

        # Notifies the registered observers
        #
        # @param data [String] the received string
        # @param addrinfo [Addrinfo] the client's info
        def receive_packet(data, addrinfo)
            changed
            notify_observers(data, addrinfo)
        end
    end
end
