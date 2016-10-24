module Rppc::Core
    require "net/receiver"
    require "net/sender"
    require "net/packet"
    require "core/node"
    require "core/errors"
    require 'socket'

    # Engine of the application
    # @author Giuseppe Pagano <giuseppe.pagano.p@gmail.com>
    class Engine
        UDP_PORT = 5000
        TCP_PORT = 5001


        def initialize(ui)
            @ui = ui
            @receiver = Rppc::Net::Receiver.new UDP_PORT, TCP_PORT

            @receiver.register(self)

            ip = Socket.ip_address_list.detect{|intf| intf.ipv4_private?}.ip_address
            sender = Rppc::Net::Sender.new UDP_PORT, TCP_PORT
            @myself = Node.new ip

            @known_nodes = []
        end

        # Sends a broadcast message to discover other nodes in the network
        def discover
            @myself.send_broadcast Rppc::Net::Packet.helo
        end

        # Reveives some data. This method is called by the receiver of every known node
        #
        # @param data [String] the data to be parsed in a packet
        # @param addrinfo [Array] the address information
        def receive(data, addrinfo)
            found = search_node extract_ip addrinfo

            if not found
                packet = Rppc::Net::Packet.parse(data)
                if packet.is_helo?
                    new_node(addrinfo)
                else
                    raise Rppc::Errors::CraftedMessageError, "Crafted message got from addrinfo=#{addrinfo}"
                end
            end
        end

        def new_node(addrinfo)
            ip = extract_ip addrinfo

            found = search_node ip

            if found
                raise Rppc::Errors::NodeAlreadyKnownError, "Node #{found} already known"
            end

            node = Node.new(ip)
            @known_nodes << node
        end

        def remove_node(ip)
            found = search_node ip
            if not found
                raise Rppc::Errors::NodeNotFoundError, "You have tried to remove a non-existing node"
            end
            @known_nodes.delete found
        end

        def get_nodes
            @known_nodes
        end

        private
        def search_node(ip)
            found = nil
            @known_nodes.each do |node|
                if node.is_you? ip
                    found = node
                end
            end
            return found
        end

        def extract_ip(addrinfo)
            addrinfo[2]
        end
    end
end
