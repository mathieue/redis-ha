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
      get_master
      switch_to(@master)

      @redis.subscribe('+failover-end') do |on|
        on.message do |channel, message|
          log "failover end... a master  is down...."
          get_master
          switch_to(@master)
        end
      end
    end

    def get_master
      @master = @masters.find do |master|
        is_master(master)
      end
      log "master is #{@master}"
    end

    def is_master(master)
     begin
       redis = Redis.new(:host => master['host'], :port => master['port'])
       redis.set('redisha:canwrite', 'yes')
     rescue Exception => e
       false
     end
    end

    def switch_to(master)
      log "switching to master #{master['host']}:#{master['port']}"
      write_ha_conf(@virtual_port, master['host'], master['port'])
    end
  end
end