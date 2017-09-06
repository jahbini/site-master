#! /bin/sh
#
# convert javascript into coffeescript
mkdir ./javascript 2>0-problems
for i in *.js
do
  j=`basename $i .js`
  echo "---Converting $i to $j.coffee---" >>0-problems
  js2coffee $i >$j.coffee 2>>0-problems
  mv $i ./javascript/$i
done