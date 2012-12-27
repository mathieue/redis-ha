#!/bin/bash
apt-get install haproxy -y
sed -i 's/ENABLED=0/ENABLED=1/g' /etc/default/haproxy
/etc/init.d/haproxy start