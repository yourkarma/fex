module Fex
  module Services
    class AddressValidation

      def name
        :address_validation
      end

      def operation
        :address_validation
      end

      def version
        { service_id: 'aval', major: 2, intermediate: 0, minor: 0 }
      end

      def client_options
        {}
      end

      def defaults
        {}
      end

      def response
      end

    end
  end
end
