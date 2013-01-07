require 'ostruct'

module TestKeys

  def test_keys
    @test_keys ||= YAML.load_file(File.expand_path("../test_keys.yml", __FILE__))
  end

end
