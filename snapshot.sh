#! /bin/sh
#
#stop, get the mongo database and restart site-master


(cd /site-master; docker-compose down )
(cd /site-master; tar cfz mongodb.tgz mongodb )
#(cd site-loader; bash brunch-devo.sh )
#(cd site-server; docker build -t site-server:latest . )

nohup docker-compose up &
