#!/bin/bash
curdir=$(cd $(dirname $0); pwd)
[ -z $gammadir ] && {
  echo 'gammadir not set'
  exit 4
}
modifycfgdir=$gammadir/modifycfg

read -p "set domain:" domain
read -p "set striker domain:" striker
read -p "set tss domain:" tss
read -p "set mail address:" mail
read -p "set smtp:" smtp
read -p "set mail user:" user
read -p "set mail passwd:" passwd
ifconfig |grep -w "inet"|grep -v 0.0.0.0|awk '{print $2}'|grep -v 127.0.0.1 > $modifycfgdir/ipaddr
i=1
for line in `cat $modifycfgdir/ipaddr`
  do
    echo "$i: $line"
    let i++
done
read -p "input right interip: " interip    

cd $curdir
sh modify-base.sh $domain $striker $tss $mail $smtp  $user $passwd $interip
