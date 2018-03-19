#! /bin/bash
#
cp /site-master/default.conf /etc/nginx/conf.d/default.conf
cp /site-master/nginx.conf /etc/nginx/
cd /site-master/site-loader
bash ./brunch-production.sh
cd -
nginx -s reload