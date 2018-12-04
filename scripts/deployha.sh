#!/bin/bash
# record the current directory
curdir=$(cd $(dirname $0); pwd)

# usage
if [ -z "$1" ] ; then
  echo "Please input the correct software to install?"
  echo
  echo "Usage: $0 software1 [software2] ... "
  echo
  echo "The avaiable softwares are: "
  echo "mongodb redis elasticsearch tbapp haproxy"
  exit 1
fi

# Check if user is root
if [ $(id -u) != "0" ]; then
  echo "Error: You must be root to run this script, please use root to run again!"
  exit 1
fi

function InitInstall()
{
   if [ ! -e /usr/bin/ansible ];then
      yum install -y ansible
      sed -i 's/#host_key_checking = False/host_key_checking = False/g' /etc/ansible/ansible.cfg
   fi
}

function InstallMongoDB()
{
  InitInstall
  bash $curdir/mongo/ansible-mongo.sh
}

function InstallRedis()
{
  InitInstall
  bash $curdir/redis/ansible-redis.sh
}

function InstallElasticsearch()
{
  InitInstall
  bash $curdir/elasticsearch/ansible-es.sh
}

function InstallTBapp()
{
  InitInstall
  bash $curdir/tbapp/ansible-tbapp.sh
}

function InstallHAproxy()
{
  InitInstall
  bash $curdir/haproxy/ansible-haproxy.sh
}

while [ $# -gt 0 ]
do
  case $(echo $1|tr 'A-Z' 'a-z') in
  mongo|mongodb)
    InstallMongoDB
    shift
    ;;
  es|elasticsearch)
    InstallElasticsearch
    shift
    ;;
  redis)
    InstallRedis
    shift
    ;;
  tbapp)
    InstallTBapp
    shift
    ;;
  haproxy)
    InstallHAproxy
    shift
    ;;
    *)
    echo "Please input the correct software to install!"
    echo
    echo "Usage: $0 software1 [software2] ... "
    echo
    echo "The avaiable softwares are: "
    echo "mongodb, redis, elasticsearch, tbapp, haproxy"
    exit 1
    ;;
  esac
done

