#! /bin/sh
#
#stop, rebuild and restart site-master
# in PRODUCTION mode
# point live DNS to this host and the site is live
#
cd /site-master
swapon /swapfile
sysctl vm.vfs_cache_pressure=10
sysctl vm.swappiness=10

(cd site-loader; docker-compose down )
export NODE_ENV=production
#(cd site-loader; tar cfz mongodb.tgz mongodb )
(cd site-loader; bash brunch-production.sh )
#(cd site-server; docker build -t site-server:latest . )

(nohup docker-compose -f docker-compose-minimal.yml up nginx >engines.log &)