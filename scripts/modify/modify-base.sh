#!/bin/bash
domain=$1
striker=$2
tss=$3
mail=$4
smtp=$5
user=$6
passwd=$7
ipaddr=$8

curdir=$(cd $(dirname $0); pwd)
parentdir=$(dirname $curdir)
modifydir=$gammadir/modifycfg

#macaddr=`ifconfig eth0 |grep ether|awk '{print $2}'|sed s/://g`
if [ -f $gammadir/license/random ]
then
macaddr=`cat $gammadir/license/random`
else
cat /proc/sys/kernel/random/uuid|sed s/-//g|cut -b 1-10 > $gammadir/license/random
macaddr=`cat $gammadir/license/random`
fi
#ipaddr=`ifconfig |grep -w "inet"|grep -v 0.0.0.0|awk '{print $2}'|grep -v 127.0.0.1|head -n 1`
function make_dir()
{
test -d $modifydir/config || mkdir -p $modifydir/config
test -d /teambition/tss/default || mkdir -p /teambition/tss/default
chown -R teambition: /teambition/tss/
rm -rf $modifydir/config/*
hostnamectl --static set-hostname teambition
echo "127.0.0.1 teambition localhost" > /etc/hosts
}

function tar_app()
{
echo "==================tar APP=========================="
test -d /teambition/app || mkdir -p /teambition/app
tar zxf $gammadir/tbapp/private.tar.gz -C /teambition/app/
chown -R teambition: /teambition/app/
chown -R teambition: /home/teambition/.tnvm
chown -R teambition8: /teambition/app/corridor
chown -R teambition8: /teambition/app/search
chown -R teambition8: /teambition/app/tb-reporting-app
}

function tar_thoughts()
{
echo "==================tar Thoughts====================="
test -d /teambition/thoughts || mkdir -p /teambition/thoughts
tar zxf $gammadir/tbapp/thoughts.tar.gz -C /teambition/thoughts/
#copy service to system
cp -r /teambition/thoughts/auth/*.service /etc/systemd/system/
cp -r /teambition/thoughts/org/*.service /etc/systemd/system/
cp -r /teambition/thoughts/soa-core/dist/*.service /etc/systemd/system/
cp -r /teambition/thoughts/tcm/*.service /etc/systemd/system/
cp -r /teambition/thoughts/tcs/*.service /etc/systemd/system/
}

function start_initd_service()
{
echo "==================start elasticsearch================"
/etc/init.d/elasticsearch start
echo "==================start redis========================"
sed -i s/"bind 127.0.0.1"/"bind 127.0.0.1 $ipaddr"/g /teambition/conf/resis/redis.conf
/etc/init.d/redis start
echo "==================start mongo========================"
sed -i s/bind_ip=127.0.0.1/bind_ip=127.0.0.1,$ipaddr/g /teambition/conf/mongo/mongod.conf
/etc/init.d/mongod start
sleep 5
cfg="{_id:\"rs0\", members:[{_id:0, host:\"teambition:27017\"}]}"
echo "rs.initiate($cfg)"| mongo
}

function flush_core_scripts()
{
su - teambition -c "cd /teambition/app/teambition-core-cli/;npm link;core-cli mongodb init;core-cli import template"
mongo 127.0.0.1/teambition /teambition/app/core/scripts/migrate/2017*
mongo 127.0.0.1/teambition /teambition/app/core/scripts/migrate/2018-03-30-proTemplateType-index.js
mongo 127.0.0.1/teambition /teambition/app/core/scripts/migrate/2018*
}

function gen_coreid_secret()
{
cd /teambition/thoughts/auth/dist/
CONFL_FILE_PATH=./config.json  ./tools -data data_account.json && mv -f db_res.json db_account_res.json
coreid=`grep _id /teambition/thoughts/auth/dist/db_account_res.json |awk '{print $2}'|head -n 1|sed 's/"//g'|sed 's/,//g'`
accountsecret=`sed -n '26'p /teambition/thoughts/auth/dist/db_account_res.json |sed 's/"//g'|sed 's/\ //g'`
}

function make_config()
{
#account-my
bash $modifydir/modify-config/account-my-config.sh $domain $striker $mail $macaddr
#accounts
bash $modifydir/modify-config/accounts-config.sh   $domain $striker $coreid $accountsecret $macaddr
#account-admin
bash $modifydir/modify-config/admin-config.sh      $domain $striker $mail $macaddr
#apps
bash $modifydir/modify-config/apps-0000.sh         $domain $macaddr
bash $modifydir/modify-config/apps-cms.sh          $macaddr
bash $modifydir/modify-config/apps-config.sh       $domain $striker $coreid $accountsecret  $macaddr
bash $modifydir/modify-config/apps-index.sh        $domain $striker $macaddr
bash $modifydir/modify-config/apps-init_db.sh      $domain $macaddr
#captcha
bash $modifydir/modify-config/captcha-config.sh  $macaddr
#convert
bash $modifydir/modify-config/convert-config.sh    $tss $macaddr
#SOA-AUTH
bash $modifydir/modify-config/soa-auth.sh    $macaddr 
bash $modifydir/modify-config/soa-org.sh    $domain  $striker $mail $coreid $accountsecret $macaddr $ipaddr
#core
bash $modifydir/modify-config/core-config.sh       $domain  $striker $mail $coreid $accountsecret $macaddr
#develop
bash $modifydir/modify-config/develop-config.sh    $domain $striker $macaddr
#limbo  
bash $modifydir/modify-config/limbo-config.sh      $domain $macaddr
#magiclink
bash $modifydir/modify-config/magiclink-config.sh  $domain $macaddr
#mailguy
bash $modifydir/modify-config/mailguy-config-json5.sh  $domain $mail $user $passwd $smtp $macaddr
bash $modifydir/modify-config/mailguy-config-yml.sh    $domain $mail $user $passwd $smtp $macaddr
#nginx
bash $modifydir/modify-config/nginx-conf.sh       
bash $modifydir/modify-config/nginx-striker-conf.sh $striker $tss $macaddr
bash $modifydir/modify-config/nginx-web-conf.sh     $domain $macaddr
#org-admin
bash $modifydir/modify-config/org-admin-config.sh   $domain $striker $coreid $accountsecret $macaddr
bash $modifydir/modify-config/org-admin-web-config.sh   $domain
bash $modifydir/modify-config/org-admin-index.sh    $domain $striker $macaddr
#org-cms
bash $modifydir/modify-config/org-cms-config.sh	 $domain $striker $macaddr
bash $modifydir/modify-config/org-cms-index.sh	 $domain $striker $macaddr
#thoughts-org
bash $modifydir/modify-config/org-config.sh      	 $coreid $accountsecret $domain $macaddr
#search
bash $modifydir/modify-config/search-config.sh      $domain  $coreid $accountsecret $macaddr
#snapper
bash $modifydir/modify-config/snapper-config.sh $macaddr
#striker
bash $modifydir/modify-config/striker-config.sh     $striker $tss $macaddr
#Dashboard
bash $modifydir/modify-config/Dashboard-config.sh     $domain $macaddr
#system-notice
bash $modifydir/modify-config/system-notice-service-init_db.sh $domain $macaddr
bash $modifydir/modify-config/system-notice-service-sender.sh  $domain $macaddr
bash $modifydir/modify-config/system-notice-service-session.sh $domain $macaddr
#tb-reporting-app
bash $modifydir/modify-config/tb-reporting-app-appstore.sh     $domain $macaddr
bash $modifydir/modify-config/tb-reporting-app-init_db.sh      $domain $macaddr
bash $modifydir/modify-config/tb-reporting-appjs.sh            $domain $macaddr
bash $modifydir/modify-config/tb-reporting-app-tws_auth.sh     $coreid $accountsecret $macaddr
#tss
bash $modifydir/modify-config/tss-config.sh	$macaddr
#web
bash $modifydir/modify-config/web-config.sh     	 $domain $striker $macaddr
#wx-service
bash $modifydir/modify-config/wx-config.sh      	 $domain $macaddr
#docker
bash $modifydir/modify-config/tis-config.sh          $domain  $coreid $accountsecret $ipaddr
bash $modifydir/modify-config/commongroup-config.sh   $domain  $coreid $accountsecret $ipaddr
bash $modifydir/modify-config/meeting-config.sh      $domain  $coreid $accountsecret $ipaddr
bash $modifydir/modify-config/testhub-config.sh      $domain  $coreid $accountsecret $ipaddr
bash $modifydir/modify-config/notification-config.sh      $domain  $coreid $accountsecret $ipaddr $macaddr
#SOA service
bash $modifydir/modify-config/tcs-config.sh        $coreid $striker $macaddr
bash $modifydir/modify-config/soa-core-config.sh        $coreid $accountsecret $macaddr 


}

function add_hosts()
{
cat > $modifydir/config/hosts <<EOF
127.0.0.1     teambition   localhost
127.0.0.1 sales-demo
127.0.0.1     ${domain%:*}  ${striker%:*}   $tss
EOF
}

function copy_files()
{
echo "==================copy files======================="
#account-my
cp -f $modifydir/config/default.json5-account-my   /teambition/app/account-personal-center/config/default.json5
#accounts
cp -f $modifydir/config/default.json5-accounts   /teambition/app/accounts/config/default.json5
#account-admin
cp -f $modifydir/config/default.json5-admin   /teambition/app/account-admin/config/default.json5
#apps
cp -f $modifydir/config/apps-0000           /teambition/app/apps/scripts/migrate/0000-init-user-and-selfapp.js
cp -f $modifydir/config/cms.html-apps       /teambition/app/apps/dist/cms.html
cp -f $modifydir/config/default.json5-apps /teambition/app/apps/config/default.json5
cp -f $modifydir/config/index.html-apps    /teambition/app/apps/dist/index.html
cp -f $modifydir/config/apps-init_db.js   /teambition/app/apps/scripts/init_db.js
#captcha
cp -f $modifydir/config/default.json5-captcha   /teambition/app/captcha-service/config/default.json5
#convert
cp -f $modifydir/config/default.json5-convert   /teambition/app/convert-center/config/default.json5
#soa-auth
cp -f $modifydir/config/default.json5-soa-auth   /teambition/thoughts/auth/dist/config.json
#core
cp -f $modifydir/config/default.json5-core     /teambition/app/core/config/default.json5
#develop
cp -f $modifydir/config/default.json5-develop   /teambition/app/apps-developer/config/default.json5
#Dashboard
cp -f $modifydir/config/default.js-Dashboard  /teambition/app/Dashboard/config/default.js
#limbo
cp -f $modifydir/config/default.json5-limbo   /teambition/app/limbo-rpc/config/default.json5
#magiclink
cp -f $modifydir/config/default.json-magiclink   /teambition/app/magiclink/config/default.json
#mailguy
cp -f $modifydir/config/default.json5-mailguy   /teambition/app/mailguy/config/default.json5
cp -f $modifydir/config/default.yml-mailguy    /teambition/app/mailguy/config/default.yml
#nginx
cp -f $modifydir/config/nginx.conf    /teambition/conf/nginx/nginx.conf
cp -f $modifydir/config/striker.conf  /teambition/conf/nginx/conf.d/striker.conf
cp -f $modifydir/config/web.conf      /teambition/conf/nginx/conf.d/web.conf
#org-admin
cp -f $modifydir/config/default.json5-organization-admin   /teambition/app/organization-admin/config/default.json5
cp -f $modifydir/config/default.json5-organization-admin-web   /teambition/app/organization-admin-web/config/default.json5
cp -f $modifydir/config/index.html-admin                  /teambition/app/organization-admin/build/index.html
#org-cms
cp -f $modifydir/config/default.json5-organization-cms   /teambition/app/organization-cms/config/default.json5
cp -f $modifydir/config/index.html-cms                  /teambition/app/organization-cms/build/index.html
#thoughts-org
cp -f $modifydir/config/default.json5-soa-org                /teambition/thoughts/org/dist/config.json
#search
cp -f $modifydir/config/default.yml-search      /teambition/app/search/config/default.yml
#snapper
cp -f $modifydir/config/default.json5-snapper   /teambition/app/snapper-core/config/default.json5
#striker
cp -f $modifydir/config/default.json5-striker   /teambition/app/striker2/config/default.json5
#docker service
cp -f $modifydir/config/default.json5-tis   /teambition/app/tis/default.yml
cp -f $modifydir/config/default.json5-commongroup   /teambition/app/commongroup/default.yml
cp -f $modifydir/config/default.json5-meeting   /teambition/app/meeting/default.yml
cp -f $modifydir/config/default.json5-testhub   /teambition/app/testhub/default.yml
cp -f $modifydir/config/default.json5-notification   /teambition/app/notification/default.yml
#system-notice
cp -f $modifydir/config/system-notice-service-init_db.js  /teambition/app/system-notice-service/scripts/db/init.js
cp -f $modifydir/config/system-notice-service-sender.js  /teambition/app/system-notice-service/config/services/sender.js
cp -f $modifydir/config/system-notice-service-session.js /teambition/app/system-notice-service/config/session.js
#tb-reporting-app
cp -f $modifydir/config/tb-reporting-app-appstore.js   /teambition/app/tb-reporting-app/config/services/appstore.js
cp -f $modifydir/config/tb-reporting-app-init_db.js   /teambition/app/tb-reporting-app/scripts/db/init.js
cp -f $modifydir/config/tb-reporting-app-app.js       /teambition/app/tb-reporting-app/config/app.js
cp -f $modifydir/config/tb-reporting-app-tws_auth.js /teambition/app/tb-reporting-app/config/services/tws_auth.js
#tss
cp -f $modifydir/config/default.json5-tss           /teambition/app/storage/config/default.json5
#web
cp -f $modifydir/config/default.js-web             /teambition/app/web/config/default.js
#wx-service
cp -f $modifydir/config/default.json5-wx-service   /teambition/app/wx-service/config/default.json5
cp -f $modifydir/config/hosts   /etc/hosts
#soa service
cp -f $modifydir/config/config.json-tcs   /teambition/thoughts/tcs/dist/local.json
cp -f $modifydir/config/config.json-soa-core  /teambition/thoughts/soa-core/dist/config.json
}

function flush_init_js()
{
#apps
mongo 127.0.0.1/teambition /teambition/app/apps/scripts/init_db.js
mongo 127.0.0.1/teambition /teambition/app/apps/scripts/migrate/*
#system-notice
mongo 127.0.0.1/teambition /teambition/app/system-notice-service/scripts/db/init.js
#tb-reporting-app
mongo 127.0.0.1/teambition /teambition/app/tb-reporting-app/scripts/db/init.js
}

function start_systemd_service()
{
systemctl daemon-reload
systemctl start authhttp
systemctl start authrpc
systemctl start soa-core
systemctl start tcmi
systemctl start tcmo
systemctl start tcmd
systemctl start tcs
systemctl start org
systemctl start org-sync
systemctl enable authhttp
systemctl enable authrpc
systemctl enable soa-core
systemctl enable tcmi
systemctl enable tcmo
systemctl enable tcmd
systemctl enable tcs
systemctl enable org
systemctl enable org-sync
/etc/init.d/nginx start
cd /teambition/thoughts/org/dist;./orgapi es_init_es6 --config ./config.json --delete
}

function start_pm2()
{
echo "==================start pm2========================"
su - teambition -c "cd /teambition/app/account-admin/;pm2 start pm2/default.json"
su - teambition -c "cd /teambition/app/account-personal-center/;pm2 start pm2/default.json"
su - teambition -c "cd /teambition/app/accounts/;pm2 start pm2/default.json"
su - teambition8 -c "cd /teambition/app/apps/;pm2 start pm2/default.json"
su - teambition -c "cd /teambition/app/organization-admin-web/;pm2 start pm2/release.json"
su - teambition -c "cd /teambition/app/apps-developer/;pm2 start pm2/default.json"
su - teambition -c "cd /teambition/app/captcha-service/;pm2 start pm2/default.json"
su - teambition -c "cd /teambition/app/convert-center/;pm2 start pm2/default.json"
su - teambition8 -c "cd /teambition/app/core/;pm2 start pm2/default.json"
su - teambition -c "cd /teambition/app/limbo-rpc/;pm2 start pm2/default.json"
su - teambition -c "cd /teambition/app/magiclink/;pm2 start pm2/default.json"
su - teambition -c "cd /teambition/app/mailguy/;pm2 start pm2/default.json"
su - teambition -c "cd /teambition/app/organization-admin/;pm2 start pm2/default.json"
su - teambition -c "cd /teambition/app/organization-cms/;pm2 start pm2/default.json"
su - teambition -c "cd /teambition/app/snapper-core/;pm2 start pm2/default.json"
su - teambition -c "cd /teambition/app/striker2/;pm2 start pm2/default.json"
su - teambition -c "cd /teambition/app/system-notice-service/;pm2 start pm2/default.json"
su - teambition -c "cd /teambition/app/tapestry-server/;pm2 start pm2/default.json"
su - teambition -c "cd /teambition/app/web/;pm2 start pm2/default.json"
su - teambition -c "cd /teambition/app/storage/;pm2 start pm2/default.json"
#su - teambition -c "cd /teambition/app/wx-service/;pm2 start pm2/default.json"
su - teambition8 -c "cd /teambition/app/corridor/;pm2 start pm2/default.json"
su - teambition8 -c "cd /teambition/app/search/;pm2 start pm2/default.json"
su - teambition8 -c "cd /teambition/app/search/;pm2 start pm2/oplog.json"
su - teambition8 -c "cd /teambition/app/tb-reporting-app/;pm2 start pm2/default.json"
su - teambition8 -c "cd /teambition/app/Dashboard/;pm2 start pm2/default.json"
}


function main()
{
make_dir
echo "Taring app ..."
tar_app &>/dev/null
echo "Taring thoughts ..."
tar_thoughts &>/dev/null
echo "Initing server ..."
start_initd_service &>/dev/null

echo "Importing & core script migrateing ..."
flush_core_scripts &>/dev/null
echo "Gen_coreid_secret ..."
gen_coreid_secret  &>/dev/null

echo "Makeing config ..."
make_config  &>/dev/null
add_hosts  &>/dev/null

echo "Copy config to appdir ..."
copy_files  &>/dev/null

echo "Initing apps ..."
flush_init_js   &>/dev/null
echo "Start soa about ..."
start_systemd_service  &>/dev/null
echo "Starting pm2 service ..."
start_pm2 &>/dev/null
}
main 
