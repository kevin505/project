#!/bin/bash
set -e
#package dir
export gammadir=$(dirname "$PWD")
#scriptdir
curdir=$(cd "$(dirname "$0")"; pwd)

# usage
if [ -z "$1" ] ; then
  echo "Please input the correct software to install?"
  echo
  echo "Usage: $0 software1 [software2] ... "
  echo
  echo "The avaiable softwares are: "
  echo "init docker nginx mongodb node redis elasticsearch fonts  config license check"
  exit 1
fi

# Check if user is root
if [ $(id -u) != "0" ]; then
  echo "Error: You must be root to run this script, please use root to run again!"
  exit 2
fi

# init install, build env and other settings
function InitInstall()
{
  echo "Init Install ...... "
  [ $(yum repolist 2>/dev/null| awk '/repolist/{print$2}' | sed 's/,//') -eq 0 ] && {
   echo 'your yum has problem'
   exit 3
  }
  read -p "(Is this the first time run on the server? Please input y or n):" initinstall
  case "$initinstall" in
    y|Y|Yes|YES|yes|yES|yEs|YeS|yeS)
    if [ -f /etc/redhat-release ] ; then
      yum update -y &>/dev/null 
      yum install -y epel-release &>/dev/null
      cd $curdir && echo "---------------" > notyumpacge
      for i in  telnet vim gcc gcc-c++ autoconf make fftw wget patch pcre-devel openssl-devel zlib-devel bzip2-devel rsync libxml2-devel cairo-devel giflib-devel libjpeg-turbo-devel ImageMagick recode enca libreoffice-headless libreoffice-impress libreoffice-calc libreoffice-writer java-1.8.0-openjdk numactl tcl
      do
        echo "installing: "$i
        yum install -y $i &>/dev/null
        [ $? -ne 0 ] && echo 'your yum cannot install '$i >> notyumpacge
      done
    fi
    ;;
   n|N|No|NO|no|nO)
    echo "You have already installed the Init Build Environment, will go on ..."
    ;;
    *)
    echo "INPUT error, will stop the installation"
    exit 1
  esac
}

function InstallNginx()
{
bash $curdir/nginx/install-nginx.sh 
}

function InstallMongoDB()
{
bash $curdir/mongo/install-mongo.sh
cp -f $gammadir/conf/mongod.conf /teambition/conf/mongodb/mongod.conf
}

function InstallNode()
{
bash $curdir/node/install-node.sh
}

function InstallRedis()
{
bash $curdir/redis/install-redis.sh
cp -f $gammadir/conf/redis.conf /teambition/conf/redis/redis.conf
}

function InstallElasticsearch()
{
bash $curdir/elasticsearch/install-es.sh
}

function InstallDocker()
{
bash $curdir/docker/install-docker.sh
}

function InstallFonts()
{
bash $curdir/fonts/install-fonts.sh
}

function config()
{
bash $curdir/modify/modify-normal.sh
}
function confignova()
{
bash $curdir/modify/modify-nova.sh
}
function check()
{
bash $curdir/other/check.sh
}

function license()
{
bash $curdir/license/license.sh
}

installed=0
while [ $# -gt 0 ]
do
  case $(echo $1|tr 'A-Z' 'a-z') in
  init|INIT)
    [ $installed -eq 0 ] &&  installed=1
    InitInstall
    shift
    ;;
  mongo|mongodb)
    [ $installed -eq 0 ] &&  installed=1
    InstallMongoDB
    shift
    ;;
  nginx)
    [ $installed -eq 0 ] &&  installed=1
    InstallNginx
    shift
    ;;
  node|node.js)
    [ $installed -eq 0 ] &&  installed=1
    InstallNode
    shift
    ;;
  fonts)
    [ $installed -eq 0 ] &&  installed=1
    InstallFonts
    shift
    ;;
  es|elasticsearch)
    [ $installed -eq 0 ] &&  installed=1
    InstallElasticsearch
    shift
    ;;
  redis)
    [ $installed -eq 0 ] &&  installed=1
    InstallRedis
    shift
    ;;
  docker)
    InstallDocker
    shift
    ;;
  config)
    config
    shift
    ;;
  confignova)
    confignova
    shift
    ;;
  check)
    check
    shift
    ;;
  license)
    license
    shift
    ;;
    *)
    echo "Please input the correct software to install!"
    echo
    echo "Usage: $0 software1 [software2] ... "
    echo
    echo "The avaiable softwares are: "
    echo "init nginx, mongodb, node, redis, elasticsearch, fonts, docker, config, license,check"
    exit 1
    ;;
  esac
done

