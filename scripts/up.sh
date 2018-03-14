#! /bin/bash
#
cp /site-master/host.conf /etc/nginx/conf.d/default.conf
cd /site-master/site-loader
bash ./brunch-production.sh
cd -
nginx -s reload