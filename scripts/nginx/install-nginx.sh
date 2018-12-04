#!/bin/bash
set -e
curdir=$(cd $(dirname $0);pwd)
parentdir=$(dirname $curdir)
NGINX=nginx-1.13.2
PCRE=pcre-8.38
OPENSSL=openssl-1.0.2h
ZLIB=zlib-1.2.8

function InstallNginx()
{
  grep -w "^www" /etc/group > /dev/null || groupadd www
  grep -w "^www" /etc/passwd > /dev/null || useradd -s /sbin/nologin -g www www

  cd $gammadir/nginx
  test -f ${PCRE}.tar.gz || (echo "Error: ${PCRE}.tar.gz not found!! download now ......"; wget -c ftp://ftp.csx.cam.ac.uk/pub/software/programming/pcre/${PCRE}.tar.gz)
  tar zxf ${PCRE}.tar.gz
  test -f ${OPENSSL}.tar.gz || (echo "Error: ${OPENSSL}.tar.gz not found!! download now ......"; wget -c http://www.openssl.org/source/${OPENSSL}.tar.gz)
  tar zxf ${OPENSSL}.tar.gz
  test -f ${ZLIB}.tar.gz || (echo "Error: ${ZLIB}.tar.gz not found!! download now ......"; wget -c http://zlib.net/${ZLIB}.tar.gz)
  tar zxf ${ZLIB}.tar.gz
  test -f ${NGINX}.tar.gz || (echo "Error: ${NGINX}.tar.gz not found!! download now ......"; wget -c http://nginx.org/download/${NGINX}.tar.gz)
  tar zxf ${NGINX}.tar.gz
  cd ${NGINX}
  ./configure --user=www --group=www --prefix=/usr/local/${NGINX}  --with-openssl-opt=enable-tlsext --with-http_secure_link_module --with-http_ssl_module --with-http_v2_module --with-http_realip_module --with-http_gzip_static_module --with-http_sub_module --with-http_stub_status_module --with-pcre=../${PCRE} --with-openssl=../${OPENSSL} --with-zlib=../${ZLIB} --conf-path=/teambition/conf/nginx/nginx.conf --http-log-path=/teambition/log/nginx/access.log --error-log-path=/teambition/log/nginx/error.log --lock-path=/var/lock/nginx.lock --pid-path=/var/run/nginx/nginx.pid  --http-client-body-temp-path=/var/cache/nginx/client/ --http-proxy-temp-path=/var/cache/nginx/proxy/ --http-fastcgi-temp-path=/var/cache/nginx/fastcgi/ --http-scgi-temp-path=/var/cache/nginx/scgi/
  echo -e "\033[32mNginx Install Starting......\033[0m"
  pwd
  make
  make install
  if [ -L /usr/local/nginx ]; then
     rm -rf /usr/local/nginx
  fi
  ln -s /usr/local/${NGINX} /usr/local/nginx

  test -f /var/run/nginx/nginx.pid && (echo "Try to upgrade nginx..."; kill -USR2 `cat /var/run/nginx/nginx.pid`;/bin/usleep 100000; kill -QUIT `cat /var/run/nginx/nginx.pid.oldbin`; echo "Successfully upgraded!")

  mkdir -p /teambition/conf/nginx/conf.d
  mkdir -p /teambition/log/nginx && chown www:www /teambition/log/nginx
  mkdir -p /var/cache/nginx && chown www:www /var/cache/nginx
  mkdir -p /var/run/nginx && chown www:www /var/run/nginx

  cp -f $gammadir/logrotate/nginx /etc/logrotate.d/
  if [ -f /etc/redhat-release ] ; then
    cp -f $gammadir/init.d/nginx /etc/init.d/
    chmod +x /etc/init.d/nginx
    chkconfig --add nginx
    chkconfig --level 345 nginx on
    chkconfig --list nginx
  elif grep -i "ubuntu" /etc/issue ; then
    cp -f $gammadir/init.d/nginx.ubuntu /etc/init.d/nginx
    update-rc.d nginx defaults
  fi
  echo -e "\033[32mNginx Installed Successfully!!!\033[0m"
}

#InstallNginx
if [ -d /usr/local/nginx/sbin ]
then
echo "nginx already installed ... skip ..."
else
echo -e "\033[32mNginx Install Starting......\033[0m"
InstallNginx &>/dev/null 
echo -e "\033[32mNginx Installed Successfully!!!\033[0m"
fi 
