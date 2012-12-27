module RedisHA
  module Conf
    def load_conf(conf)
      @sentinel_host, @sentinel_port = conf['sentinel']['host'], conf['sentinel']['port']
      @master_host, @master_port = conf['master']['host'], conf['master']['port']
      @slave_host, @slave_port = conf['slave']['host'], conf['slave']['port']
      @virtual_port =  conf['virtual']['port']
    end

    def report_conf
      log "initializing..."
      log "sentinel #{@sentinel_host}:#{@sentinel_port}"
      log "master #{@master_host}:#{@master_port}"
      log "slave #{@slave_host}:#{@slave_port}"
      log "virtual port #{@virtual_port}"
    end
  end
end