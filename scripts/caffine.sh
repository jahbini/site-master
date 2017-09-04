#! /bin/sh
#
# convert javascript into coffeescript
mkdir ./javascript 2>0-problems
for i in *.js
do
  echo "---Converting $i to $j.coffee---" >>0-problems
  j=`basename $i .js`
  js2coffee $i >$j.coffee 2>>0-problems
  mv $i ./javascript/$i
done