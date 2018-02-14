#! /bin/sh
#
#install site-master
# prepares directory structure
# checks out latest versions from github
# installs stuff with npm
# does initial development build of site-loader and site-server

mkdir mongodb -p
mkdir sites -p
git clone https://github.com/jahbini/site-server.git
git clone https://github.com/jahbini/site-loader.git

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

echo "install complete.  Ready for re-up to initiate"
