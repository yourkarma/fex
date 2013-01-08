# Fex

Small wrapper around Savon for using FedEx Web Services. It will expose you to
all the nitty gritty details from the FedEx API.

Disadvantages:

* The FedEx API is big and complex
* It's not easy to get started

Advantages:

* You can do everything that is allowed by the API.
* The code is really close to the documentation by FedEx.

It's up to you to decide which approach to take. If you don't do many special
things, a gem like `fedex`, might be a better alternative, because it hides
most of the complexity. If you find yourself needing a bit more control, you
can take this gem.

## Installation

Add this line to your application's Gemfile:

    gem 'fex'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install fex

## Usage

Create a client with your credentials:

``` ruby
client = Fex.client(

  # required:

  credentials: {
    key:             "xxx",
    password:        "xxx",
    account_number:  "xxx",
    meter_number:    "xxx",
  },
  mode:          "test", # or "production"

  # optional:
  client: {
    logger:        Rails.logger,
    log_level:     "info",
    log:           true,
    raise_errors:  true
  }
)
```

Create a service:

``` ruby
service = client.service(:ship)
```

Perform a request:

``` ruby
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
```

Read from the response:

``` ruby
response.success?
response.soap_fault?
response.severity
severity = response.xpath("//Notifications/Severity").inner_text
severity = response.css("Severity").inner_text
all_the_things = response.body
```

## Running gem specs

To run the specs on this project, you can create a file called
`spec/support/credentials.yml`, and fill it with your own test keys.

``` yaml
production:
  :key: "xxx"
  :password: "xxx"
  :account_number: "xxx"
  :meter_number: "xxx"

test:
  :key: "xxx"
  :password: "xxx"
  :account_number: "xxx"
  :meter_number: "xxx"
```

You can specify production and/or test. The production keys are used for the
address validation service, because that doesn't work for me on test.

To use the keys in an integration spec, add `:production_environment` or
`:test_environment` as group metadata keys, and the methods `credentials` and
`mode` are made available for you:

``` ruby
describe "FedEx rate service", :test_environment do

  it "should do something" do
    client = Fex.client(credentials: credentials, mode: mode)
    # etc ...
  end

end
```

If you don't specify keys, these specs will be skipped.

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
