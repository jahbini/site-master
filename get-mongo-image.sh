#! /bin/sh
#
#install site-master

mkdir mongodb -p
#do shutdown of mongo
docker-compose down

echo '88888888888888888888 -- getting mongodb and images from official server'
scp -i /root/.ssh/site-master root@bamboosnow.com:/site-master/images.tgz .
tar xfz images.tgz

scp -i /root/.ssh/site-master root@bamboosnow.com:/site-master/mongodb.tgz .
tar xfz mongodb.tgz
