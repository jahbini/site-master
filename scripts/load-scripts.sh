#! /bin/sh
#
for i in ~/site-master/scripts/*.sh
do
  j=`basename $i .sh`
  cp $i /usr/games/$j
  chmod 555 /usr/games/$j
done