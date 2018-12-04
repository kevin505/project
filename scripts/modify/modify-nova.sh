#!/bin/bash
#set -e
curdir=$(cd $(dirname $0); pwd)
parentdir=$(dirname $curdir)
[ -z $gammadir ] && {
  echo 'gammadir not set'
  exit 4
}
novadir=$gammadir/nova
getConfig=$novadir/config/config.json

if [ -f $getConfig ]
then
    domain=`cat $getConfig|grep domain|awk -F "\"" {'print $4'}`
    striker=`cat $getConfig|grep striker|awk -F "\"" {'print $4'}`
    tss=`cat $getConfig|grep tss|awk -F "\"" {'print $4'}`
    mail=`cat $getConfig|grep mail|awk -F "\"" {'print $4'}`
    smtp=`cat $getConfig|grep smtp|awk -F "\"" {'print $4'}`
    user=`cat $getConfig|grep user|awk -F "\"" {'print $4'}`
    passwd=`cat $getConfig|grep password|awk -F "\"" {'print $4'}`
else
    echo " $getConfig not exit"
    exit 1
fi
interipdir=$novadir/config
interip=`cat $interipdir/remote.host`
cd $curdir
sh modify-base.sh $domain $striker $tss $mail $smtp  $user $passwd $interip
