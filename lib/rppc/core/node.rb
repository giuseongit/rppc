module Rppc

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
        # @param sender [Rppc::Sender] The sender object for this node
        def initialize(ip, sender)
            @ip = ip
            @sender = sender
        end

        # Tells if the provided addrinfo refers to this node
        #
        # @param addrinfo Array which contains infos about the sender
        # @return [Boolean] Returns true if the address info matches the node's ip
        def is_you?(addrinfo)
            addrinfo[2] == @ip
        end
    end
end