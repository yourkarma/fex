require 'spec_helper'

describe "Track Service", :test_environment do

  example "Track" do

    client = Fex.client(credentials: credentials, mode: mode, client: { logger: logger })

    service = client.service(:track)

    service.should have(4).operations

    response = service.call(
      :track,
      package_identifier: {
        value: "400030715008165",
        type: "TRACKING_NUMBER_OR_DOORTAG"
      },
      include_detailed_scans: true
    )
    response.severity.should eq "SUCCESS"
  end

end
