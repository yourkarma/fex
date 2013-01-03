module Fex
  class AddressValidation

    attr_reader :options

    def initialize(options)
      @options = options
    end

    def call
      client = @options[:client].request(
        "AddressValidationService_v2",
      )
      response = client.call(
        :address_validation,
        message: @options[:attributes],
      )
    end

  end
end
