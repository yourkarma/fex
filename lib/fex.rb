require "fex/version"
require "fex/client"

module Fex

  def self.client(options)
    Client.new(options)
  end

end
