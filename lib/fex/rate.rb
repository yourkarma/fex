module Fex
  class Rate

    attr_reader :options

    def initialize(options)
      @options = options
    end

    def call
      client = @options[:client].request(
        "RateService_v13",
        env_namespace: :soapenv,
        namespace_identifier: "v13",
      )
      response = client.call(
        :get_rates,
        message: @options[:attributes],
      )
    end

  end
end
