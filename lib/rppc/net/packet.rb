module Rppc::Net
    # Class which represent a packet for nodes.
    # This class has a private constructor because there are factory methods
    # in order to return pre-crafted protocol-matching objects.
    #
    # @author Giuseppe Pagano <giuseppe.pagano.p@gmail.com>
    class Packet
        # Creates and returns a helo message, used for
        # announcing that the user has joined the net
        #
        # @return [Rppc::Packet] an HELO packet
        def self.helo
            packet = new
            packet.payload = PacketData::HELO
            packet
        end

        # Parses the given data and builds the matching packet
        #
        # @return [Rppc::Packet] the parsed packet
        def self.parse(data)
            datas = data
            packet = new
            packet.payload = datas
            packet
        end

        # Tells if the given packet is a helo packet
        #
        # @return [Boolean] true if it is an HELO packet, false otherwise
        def is_helo?
            @type == PacketData::HELO and @payload == ""
        end

        def is_bye?
            @type == PacketData::BYE and @payload = ""
        end

        def is_name?
            @type == PacketData::USR_NAME
        end

        def is_state?
            @type == PacketData::USR_STATE
        end

        def is_msg?
            @type == PacketData::USR_MSG
        end

        def to_s
            "#{@type}|#|#{@payload}"
        end

        def to_str
            to_s
        end

        # Class wich has the fized data that identifies packet type
        class PacketData
            HELO = "helo"
            USR_NAME = "usr#name"
            USR_STATE = "usr#state"
            USR_MSG = "usr#msg"
            BYE = "bye"
        end

        attr_accessor :payload
        private_class_method :new
        
        def initialize(payload, type)
            @payload = payload
            @type = type
        end
    end
end