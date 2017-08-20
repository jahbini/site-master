#! /bin/sh
#
#install site-master

mkdir mongodb -p
mkdir sites -p
git clone https://github.com/jahbini/site-server.git
git clone https://github.com/jahbini/site-loader.git

scp -i /root/.ssh/site-master root@bamboosnow.com:/site-master/images.tgz .
tar xfz images.tgz

scp -i /root/.ssh/site-master root@bamboosnow.com:/site-master/mongodb.tgz .
tar xfz mongodb.tgz

for i in stjohnsjim celarien bamboosnow
do
mkdir /site-master/public-$i
( cd sites ; git clone https://github.com/jahbini/$i.git )
( cd site-loader; mkdir domains -p;
 ln -sFt ./domains /site-master/sites/$i;
 ln -sFt . /site-master/public-$i )
done
npm install -g brunch
(cd site-loader; npm install)
(cd site-loader; bash brunch-devo.sh)

(cd site-server; docker build -t site-server:latest . )

. ./up.sh

