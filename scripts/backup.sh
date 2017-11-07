#! /bin/sh
#
#stop, get the mongo database and restart site-master
# this must be done on the live site just
# prior to hand-off to new live server


# create tar of static local images 
(cd /site-master; find public-* -name '*.gif' -or -name '*.svg' -or -name '*.png' -or -name '*.jpg' | xargs tar cfz images.tgz)
# make sure the DB engine is quiet
(cd /site-master; docker-compose down )
(cd /site-master; tar cfz mongodb.tgz mongodb )

# restart 
nohup docker-compose up &
