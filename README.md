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

Note: This gem is not complete. It contains the ship service, address
validation and rate service. The other services FedEx supplies are a somewhat
different. It shouldn't be too difficult to support them, but I haven't gotten
around to it.

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

  # optional:
  mode: "test", # or "production"

  # see Savon for more information about these
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

# see what operations are available:
service.operations # => [ :process_shipment, .... ]
```

Perform a request:

``` ruby
response = service.call(

  # the operation as mentioned earlier
  :process_shipment,

  # the attributes (after the Version tag)
  requested_shipment: {
    ship_timestamp:  Time.now.utc.iso8601(2),
    dropoff_type:    "REGULAR_PICKUP",
    service_type:    "PRIORITY_OVERNIGHT",
    packaging_type:  "YOUR_PACKAGING",
    # etc ...
  }
)
```

The response has everything Savon offers, plus some methods specific to FedEx.

``` ruby
# From Savon:
response.success?
response.soap_fault?
all_the_things = response.body
severity = response.xpath("//Notifications/Severity").inner_text
severity = response.css("Severity").inner_text

# From Fex:
response.severity
response.code
response.message
response.image # only for shipments with labels
```

For examples on how to use this gem, visit the `spec/integration` directory.

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
