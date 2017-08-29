#! /bin/sh
#
#stop, rebuild and restart site-master

sysctl vm.vfs_cache_pressure=10
sysctl vm.swappiness=10
(cd site-loader; docker-compose down )
#(cd site-loader; tar cfz mongodb.tgz mongodb )
(cd site-loader; bash brunch-devo.sh )
(cd site-server; docker build -t site-server:latest . )

(nohup docker-compose up nginx db >engines.log &)
sleep 10
for i in stjohnsjim bamboosnow celarien
do
(nohup docker-compose up $i >$i.log &)
sleep 20
done

