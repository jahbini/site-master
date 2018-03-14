#! /bin/sh
#
#install site-master
# prepares directory structure
# checks out latest versions from github
# installs stuff with npm
# does initial development build of site-loader and site-server

# mkdir mongodb -p
# 
npm install -g coffee-script@1.12
npm install -g brunch
npm install -g purify-css
# where we need to be
cd /site-master
mkdir sites -p
# git clone https://github.com/jahbini/site-server.git
git clone https://github.com/jahbini/site-loader.git

for i in stjohnsjim celarien bamboosnow
do
mkdir /site-master/public-$i
( cd sites ; git clone https://github.com/jahbini/$i.git )
( cd site-loader; mkdir domains -p;
 ln -sFt ./domains /site-master/sites/$i;
 ln -sFt . /site-master/public-$i )
done

(cd site-loader; npm install)

echo "install complete.  Ready for up.sh to initiate"
