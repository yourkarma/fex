require 'spec_helper'

describe "Pending Shipment Service", :test_environment do

  example "Create Pending Shipment Request" do

    client = Fex.client(credentials: credentials, mode: mode, client: { logger: logger })
    service = client.service(:ship)

    response = service.call(:create_pending_shipment,
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
            e_mail_address:   "you@localhost"
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
            e_mail_address:   "you@localhost"
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
          #only SENDER or THIRD_PARTY allowed
          payment_type: "SENDER",
          payor: {
            responsible_party: {
              account_number: credentials[:account_number],
              contact: ""
            }
          }
        },
        special_services_requested: {
          special_service_types: ["RETURN_SHIPMENT", "PENDING_SHIPMENT"],
          return_shipment_detail: {
            return_type: "PENDING",
            return_e_mail_detail: {
              merchant_phone_number: '123 123 123 123'
            }
          },
          pending_shipment_detail: {
            type: "EMAIL",
            expiration_date: Date.today,
            email_label_detail: {
              notification_e_mail_address: "you@localhost"
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
            weight:     { units: "LB", value: "20.0" },
            item_description:
              "Hotspot",
            customer_references: {
              customer_reference_type: "CUSTOMER_REFERENCE",
              value: "Hotspot"
            },
          }
        ],
      }
    )
    response.severity.should eq "SUCCESS"
    response.total_net_charge.should be > BigDecimal.new("67.65")
    response.email_label_url.should include("https://wwwtest.fedex.com/OnlineLabel/login.do?labelUserCdDesc=SyntelInc&labelPasswordDesc=")
  end

end
