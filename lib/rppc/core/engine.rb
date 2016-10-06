module Rppc
  require "net/receiver"
  require "net/sender"

  # Engine of the application
  # @author Giuseppe Pagano <giuseppe.pagano.p@gmail.com>
  class Engine
    UDP_PORT = 5000
    TCP_PORT = 5001

    def initialize(ui)
      is_gui = false
      is_gui = is_gui || ui.respond_to?(:new_user)
      if !is_gui
        raise "NoUi"
      end
      @gui = ui
    end
  end
end
