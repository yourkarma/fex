require "savon"
require "forwardable"
require "fex/wsdl"

module Fex

  # This is a wrapper around Savon, with more or less intelligent defaults.
  class Service
    extend Forwardable

    def_delegators :client, :operations

    # The name determines the name of the WSDL file located in the wsdl directory in the root of the gem.
    # The full path will be calculated by the +WSDL+ class.
    attr_reader :name

    # Defaults are any values that always exist on this service. Examples are
    # the credentials and the version.
    attr_reader :defaults

    # The response is the class that will handle building a response. The
    # default is the generic +Response+ class.
    attr_reader :response

    def initialize(options)
      @name           = options.fetch(:name)
      @client_options = options[:client] || {}
      @wsdl           = options[:wsdl]
      @defaults       = options[:defaults] || {}
      @response       = options.fetch(:response)
    end

    def wsdl
      @wsdl || WSDL.new.path_for(name)
    end

    def client
      Savon.client(client_options)
    end

    def call(operation, message, options = {})
      opts = {message: defaults.deep_merge(message)}.deep_merge(options)
      savon_response = client.call(operation, opts)
      response.new(savon_response)
    end

    def client_options
      default_options = {
        wsdl: wsdl,
        convert_request_keys_to: :camelcase,
        pretty_print_xml: true
      }
      default_options.deep_merge(@client_options)
    end

  end
end
