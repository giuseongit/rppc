module Rppc
    require "net/receiver"
    require "net/sender"
    require "core/node"
    require 'socket'

    class CraftedMessageError < RuntimeError
    end

    class NodeNotFountError < RuntimeError
    end

    # Engine of the application
    # @author Giuseppe Pagano <giuseppe.pagano.p@gmail.com>
    class Engine
        UDP_PORT = 5000
        TCP_PORT = 5001

        class NodeData
            HELO = "hello"
        end

        def initialize(ui)
            @ui = ui
            @receiver = Receiver.new UDP_PORT, TCP_PORT

            @receiver.register(self)

            ip = Socket.ip_address_list.detect{|intf| intf.ipv4_private?}.ip_address
            sender = Sender.new UDP_PORT, TCP_PORT
            @myself = Node.new ip

            @known_nodes = []
        end

        def discover
            @myself.send_broadcast NodeData::HELO
        end

        def receive(data, addrinfo)
            found = search_node extract_ip addrinfo

            if not found
                if data == NodeData::HELO
                    new_node(addrinfo)
                else
                    raise CraftedMessageError, "Crafted message got from addrinfo=#{addrinfo}"
                end
            end
        end

        def new_node(addrinfo)
            ip = addrinfo[2]

            node = Node.new(ip)
            @known_nodes << node
        end

        def remove_node(ip)
            found = search_node ip
            if not found
                raise NodeNotFountError, "You have tried to remove a non-existing node"
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
