#!/bin/bash
#mongo -u root -p NvrkYvKN7Ns8MX admin 登陆方式
USR=root
PASSWD=NvrkYvKN7Ns8MX
ifconfig |grep -w "inet"|grep -v 0.0.0.0|awk '{print $2}'|grep -v 127.0.0.1 > $modifycfgdir/ipaddr
i=1
for line in `cat $modifycfgdir/ipaddr`
  do
    echo "$i: $line"
    let i++
done
read -p "input right interip: " interip

function add_password(){
    echo 'db.createUser(    {      user: "root",      pwd: "NvrkYvKN7Ns8MX",      roles: [ "root" ]    })'|mongo admin
    echo "auth=true" >> /teambition/conf/mongodb/mongod.conf
    /etc/init.d/mongod restart
    sleep 5
}

function change_config(){
    sed -i 's|mongodb://127.0.0.1:27017/teambition|mongodb://'$USR':'$PASSWD'@127.0.0.1:27017/teambition|g' /teambition/app/apps/config/default.json5   
    sed -i 's|mongodb://127.0.0.1:27017/teambition|mongodb://'$USR':'$PASSWD'@127.0.0.1:27017/teambition|g' /teambition/app/core/config/default.json5
    sed -i 's|mongodb://127.0.0.1:27017/teambition|mongodb://'$USR':'$PASSWD'@127.0.0.1:27017/teambition|g' /teambition/app/limbo-rpc/config/default.json5  
    sed -i 's|"mongo_auth_db": ""|"mongo_auth_db": "admin"|g' /teambition/app/limbo-rpc/config/default.json5
    sed -i 's|mongodb://127.0.0.1:27017/teambition|mongodb://'$USR':'$PASSWD'@127.0.0.1:27017/teambition|g' /teambition/app/organization-admin/config/default.json5
    sed -i 's|"auth_db": ""|"auth_db": "admin"|g' /teambition/app/organization-admin/config/default.json5
    sed -i 's|mongodb://127.0.0.1:27017/teambition|mongodb://'$USR':'$PASSWD'@127.0.0.1:27017/teambition|g' /teambition/app/organization-cms/config/default.json5
    sed -i 's|"auth_db": ""|"auth_db": "admin"|g' /teambition/app/organization-cms/config/default.json5
    sed -i 's|mongodb://127.0.0.1/teambition?|mongodb://'$USR':'$PASSWD'@127.0.0.1:27017/teambition?authSource=admin|g' /teambition/app/search/config/default.yml   
    sed -i 's|mongodb://127.0.0.1:27017/teambition|mongodb://'$USR':'$PASSWD'@127.0.0.1:27017/teambition?authSource=admin|g' /teambition/app/system-notice-service/config/services/limbo.js   
    sed -i 's|mongodb://127.0.0.1:27017/reportapp|mongodb://'$USR':'$PASSWD'@127.0.0.1:27017/reportapp?authSource=admin|g' /teambition/app/tb-reporting-app/config/services/db.js  
}
function change_tb_dockerapp(){
    sed -i 's|mongodb://'$interip':27017/commongroup|mongodb://'$USR':'$PASSWD'@'$interip':27017/commongroup?authSource=admin|g' /teambition/app/commongroup/default.yml
    sed -i 's|mongodb://'$interip':27017/teambition|mongodb://'$USR':'$PASSWD'@'$interip':27017/teambition?authSource=admin|g' /teambition/app/notification/default.yml
    sed -i 's|mongodb://'$interip':27017/teambition|mongodb://'$USR':'$PASSWD'@'$interip':27017/teambition?authSource=admin|g' /teambition/app/tis/default.yml
    sed -i 's|mongodb://'$interip':27017/testhub|mongodb://'$USR':'$PASSWD'@'$interip':27017/testhub?authSource=admin|g' /teambition/app/testhub/default.yml
    sed -i 's|mongodb://'$interip':27017/teambition|mongodb://'$USR':'$PASSWD'@'$interip':27017/teambition?authSource=admin|g' /teambition/app/testhub/default.yml
    sed -i 's|mongodb://'$interip':27017/teambition|mongodb://'$USR':'$PASSWD'@'$interip':27017/teambition?authSource=admin|g' /teambition/app/meeting/default.yml
}

