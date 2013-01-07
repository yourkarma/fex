require "savon"
require "fex/wsdl"
require "fex/response"

module Fex
  class Service

    attr_reader :name, :operation, :defaults, :response

    def initialize(options)
      @name           = options.fetch(:name)
      @operation      = options.fetch(:operation) { @name }
      @client_options = options[:client] || {}
      @wsdl           = options[:wsdl]
      @defaults       = options[:defaults] || {}
      @response       = options[:response] || Response
    end

    def wsdl
      @wsdl || WSDL.new.path_for(name)
    end

    def client
      Savon.client(client_options)
    end

    def call(message, options = {})
      response.new client.call(operation, {message: defaults.merge(message)}.merge(options))
    end

    def client_options
      default_options = {
        wsdl: wsdl,
        convert_request_keys_to: :camelcase,
        pretty_print_xml: true
      }
      default_options.merge(@client_options)
    end

  end
end
