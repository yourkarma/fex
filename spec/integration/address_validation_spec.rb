require 'spec_helper'

describe Fex do

  example "Address Validation" do

    client = Fex.client(credentials: test_keys["production"], mode: "production")
    service = client.validate_address
    response = service.call(
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
    response.severity.should eq "SUCCESS"
  end

end
