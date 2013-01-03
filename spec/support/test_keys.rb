require 'ostruct'

module TestKeys

  def key
    test_keys.key
  end

  def password
    test_keys.password
  end

  def account_number
    test_keys.account_number
  end

  def meter_number
    test_keys.meter_number
  end

  def test_keys
    @test_keys ||= OpenStruct.new(YAML.load_file(File.expand_path("../test_keys.yml", __FILE__)))
  end

end
