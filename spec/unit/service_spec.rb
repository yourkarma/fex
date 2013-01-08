require "fex/service"

describe Fex::Service do

  let(:client) { mock :client }

  before do
    Savon.stub(:client => client)
  end

  it "wraps Savon" do
    service = Fex::Service.new(
      name: :address_validation,
      defaults: { :default => "value" },
      response: Struct.new(:new)
    )
    Savon.should_receive(:client).with(wsdl: instance_of(String), convert_request_keys_to: :camelcase, pretty_print_xml: true)
    client.should_receive(:call).with(:address_validation, {:message=>{:default=>"value", :the=>"message"}})
    service.call(:address_validation, the: "message")
  end

end
