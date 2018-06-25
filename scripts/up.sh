#! /bin/bash
#
sudo cp ~/site-master/default.conf /etc/nginx/conf.d/default.conf
sudo cp ~/site-master/nginx.conf /etc/nginx/
cd ~/site-master/site-loader
bash ./brunch-production.sh
cd ~/site-master 
sudo nginx -s reload
