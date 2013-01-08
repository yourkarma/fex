require 'fileutils'

module LoggerHelper

  def logger
    if ENV["VERBOSE"] == "true"
      Logger.new(STDERR)
    else
      file = "log/test.log"
      FileUtils.mkdir_p(File.dirname(file))
      Logger.new(file)
    end
  end

end
