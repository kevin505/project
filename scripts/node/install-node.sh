#!/bin/bash
set -e
curdir=$(cd $(dirname $0);pwd)
parentdir=$(dirname $curdir)

function InstallNode()
{
  grep -w "^teambition" /etc/group > /dev/null || groupadd teambition
  grep -w "^teambition8" /etc/group > /dev/null || groupadd teambition8
  grep -w "^teambition" /etc/passwd > /dev/null || useradd -s /bin/bash -g teambition teambition
  grep -w "^teambition8" /etc/passwd > /dev/null || useradd -s /bin/bash -g teambition8 teambition8 
  chmod -R 755 /home/teambition
  #userid=`grep -w "^teambition" /etc/passwd | awk -F':' '{print $3}'`
  #usermod -o -u $userid teambition8
  
  cd $gammadir/node
  tar -xf ffmpeg-release-64bit-static.tar.xz
  cp -f ffmpeg-3.3.2-64bit-static/ff* /usr/local/bin/
  cp -f ffmpeg-3.3.2-64bit-static/qt-faststart /usr/local/bin/
  cp -f $gammadir/logrotate/pm2 /etc/logrotate.d/

  if egrep -q "6\." /etc/redhat-release ; then
    tar xf alinode-v1.5.7-centos6.tar.gz -C /home/teambition/
  else
    tar xf alinode-v2.1.2-centos7.tar.gz -C /home/teambition/
    tar xf alinode-v3.9.0-centos7.tar.gz -C /home/teambition8/
  fi
  grep "TNVM_DIR" /home/teambition/.bashrc &> /dev/null || cat $gammadir/conf/bashrc >> /home/teambition/.bashrc
  grep "TNVM_DIR" /home/teambition8/.bashrc &> /dev/null || cat $gammadir/conf/bashrc8 >> /home/teambition8/.bashrc
  cp -f $gammadir/init.d/pm2-init.sh /etc/init.d/
  chmod +x /etc/init.d/pm2-init.sh
  chkconfig --add pm2-init.sh
  chkconfig --level 345 pm2-init.sh on
  chkconfig --list pm2-init.sh
  echo -e "\033[32mNode Installed Successfully!!!\033[0m"
}

function InstallRootNode(){
cp -rf /home/teambition/.tnvm /root/
[ `cat ~/.bashrc|grep 'tnvm.sh'|wc -l` -lt 1 ] && { 
echo 'export TNVM_DIR="/root/.tnvm"' >> ~/.bashrc
echo '[ -s "$TNVM_DIR/tnvm.sh" ] && . "$TNVM_DIR/tnvm.sh"' >> ~/.bashrc
source ~/.bashrc
}
node -v
}

InstallNode
InstallRootNode
