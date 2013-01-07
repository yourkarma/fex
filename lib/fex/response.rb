require "delegate"

module Fex
  class Response < SimpleDelegator

    def initialize(*)
      super
      doc.remove_namespaces!
    end

    def severity
      xpath("//Notifications/Severity").inner_text
    end

    def code
      xpath("//Notifications/Code").inner_text
    end

    def message
      xpath("//Notifications/Message").inner_text
    end

  end
end
