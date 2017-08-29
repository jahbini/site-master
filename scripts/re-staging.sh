#! /bin/sh
#
#stop, rebuild and restart site-master
swapon /swapfile
sysctl vm.vfs_cache_pressure=10
sysctl vm.swappiness=10

(cd site-loader; docker-compose down )
export NODE_ENV=production
#(cd site-loader; tar cfz mongodb.tgz mongodb )
(cd site-loader; bash brunch-production.sh )
(cd site-server; docker build -t site-server:latest . )

(nohup docker-compose -f docker-compose-staging.yml up nginx db >engines.log &)
sleep 10
for i in stjohnsjim bamboosnow celarien
do
(nohup docker-compose -f docker-compose-staging.yml up $i >$i.log &)
sleep 20
done