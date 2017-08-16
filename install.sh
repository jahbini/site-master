#! /bin/sh
#
#install site-master

mkdir mongodb -p
mkdir sites -p

scp root@139.59.124.175:/site-master/mongodb.tgz .
tar xfz mongodb.tgz

git clone http://github.com/jahbini/site-master site-loader
for i in stjohnsjim celarien bamboosnow
do
( cd sites ; git clone http://github.com/jahbini/$i )
( cd site-loader; mkdir domains -p; ln -s ../sites/$i domains/$i; ln -s ../public-$i ./public-$i)
done

git clone http://github.com/jahbini/snowserv site-server

(cd site-server; docker build -t site-server:latest . )

docker-compose up -d

