require "base64"

module Fex
  class ShipResponse < Response

    def image
      @image ||= Base64.decode64(xpath("//Label/Parts/Image").inner_text)
    end

  end
end
