#!/bin/bash
curdir=$(cd $(dirname $0);pwd)
[ -z $gammadir ] && {
  echo 'gammadir not set'
  exit 4
}
licensedir=$gammadir/license
cd $licensedir

tar zxvf license.tar.gz -C /root/
chmod +r /sys/class/dmi/id/product_uuid
/root/license/machineid
read -p "licenseid:" licenseid

cat >$licensedir/license.js <<EOF
/* global db, print */
var tb = db.getSiblingDB('soa')
db.licenses.insert({content:"$licenseid",created: new Date() }) 
EOF
mongo 127.0.0.1/soa $licensedir/license.js

#echo "db.licenses.insert({content:"$licenseid",created: new Date() })" |mongo soa

su - teambition -c "pm2 restart accounts"

