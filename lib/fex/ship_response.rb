require "base64"
require "bigdecimal"

module Fex
  class ShipResponse < Response

    def image
      @image ||= Base64.decode64(xpath("//Label/Parts/Image").inner_text)
    end

    def label_barcode
      @label_barcode ||= css("Barcodes StringBarcodes Value").inner_text
    end

    def total_net_charge
      @total_net_charge ||= BigDecimal.new(find_total_net_charge)
    end

    def tracking_number
      @tracking_number ||= css("TrackingNumber").inner_text
    end

    private

    def find_total_net_charge
      charge = css("TotalNetCharge Amount").first
      if charge
        charge.inner_text
      else
        '0.0'
      end
    end

  end
end
