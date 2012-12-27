require 'logger'
require 'syslog'

module RedisHA
  module Logging
    def log(msg)
      logger.info msg
    end

    def logger
      @logger ||= create_default_logger
    end

    def create_default_logger
      logger =  Syslog.open('redis-ha', Syslog::LOG_PID | Syslog::LOG_CONS)
      logger
    end
  end
end