function change_teambition_core_cli_config(){
cat >/teambition/app/teambition-core-cli/config/default.json <<EOF
{
  "init": {
    "execjs": "mongo 127.0.0.1/teambition -u $USR -p $PASSWD --authenticationDatabase admin",
    "elasticsearch": {
      "hosts": ["localhost:9200"]
    },
    "esIndexName": "teambition_latest"
  },        
  "exporter": {
    "execjs": "mongo 127.0.0.1/teambition -u $USR -p $PASSWD --authenticationDatabase admin",
    "tss": {
      "default": {
        "keyPrefix": "0",
        "providerType": "tss",
        "host": "http://www.wenjian.com",
        "tokenSecret": "tokenSecretXXX",
        "bucket": "default"
      }
    }
  },
  "importer": {
    "import": "mongoimport --host 127.0.0.1 --port 27017 -u $USR -p $PASSWD -d teambition  --mode=upsert --authenticationDatabase admin",
    "execjs": "mongo 127.0.0.1/teambition -u $USR -p $PASSWD --authenticationDatabase admin",
    "tss": {
      "default": {
        "keyPrefix": "0",
        "providerType": "tss",
        "host": "http://www.wenjian.com",
        "tokenSecret": "tokenSecretXXX",
        "bucket": "default"
      }
    },
    "strikerHost": "http://dsalesdemo2.teambition.net"
  },
  "recovery": {
    "execjs": "mongo 127.0.0.1:27017/teambition"
  },
  "redis": {
    "host": "127.0.0.1"
  },
  "tbanalysis": {
    "url": "http://127.0.0.1:10100",
    "client_id": "3694f5a0fa6fcbe7fc9655b3e043b93b319e2694",
    "client_secret": "dev-key"
  }
}
EOF
}

function change_docker_config(){
    sed -i 's|PC_MONGO_URL=mongodb://$PC_MONGO_HOST:27017/teambition|PC_MONGO_URL=mongodb://'$USR':'$PASSWD'@$PC_MONGO_HOST:27017/teambition?authSource=admin|g' ~/.bashrc
    source ~/.bashrc
   # cd /root/private-cloud
   # make upgrade
   # make upgrade-ds
}
function change_thoughts_config(){
    sed -i 's|"username": ""|"username": "'$USR'"|g' /teambition/thoughts/auth/dist/config.json
    sed -i 's|"password": ""|"password": "'$PASSWD'"|g' /teambition/thoughts/auth/dist/config.json
    sed -i 's|"auth_source": ""|"auth_source": "admin"|g' /teambition/thoughts/auth/dist/config.json
    
    sed -i 's|"username": ""|"username": "'$USR'"|g' /teambition/thoughts/org/dist/config.json
    sed -i 's|"password": ""|"password": "'$PASSWD'"|g' /teambition/thoughts/org/dist/config.json
    sed -i 's|"source": ""|"source": "admin"|g' /teambition/thoughts/org/dist/config.json

    sed -i 's|"username": ""|"username": "'$USR'"|g' /teambition/thoughts/soa-core/dist/config.json
    sed -i 's|"password": ""|"password": "'$PASSWD'"|g' /teambition/thoughts/soa-core/dist/config.json

    sed -i 's|"username": ""|"username": "'$USR'"|g' /teambition/thoughts/tcs/dist/local.json
    sed -i 's|"password": ""|"password": "'$PASSWD'"|g' /teambition/thoughts/tcs/dist/local.json
    sed -i 's|"auth_source": ""|"auth_source": "admin"|g' /teambition/thoughts/tcs/dist/local.json

    sed -i 's|"username": ""|"username": "'$USR'"|g' /teambition/thoughts/tpush/dist/config.json
    sed -i 's|"password": ""|"password": "'$PASSWD'"|g' /teambition/thoughts/tpush/dist/config.json
    sed -i 's|"auth_source": ""|"auth_source": "admin"|g' /teambition/thoughts/tpush/dist/config.json

    sed -i 's|"username": ""|"username": "'$USR'"|g' /teambition/thoughts/tracker/dist/config.json
    sed -i 's|"password": ""|"password": "'$PASSWD'"|g' /teambition/thoughts/tracker/dist/config.json
    sed -i 's|"auth_source": ""|"auth_source": "admin"|g' /teambition/thoughts/tracker/dist/config.json

    sed -i 's|"username": ""|"username": "'$USR'"|g' /teambition/thoughts/tim/dist/config.json
    sed -i 's|"password": ""|"password": "'$PASSWD'"|g' /teambition/thoughts/tim/dist/config.json
    sed -i 's|"source": ""|"source": "admin"|g' /teambition/thoughts/tim/dist/config.json
    systemctl restart authhttp
    systemctl restart authrpc
    systemctl restart org
    systemctl restart org-sync
    systemctl restart soa-core
    systemctl restart tcs
    systemctl restart tpush
    systemctl restart tracker
}

function main(){
add_password
change_config
change_tb_dockerapp
su - teambition -c "pm2 dump;pm2 kill;pm2 resurrect"
su - teambition8 -c "pm2 dump;pm2 kill;pm2 resurrect"
change_teambition_core_cli_config
change_docker_config
change_thoughts_config
}
main
