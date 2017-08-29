#! /bin/sh
#
# convert javascript into coffeescript
mkdir ./javascript
for i in *.js
do
  j=`basename $i .js`
  js2coffee $i $j.coffee &2>$j.probs
  mv $i ./javascript/$i
done