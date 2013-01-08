require "fex/service"
require "fex/response"

module Fex
  class ServiceFactory

    attr_reader :name, :mode, :client_options, :version, :defaults, :wsdl

    # credentials
    attr_reader :key, :password, :account_number, :meter_number

    def initialize(options)
      @name           = options.fetch(:name)
      @mode           = options.fetch(:mode)
      @version        = options.fetch(:version)  {{}}
      @client_options = options.fetch(:client)   {{}}
      @defaults       = options.fetch(:defaults) {{}}

      @credentials    = options.fetch(:credentials)
      @key            = @credentials.fetch(:key)
      @password       = @credentials.fetch(:password)
      @account_number = @credentials.fetch(:account_number)
      @meter_number   = @credentials.fetch(:meter_number)

      @wsdl = options[:wsdl]
    end

    def service
      Service.new(
        name:       name,
        client:     merged_client_options,
        wsdl:       wsdl,
        defaults:   merged_defaults,
        response:   Response
      )
    end

    def merged_defaults
      authentication.deep_merge(version: version).deep_merge(defaults)
    end

    def authentication
      {
        web_authentication_detail: {
          user_credential: { key: key, password: password }
        },
        client_detail: { account_number: account_number, meter_number: meter_number }
      }
    end

    def merged_client_options
      endpoint_options.deep_merge(client_options)
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
