module RedisHA
  module Conf
    def load_conf(conf)
      @sentinel_host, @sentinel_port = conf['sentinel']['host'], conf['sentinel']['port']
      @masters = conf['masters']
      @virtual_port =  conf['virtual']['port']
    end

    def report_conf
      log "initializing..."
      log "sentinel #{@sentinel_host}:#{@sentinel_port}"
      @masters.each do |master|
        log "we have master #{master['host']}:#{master['port']} in conf"
      end
      
      log "slave #{@slave_host}:#{@slave_port}"
      log "virtual port #{@virtual_port}"
    end
  end
end