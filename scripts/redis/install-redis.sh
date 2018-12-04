#!/bin/bash
set -e
curdir=$(cd $(dirname $0); pwd)
parentdir=$(dirname $curdir)
REDIS=redis-3.0.7

function InstallRedis()
{
  if [[ `getenforce` != "Disabled" ]];then
     setenforce 0
     sed -i 's/SELINUX=enforcing/SELINUX=disabled/' /etc/selinux/config
  fi
  systemctl stop firewalld && systemctl disable firewalld
  rm -f /etc/localtime
  ln -s /usr/share/zoneinfo/Asia/Shanghai /etc/localtime

  grep -w "^redis" /etc/group > /dev/null || groupadd redis
  grep -w "^redis" /etc/passwd > /dev/null || useradd -s /sbin/nologin -g redis redis

  cd $gammadir/redis
  test -f ${REDIS}.tar.gz || (echo "Error: ${REDIS} not found! download now......"; wget -c http://download.redis.io/releases/${REDIS}.tar.gz)
  tar zxf ${REDIS}.tar.gz
  cd ${REDIS}
  echo -e "\033[32mRedis Install Starting......\033[0m"
  make &> /dev/null
  make PREFIX=/usr/local/${REDIS} install
 
  if [ -L /usr/local/redis ]; then
     rm -rf /usr/local/redis
  fi
  ln -s /usr/local/${REDIS} /usr/local/redis
  ln -sf /usr/local/redis/bin/* /usr/local/bin/

  test -d /teambition/conf/redis || mkdir -p /teambition/conf/redis
  test -d /teambition/db/redis || (mkdir -p /teambition/db/redis ; chown redis:redis /teambition/db/redis)
  test -d /teambition/log/redis || (mkdir -p /teambition/log/redis ; chown redis:redis /teambition/log/redis)
  test -d /var/run/redis || (mkdir -p /var/run/redis ; chown redis:redis /var/run/redis)

  if [ -f /etc/redhat-release ] ; then
    cp -f $gammadir/init.d/redis /etc/init.d/
    chmod +x /etc/init.d/redis
    chkconfig --add redis
    chkconfig --level 345 redis on
    chkconfig --list redis
    cp -f $gammadir/init.d/disable-transparent-hugepages /etc/init.d/
    chmod +x /etc/init.d/disable-transparent-hugepages
    chkconfig --add disable-transparent-hugepages
    chkconfig --level 345 disable-transparent-hugepages on
    chkconfig --list disable-transparent-hugepages
  elif grep -i "ubuntu" /etc/issue ; then
    cp -f $gammadir/init.d/redis.ubuntu /etc/init.d/redis
    update-rc.d redis defaults
  fi
  
  echo -e "\033[32mRedis Installed Successfully!!!\033[0m"
}

InstallRedis
