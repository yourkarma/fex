module Fex

  MissingWSDL = Class.new(ArgumentError)

  class WSDL

    def path_for(service)
      path = File.expand_path("../../../wsdl/#{service}.wsdl", __FILE__)
      fail MissingWSDL, "Unknown service: #{path.inspect}" unless File.exist?(path)
      path
    end

  end
end
