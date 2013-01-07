module Credentials

  FILE = File.expand_path("../credentials.yml", __FILE__)

  def self.all
    YAML.load_file(FILE) if File.exist?(FILE)
  end

  module Keys
    def credentials
      @test_keys ||= Credentials.all[mode]
    end
  end

  module Test
    def mode
      "test"
    end
  end

  module Production
    def mode
      "production"
    end
  end

end
