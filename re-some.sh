#! /bin/sh
#
#stop, rebuild and restart site-master

sysctl vm.vfs_cache_pressure=10
sysctl vm.swappiness=10
for i in ${1:-celarien stjohnsjim bamboosnow}
do
export SITE=$i
cd /site-master
docker-compose stop $i
docker-compose rm -f $i
#(cd site-loader; tar cfz mongodb.tgz mongodb )
(cd site-loader; bash brunch-devo.sh $i )
(cd site-server; docker build -t site-server:latest . )

#(nohup docker-compose up nginx db >engines.log &)
docker-compose create $i;
docker-compose start $i
nohup docker-compose logs -f $i >$i.log &
sleep 20
done

