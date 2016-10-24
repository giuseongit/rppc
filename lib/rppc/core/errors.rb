module Rppc::Errors

    # ===================================
    # General, application-wide errors
    # ===================================

    # Error raised when a wrong object is given
    # @author Giuseppe Pagano <giuseppe.pagano.p@gmail.com>
    class WrongObjectError < RuntimeError
    end

    # ===================================
    # Engine errors
    # ===================================

    # Error raised when a malformed (crafted) message is received.
    # A message is malformed when it doesn't confrom the application protocol
    # @author Giuseppe Pagano <giuseppe.pagano.p@gmail.com>
    class CraftedMessageError < RuntimeError
    end

    # ===================================
    # Node errors
    # ===================================

    # Error raised when a node is not found on a search
    # @author Giuseppe Pagano <giuseppe.pagano.p@gmail.com>
    class NodeNotFoundError < RuntimeError
    end

    # Error raised when a node is already known
    # @author Giuseppe Pagano <giuseppe.pagano.p@gmail.com>
    class NodeAlreadyKnownError < RuntimeError
    end

    # ===================================
    # Server errors
    # ===================================

    # Error raised on a double server start
    # @author Giuseppe Pagano <giuseppe.pagano.p@gmail.com>
    class ServerAlreadyRunningError < RuntimeError
    end

    # Error raised on a double server stop
    # @author Giuseppe Pagano <giuseppe.pagano.p@gmail.com>
    class ServerNotRunningError < RuntimeError
    end

end