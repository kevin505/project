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
echo "no dir $curdir/docker-install exist"
exit 1
}
echo -e "\033[32mDocker Install Starting......\033[0m"
rpm -ivh *.rpm --force --nodeps 
grep max_map_count /etc/sysctl.conf || echo "vm.max_map_count=655360" >> /etc/sysctl.conf
sysctl -p
echo  -e "\033[32mStart docker server...\033[0m"
systemctl start docker
systemctl enable docker
}

function install_compose(){
cd $gammadir/docker/docker-install && cp -f docker-compose /usr/local/bin/
[ -f /usr/local/bin/docker-compose ] || {
    exit 6 
}
chmod +x /usr/local/bin
}

install_docker
install_compose
