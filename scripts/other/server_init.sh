#!/bin/bash

function EnableIptables() {
  /sbin/iptables -P INPUT ACCEPT
  /sbin/iptables -F
  /sbin/iptables -X
  /sbin/iptables -Z
  /sbin/iptables -A INPUT -i lo -j ACCEPT
  /sbin/iptables -A INPUT -p tcp --dport 22 -j ACCEPT
  /sbin/iptables -A INPUT -p tcp --dport 80 -j ACCEPT
  /sbin/iptables -A INPUT -p tcp --dport 443 -j ACCEPT
  /sbin/iptables -A INPUT -p tcp -s 101.231.114.44 -j ACCEPT
  /sbin/iptables -A INPUT -p icmp -m icmp --icmp-type 8 -j ACCEPT
  /sbin/iptables -A INPUT -m state --state ESTABLISHED,RELATED -j ACCEPT
  /sbin/iptables -P INPUT DROP
  if [ -f /etc/redhat-release ] ; then
      service iptables save
  elif grep -i "ubuntu" /etc/issue ; then
      /sbin/iptables-save > /etc/iptables.up.rules
      echo "pre-up iptables-restore < /etc/iptables.up.rules" >> /etc/network/interfaces
  fi
  echo -e "\033[40;31miptables enabled!!\033[0m"
}


function Sysctl() {
    cat >> /etc/sysctl.conf <<EOF
######################
net.ipv4.tcp_tw_reuse = 1
net.ipv4.tcp_tw_recycle = 0
net.ipv4.tcp_syncookies = 1
net.ipv4.tcp_syn_retries = 2
net.ipv4.tcp_max_syn_backlog = 262144
net.ipv4.tcp_max_tw_buckets = 5000
net.ipv4.tcp_synack_retries = 2
net.core.wmem_default = 8388608
net.core.rmem_default = 8388608
net.core.rmem_max = 16777216
net.core.wmem_max = 16777216
net.core.netdev_max_backlog = 262144
net.core.somaxconn = 262144
net.ipv4.tcp_rmem = 10240 87380 16777216
net.ipv4.tcp_wmem = 10240 87380 16777216

#net.ipv4.tcp_mem = 94500000 915000000 927000000
net.ipv4.tcp_max_orphans = 3276800
net.ipv4.tcp_fin_timeout = 30
net.ipv4.tcp_keepalive_time = 300
net.ipv4.ip_local_port_range = 2000    65000

net.ipv4.tcp_slow_start_after_idle = 0
vm.swappiness = 10
kernel.sem = 250 32000 100 128
net.ipv4.tcp_congestion_control = cubic
EOF
}

function Limit() {
    cat >> /etc/security/limits.conf <<EOF
* soft nofile 65535
* hard nofile 65535
* soft nproc 65535
* hard nproc 65535
EOF
}

