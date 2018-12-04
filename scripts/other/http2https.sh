#!/bin/bash

read -p "set domain:" domain
read -p "set striker domain:" striker

function http2https(){
sed -i "s|http://$domain|https://$domain|g"   `grep $domain  -rl /teambition/app/*/config/*`
sed -i "s|http://$striker|https://$striker|g" `grep $striker -rl /teambition/app/*/config/*`
sed -i "s|http://$domain|https://$domain|g"   `grep $domain  -rl /teambition/app/apps/dist/index.html`
sed -i "s|http://$striker|https://$striker|g" `grep $striker -rl /teambition/app/apps/dist/index.html`
sed -i "s|http://$domain|https://$domain|g"   `grep $domain  -rl /teambition/app/apps/scripts/init_db.js`
sed -i "s|http://$domain|https://$domain|g"   `grep $domain  -rl /teambition/conf/nginx/conf.d/web.conf`
sed -i "s|http://$domain|https://$domain|g"   `grep $domain  -rl /teambition/app/organization-cms/build/index.html`
sed -i "s|http://$striker|https://$striker|g" `grep $striker -rl /teambition/app/organization-cms/build/index.html`
sed -i "s|http://$domain|https://$domain|g"   `grep $domain  -rl /teambition/app/organization-admin/build/index.html`
sed -i "s|http://$striker|https://$striker|g" `grep $striker -rl /teambition/app/organization-admin/build/index.html`
sed -i "s|http://$domain|https://$domain|g"   `grep $domain  -rl /teambition/thoughts/org/dist/config.json`
}

function restart_service(){
/etc/init.d/nginx restart
systemctl restart org
systemctl restart org-sync
systemctl restart authhttp
systemctl restart authrpc
systemctl restart tcmd
systemctl restart tcmo
systemctl restart tcmi
systemctl restart soa-core
su - teambition  -c "pm2 dump && pm2 kill && pm2 resurrect"
su - teambition8 -c "pm2 dump && pm2 kill && pm2 resurrect"
}

main(){
http2https
restart_service
}

main
