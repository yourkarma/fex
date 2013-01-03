require 'spec_helper'

describe Fex do

  example "Address Validation" do
    client = Fex.client(test_keys)
    av = client.validate_address(
      web_authentication_detail: {
        user_credential: {
          key: key,
          password: password
        }
      },
      client_detail: {
        account_number: account_number,
        meter_number: meter_number
      },
      transaction_detail: {
        customer_transaction_id: "WSVC_addressvalidation"
      },
      version: {
        service_id: 'aval',
        major: 2,
        intermediate: 0,
        minor: 0
      },
      request_timestamp: Time.now.utc.iso8601(2),
      options: {
        check_residential_status: 1,
      },
      addresses_to_validate: {
        address_id: "String",
        company_name: "String",
        address: {
          street_lines: "475 PARK AVE S FL 11",
          city: "NEWYORK",
          state_or_province_code: "NY",
          postal_code: "10016",
          urbanization_code: "String",
          residential: 1
        }
      }
    )
    av.call
  end

end
