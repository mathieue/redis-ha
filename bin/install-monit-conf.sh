#!/bin/bash
rvm wrapper $(rvm current) redis-ha  bundle
sudo ln -s /home/deploy/redis-ha/admin/monit/redis-ha /etc/monit/conf.d/redis-ha
sudo /opt/monit-5.5/bin/monit reload