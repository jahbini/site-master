#! /bin/sh
#
#stop, rebuild and restart site-master


(cd site-loader; docker-compose down )
#(cd site-loader; tar cfz mongodb.tgz mongodb )
(cd site-loader; bash brunch-development.sh )
(cd site-server; NODE_ENV=production docker build -t site-server:latest . )

nohup docker-compose up &
