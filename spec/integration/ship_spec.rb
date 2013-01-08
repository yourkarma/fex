require 'spec_helper'
require 'base64'

describe "Ship Service", :test_environment do

  example "Process Shipment" do

    client = Fex.client(credentials: credentials, mode: mode, client: { logger: logger })
    service = client.service(:ship)

    service.should have(7).operations

    response = service.call(:process_shipment,
      requested_shipment: {
        ship_timestamp:  Time.now.utc.iso8601(2),
        dropoff_type:    "REGULAR_PICKUP",
        service_type:    "PRIORITY_OVERNIGHT",
        packaging_type:  "YOUR_PACKAGING",
        shipper: {
          contact: {
            contact_id:       "SY32030",
            person_name:      "Sunil Yadav",
            company_name:     "Syntel Inc",
            phone_number:     "9545871684",
            phone_extension:  "020",
            e_mail_address:   "sunil_yadav3@syntelinc.com"
          },
          address: {
            street_lines:            [ "SHIPPER ADDRESS LINE 1", "SHIPPER ADDRESS LINE 2" ],
            city:                    "COLORADO SPRINGS",
            state_or_province_code:  "CO",
            postal_code:             "80915",
            urbanization_code:       "CO",
            country_code:            "US",
            residential:             0
          }
        },
        recipient: {
          contact: {
            person_name:      "Receipient",
            company_name:     "Receiver Org",
            phone_number:     "9982145555",
            phone_extension:  "011",
            e_mail_address:   "receiver@yahoo.com"
          },
          address: {
            street_lines:            [ "RECIPIENT ADDRESS LINE 1", "RECIPIENT ADDRESS LINE 2" ],
            city:                    "DENVER",
            state_or_province_code:  "CO",
            postal_code:             "80204",
            urbanization_code:       "CO",
            country_code:            "US",
            residential:             0
          }
        },
        shipping_charges_payment: {
          payment_type: "SENDER",
          payor: {
            responsible_party: {
              account_number: credentials[:account_number],
              contact: ""
            }
          }
        },
        label_specification: {
          label_format_type: "COMMON2D",
          image_type: "PNG",
          label_stock_type: "PAPER_4X6"
        },
        rate_request_types: ["ACCOUNT"],
        package_count: 1,
        requested_package_line_items: [
          {
            sequence_number:      1,
            group_number:         1,
            group_package_count:  1,
            weight:     { units: "LB", value: "20.0" },
            dimensions: { length: 12, width: 12, height: 12, units: "IN" },
            physical_packaging: "BAG"
          }
        ]
      }
    )
    response.severity.should eq "SUCCESS"
    response.image.bytesize.should be_within(1024).of(10746)
  end

end
