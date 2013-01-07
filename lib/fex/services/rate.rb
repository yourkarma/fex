module Fex
  module Services
    class Rate

      def name
        :rate
      end

      def operation
        :get_rates
      end

      def version
        { service_id: 'crs', major: 13, intermediate: 0, minor: 0 }
      end

      def client_options
        {
          env_namespace: :soapenv,
          namespace_identifier: "v13"
        }
      end

      def defaults
        {}
      end

      def response
      end

    end
  end
end
