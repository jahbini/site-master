#! /bin/sh
#
#install site-master

mkdir mongodb -p
mkdir sites -p
git clone https://github.com/jahbini/site-server.git
git clone https://github.com/jahbini/site-loader.git

scp -i /root/.ssh/site-master root@138.68.249.239:/site-master/images.tgz .
tar xfz images.tgz

scp -i /root/.ssh/site-master root@139.59.124.175:/site-master/mongodb.tgz .
tar xfz mongodb.tgz

for i in stjohnsjim celarien bamboosnow
do
mkdir /site-master/public-$i
( cd sites ; git clone https://github.com/jahbini/$i.git )
( cd site-loader; mkdir domains -p;
 ln -s /site-master/sites/$i domains/$i;
 ln -s /site-master/public-$i ./public-$i)
done
npm install -g brunch
(cd site-loader; npm install)
(cd site-loader; bash brunch-devo)

(cd site-server; docker build -t site-server:latest . )

. ./up.sh

