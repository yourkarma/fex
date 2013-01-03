require "savon"
require "fex/rate"
require "fex/address_validation"

module Fex
  class Client

    attr_reader :options

    def initialize(options)
      @options = options
    end

    def rate(attributes)
      Rate.new(client: self, attributes: attributes)
    end

    def validate_address(attributes)
      AddressValidation.new(client: self, attributes: attributes)
    end

    def request(wsdl, options = {})
      path = File.expand_path("../../../wsdl/#{wsdl}.wsdl", __FILE__)
      default_options = {
        wsdl: path,
        convert_request_keys_to: :camelcase,
        pretty_print_xml: true
      }
      client = Savon.client(default_options.merge(options))
    end

  end
end
