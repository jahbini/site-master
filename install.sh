#! /bin/sh
#
#install site-master

mkdir mongodb -p
mkdir sites -p

scp -i /root/.ssh/site-master root@139.59.124.175:/site-master/mongodb.tgz .
tar xfz mongodb.tgz

git clone https://github.com/jahbini/site-loader.git
for i in stjohnsjim celarien bamboosnow
do
( cd sites ; git clone https://github.com/jahbini/$i )
( cd site-loader; mkdir domains -p; ln -s ../sites/$i domains/$i; ln -s ../public-$i ./public-$i)
done

(cd site-loader; npm install)
git clone https://github.com/jahbini/site-server.git

(cd site-server; docker build -t site-server:latest . )

docker-compose up -d

