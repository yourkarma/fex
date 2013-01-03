require 'fex/wsdl'

describe Fex::WSDL do

  subject(:wsdl) { Fex::WSDL.new }

  it "depends on the service" do
    wsdl.path_for("ship").should end_with "wsdl/ship.wsdl"
  end

  it "is a full path" do
    wsdl.path_for("ship").should start_with "/"
  end

  it "raises an exception if the wsdl is not found" do
    expect { wsdl.path_for("nothing") }.to raise_error(Fex::MissingWSDL)
  end

end
