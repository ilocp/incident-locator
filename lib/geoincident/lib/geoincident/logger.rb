module Geoincident
  class << self
    def logger
      return @logger if @logger

      if defined?(Rails)
        @logger = Rails.logger
      else
        require 'logger'
        @logger = Logger.new(STDOUT)
      end
    end
  end
end
