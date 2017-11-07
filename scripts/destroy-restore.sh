#! /bin/sh
#
#install site-master

docker-compose down
#do shutdown of mongo
mv mongodb mongodb.old
mkdir mongodb -p

echo '88888888888888888888 -- getting mongodb and images from official server'
scp -i /root/.ssh/site-master root@bamboosnow.com:/site-master/images.tgz .
tar xfz images.tgz

scp -i /root/.ssh/site-master root@bamboosnow.com:/site-master/mongodb.tgz .
tar xfz mongodb.tgz
