#!/bin/bash
set -e
curdir=$(cd $(dirname $0); pwd)
parentdir=$(dirname $curdir)

function InstallElasticsearch()
{
  if [[ `getenforce` != "Disabled" ]];then
     setenforce 0
     sed -i 's/SELINUX=enforcing/SELINUX=disabled/' /etc/selinux/config
  fi
  systemctl stop firewalld && systemctl disable firewalld
  rm -f /etc/localtime
  ln -s /usr/share/zoneinfo/Asia/Shanghai /etc/localtime

  grep -w "^elasticsearch" /etc/group > /dev/null || groupadd elasticsearch
  grep -w "^elasticsearch" /etc/passwd > /dev/null || useradd -s /sbin/nologin -g elasticsearch elasticsearch
  cd $gammadir/elasticsearch
  tar zxf elasticsearch-custom.tar.gz -C /

  if [ -L /usr/local/elasticsearch ]; then
     rm -rf /usr/local/elasticsearch
  fi
  ln -s /usr/local/elasticsearch-1.6.2 /usr/local/elasticsearch

  test -d /teambition/db/elasticsearch || (mkdir -p /teambition/db/elasticsearch ; chown elasticsearch:elasticsearch /teambition/db/elasticsearch)
  test -d /teambition/log/elasticsearch || (mkdir -p /teambition/log/elasticsearch; chown elasticsearch:elasticsearch /teambition/log/elasticsearch)
  test -d /var/run/elasticsearch || (mkdir -p /var/run/elasticsearch; chown elasticsearch:elasticsearch /var/run/elasticsearch)

  if [ -f /etc/redhat-release ] ; then
    cp -f $gammadir/init.d/elasticsearch /etc/init.d/
    chmod +x /etc/init.d/elasticsearch
    chkconfig --add elasticsearch
    chkconfig --level 345 elasticsearch on
    chkconfig --list elasticsearch
  elif grep -i "ubuntu" /etc/issue ; then
    cp -f $gammadir/init.d/elasticsearch.ubuntu /etc/init.d/elasticsearch
    update-rc.d elasticsearch defaults
  fi
  echo -e "\033[32mElasticsearch Installed Successfully!!!\033[0m"
}

InstallElasticsearch
