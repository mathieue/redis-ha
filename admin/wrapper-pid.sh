#!/bin/bash
# which ruby
# rvm wrapper $(rvm current) redis-ha  bundle@
# which redis-ha_bundle
# /home/deploy/.rvm/bin/redis-ha_bundle

APP_HOME=/home/deploy/redis-ha
START="/home/deploy/.rvm/bin/redis-ha_bundle  exec ${APP_HOME}/bin/redis-ha"
 
 case $1 in
    start)
       cd $APP_HOME;
       exec 2>&1 $START 1>/dev/null &
       echo $! > "${APP_HOME}/tmp/redis-ha.pid";
       ;;
     stop)  
       kill $(cat "${APP_HOME}/tmp/redis-ha.pid") ;;
     *)  
       echo "usage: wrapper-pid.sh {start|stop}" ;;
 esac
 exit 0