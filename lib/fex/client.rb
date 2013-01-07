require "fex/service"

require "fex/services/rate"
require "fex/services/address_validation"

module Fex
  class Client

    CAMELCASE = lambda { |key| key.gsub(/\/(.?)/) { "::#{$1.upcase}" }.gsub(/(?:^|_)(.)/) { $1.upcase } }

    attr_reader :mode, :client_options, :key, :password, :account_number, :meter_number

    def initialize(options)
      @mode = options.fetch(:mode) { "test" }
      @client_options = options.fetch(:client) {{}}

      @credentials    = options.fetch(:credentials)
      @key            = @credentials.fetch(:key)
      @password       = @credentials.fetch(:password)
      @account_number = @credentials.fetch(:account_number)
      @meter_number   = @credentials.fetch(:meter_number)
    end

    def rate(options = {})
      service(Services::Rate.new, options)
    end

    def validate_address(options = {})
      service(Services::AddressValidation.new, options)
    end

    private

    def service(config, options)
      Service.new(
        name:       config.name,
        operation:  config.operation,
        client:     client_options_for(config, options),
        wsdl:       options[:wsdl],
        defaults:   authentication.merge(version: config.version).merge(config.defaults),
        response:   config.response
      )
    end

    def authentication
      {
        web_authentication_detail: {
          user_credential: { key: key, password: password }
        },
        client_detail: { account_number: account_number, meter_number: meter_number }
      }
    end

    def client_options_for(config, options)
      endpoint_options.merge(client_options).merge(config.client_options).merge(options[:client] || {})
    end

    def endpoint_options
      if mode.to_s == "production"
        { endpoint: "https://ws.fedex.com:443/web-services/rate" }
      else
        {}
      end
    end

  end
end
