require 'redis-ha/haproxy.rb'
require 'redis-ha/logging.rb'
require 'redis-ha/conf.rb'

require "redis"

module RedisHA
  class Runner
    include HAProxy
    include Logging
    include Conf
    
    def run(conf)
      load_conf(conf)
      report_conf

      @redis = Redis.new(:host => @sentinel_host, :port => @sentinel_port)
      try_connect_master
      
      @redis.subscribe('+failover-end') do |on|
        on.message do |channel, message|
          log "master is down...."
          switch_to_slave
        end
      end
    end

    def try_connect_master
      log "trying to connect to master..."
      begin
       redis = Redis.new(:host => @master_host, :port => @master_port)
       log redis.ping
       write_ha_conf(@virtual_port, @master_host, @master_port)
      rescue Redis::CannotConnectError => e
       log "impossible to connect to master"
       switch_to_slave
      end
    end

    def switch_to_slave
      log "switching from master #{@master_host}:#{@master_port} to slave #{@slave_host}:#{@slave_port}"
       write_ha_conf(@virtual_port, @slave_host, @slave_port)
    end
  end
end