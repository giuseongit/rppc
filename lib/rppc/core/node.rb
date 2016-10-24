module Rppc::Core
    require "net/sender"
    require "core/engine"

    Net = Rppc::Net

    # Class which represent a node in the network
    # @author Giuseppe Pagano <giuseppe.pagano.p@gmail.com>
    #
    # @!attribute [r] ip
    #   @return [String] The ip of the node.
    # @!attribute state
    #   @return [String] State (or personal message) of the node.
    # @!attribute username
    #   @return [String] Username of the node.
    class Node
        attr_reader :ip
        attr_accessor :state
        attr_accessor :username

        # Class constructor
        #
        # @param ip [String] the ip of the node
        def initialize(ip)
            @ip = ip
            @sender = Net::Sender.new Engine::UDP_PORT, Engine::TCP_PORT
        end

        # Tells if the provided ip refers to this node
        #
        # @param ip [String] which contains the sender address
        # @return [Boolean] Returns true if the address info matches the node's ip
        def is_you?(ip)
            ip == @ip
        end

        # Sends a message to the node via tcp
        # 
        # @param message [String]  the message to send
        def send_tcp message
            @sender.send_tcp message, @ip
        end

        # Sends a message to the node via udp
        # 
        # @param message [String]  the message to send
        def send_udp message
            @sender.send_udp message, @ip
        end

        # Sends a broadcast message
        # 
        # @param message [String]  the message to send
        def send_broadcast message
            @sender.send_udp_broadcast message
        end

        def to_s
            "<#{@ip} with [#{@usermame}]>"
        end

        def to_str
            to_s
        end

    end
end