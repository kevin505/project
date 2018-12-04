#!/bin/bash
set -e
curdir=$(cd $(dirname $0); pwd)

[ $UID -eq 0 ] || {
    echo "Must root run this script!!"
    exit 1
}

function install_docker(){
[ -f $gammadir/docker/docker-install.tar.gz ] || {
echo "docker-source not exist !! pls check $gammadir/docker/docker-isntall.tar.gz"
exit 1
}
cd $gammadir/docker
tar zxf docker-install.tar.gz  &> /dev/null
cd docker-install || {
echo "no dir $gammadir/docker/docker-install...."
exit 1
}
echo -e "\033[32mDocker Install Starting......\033[0m"
rpm -ivh *.rpm --force --nodeps &> /dev/null
grep max_map_count /etc/sysctl.conf || echo "vm.max_map_count=655360" >> /etc/sysctl.conf
sysctl -p 
systemctl start docker
systemctl enable docker
}

function install_compose(){
cd $gammadir/docker/docker-install && cp -f docker-compose /usr/local/bin/
chmod +x /usr/local/bin
}

function start_elk5(){
    [ -f $gammadir/docker/elastic5-docker.tar.gz ] || {
       echo "elk5_docker_file not exist"
       exit 1
    }
    test -d /teambition/docker || mkdir -p /teambition/docker
    tar zxf $gammadir/docker/elastic5-docker.tar.gz -C /teambition/docker
    cd /teambition/docker/elastic5-docker/image && docker load < elastic5-docker.tar
    if [ `docker images|grep elastic|wc -l` -ge 1 ]; then
          echo "elastic5-image import success!!"
    else
          echo "elastic5-image import failed!!"
    fi
    mkdir -p /teambition/db/elasticsearch6 && chmod 777 /teambition/db/elasticsearch6
    cd /teambition/docker/elastic5-docker/elasticsearch && docker-compose up -d
}

function start_rabbitmq(){
    [ -f $gammadir/docker/rabbitmq.tar.gz ] || {
       echo "rabbit not exist"
       exit 1
    }
    test -d /teambition/docker || mkdir -p /teambition/docker
    tar zxf $gammadir/docker/rabbitmq.tar.gz -C /teambition/docker
    cd /teambition/docker/rabbitmq/ && docker load < rabbitmq.tar
    if [ `docker images|grep rabbitmq|wc -l` -ge 1 ]; then
          echo "rabbitmq-image import success!!"
    else
          echo "rabbitmq-image import failed!!"
    fi
    mkdir -p /teambition/db/rabbitmq && chmod 777 /teambition/db/rabbitmq
    cd /teambition/docker/rabbitmq && docker-compose up -d 
}

function main(){
#install_docker
#install_compose
[ `rpm -qa|grep docker|wc -l` -lt 1  ] && {
cd $curdir
sh install-base.sh
}
start_elk5
start_rabbitmq
}
main
