require "yaml"
require "fex/service_factory"

module Fex
  class Client

    attr_reader :globals

    def initialize(globals)
      @globals = globals
    end

    def service(name, locals = {})
      config = service_configuration[name]
      opts = globals.deep_merge(name: name).deep_merge(config).deep_merge(locals)
      ServiceFactory.new(opts).service
    end

    private

    def service_configuration
      @service_configuration ||= YAML.load_file(File.expand_path("../services.yml", __FILE__))
    end

  end
end
