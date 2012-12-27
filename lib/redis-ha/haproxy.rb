require 'erb'
require 'fileutils'

module RedisHA
  module HAProxy
    attr_accessor :virtual_port, :destination_host, :destination_port

    def get_binding 
      binding
    end

    def write_ha_conf(virtual_port, destination_host, destination_port)
      @virtual_port = virtual_port
      @destination_host = destination_host
      @destination_port = destination_port

      template = ERB.new File.new("templates/haproxy.cfg.erb").read
      content = template.result(get_binding)

      File.open('/etc/haproxy/haproxy.cfg.tmp', 'w') {|f| f.write(content) }
      check_conf_modified
    end

    def check_conf_modified
      unless FileUtils.compare_file('/etc/haproxy/haproxy.cfg.tmp', '/etc/haproxy/haproxy.cfg')
        log "conf files are not identical.."
        apply_new_conf
      else
        log "con files are identical"
      end
    end
   
    def apply_new_conf
      log "applying conf"
      FileUtils.copy_file('/etc/haproxy/haproxy.cfg.tmp', '/etc/haproxy/haproxy.cfg')
      restart
    end

    def restart
      out =  `/etc/init.d/haproxy reload`
      log out
    end

  end
end