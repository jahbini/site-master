#! /bin/bash
# bring up site-master after install or reboot
#
cd /site-master

sysctl vm.vfs_cache_pressure=10
sysctl vm.swappiness=10
#

docker-compose up -d
