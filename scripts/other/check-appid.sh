#!/bin/sh
grep 'auth' /teambition/conf/mongodb/mongod.conf > /dev/null
if [ $? -eq 0 ]; then
    echo "Mongo has been encrypted !"
    mongo_id=`echo "db.soaapps.find()" | mongo soa -u root -p NvrkYvKN7Ns8MX --authenticationDatabase admin | grep '_id' | awk -F "[\"\"]" '{print$4}' `
    mongo_secret=`echo "db.soasuites.find()" | mongo soa -u root -p NvrkYvKN7Ns8MX --authenticationDatabase admin | grep -o '\[.*\]'| awk '{print$2}' | sed 's/\"//g'`
else
    echo "Mongo has not been encrypted !"
    mongo_id=`echo "db.soaapps.find()" | mongo soa | grep '_id' | awk -F "[\"\"]" '{print$4}' `
    mongo_secret=`echo "db.soasuites.find()" | mongo soa | grep -o '\[.*\]'| awk '{print$2}' | sed 's/\"//g'`
fi 

echo ========================================
echo ---------mongo -- app_id-------------
echo "$mongo_id"
echo ---------mongo -- secret-------------
echo "$mongo_secret"
echo ========================================

core_id=`cat /teambition/app/core/config/default.json5 | grep  "APP_ID"| head -n 1 | awk '{print$2}' | sed 's/\"//g' | sed 's/.$//'`
core_secret=`cat /teambition/app/core/config/default.json5 | grep '\<SECRET\>' | awk '{print$2}' | sed 's/\"//g' | sed 's/.$//'`
echo core
echo $core_id $core_secret
echo ========================================

apps_id=`cat /teambition/app/apps/config/default.json5 | grep  "appId" | awk '{print$2}' | sed 's/\"//g' | sed 's/.$//'`
apps_secret=`cat /teambition/app/apps/config/default.json5 | grep "\<secret\>" | awk -F':' '{print $2}' | sed -n '$p' | sed 's/\"//g' | sed 's/.$//'`
echo apps
echo $apps_id $apps_secret
echo ========================================

accounts_id=`cat /teambition/app/accounts/config/default.json5 | grep  "appid" | awk '{print$2}' | sed 's/\"//g' | sed 's/.$//'`
accounts_secret=`cat /teambition/app/accounts/config/default.json5 | grep "\<secret\>" | awk -F':' '{print $2}' | head -1 | sed 's/\"//g' | sed 's/.$//'`
echo accounts
echo $accounts_id $accounts_secret
echo ========================================

org_admin_id=`cat /teambition/app/organization-admin/config/default.json5 | grep  "appId" | awk '{print$2}' | sed 's/\"//g' | sed 's/.$//'`
org_admin_secret=`cat /teambition/app/organization-admin/config/default.json5 | grep "\<secret\>" | awk -F':' '{print $2}' | tail -1  | sed 's/\"//g' | sed 's/.$//'`
echo organization-admin
echo $org_admin_id $org_admin_secret 
echo ========================================

search_id=`cat /teambition/app/search/config/default.yml | grep  "APP_ID" | awk '{print$2}' | sed 's/\"//g'`
search_secret=`cat /teambition/app/search/config/default.yml | grep  "SECRET" | awk '{print$2}' | sed 's/\"//g'`
echo search
echo $search_id $search_secret    
echo ========================================

search_id=`cat /teambition/app/tb-reporting-app/config/services/tws_auth.js | grep  "app_id" | awk '{print$2}' | tail -1 | sed  $'s/\'//g' | sed 's/.$//'`
search_secret=`cat /teambition/app/tb-reporting-app/config/services/tws_auth.js | grep  "secret" | awk '{print$2}' | tail -1 | sed  $'s/\'//g' | sed 's/.$//'`
echo tb-reporting-app
echo $search_id $search_secret
echo ========================================

org_id=`cat /teambition/thoughts/org/dist/config.json | grep  "app_id" | awk '{print$2}' | sed 's/\"//g' | sed 's/.$//'`
org_secret=`cat /teambition/thoughts/org/dist/config.json | grep -A 1 "secret" | awk '{print$1}' | tail -1 | sed 's/\"//g'`
echo soa-org
echo $org_id $org_secret
echo ========================================
 
tcs_id=`cat /teambition/thoughts/tcs/dist/local.json | grep  "appID" | awk -F ':' '{print$2}' | sed 's/\"//g' | sed 's/.$//'`
echo soa-tcs
echo $tcs_id 
echo ========================================

tis_id=`cat /teambition/app/tis/default.yml | grep  "APP_ID" | awk '{print$2}' | sed $'s/\'//g'`
tis_secret=`cat /teambition/app/tis/default.yml | grep  "SECRET" | awk '{print$2}' | tail -1 | sed $'s/\'//g'`
echo docker-tis
echo $tis_id $tis_secret
echo ========================================

meeting_id=`cat /teambition/app/meeting/default.yml | grep  "APP_ID" | awk '{print$2}' | sed $'s/\'//g'`
echo docker-meeting
echo $meeting_id
echo ========================================       

testhub_id=`cat /teambition/app/testhub/default.yml | grep  "APP_ID" | awk '{print$2}' | sed $'s/\'//g'`
testhub_secret=`cat /teambition/app/testhub/default.yml | grep  "SECRET" | awk '{print$2}' | tail -2 | sed $'s/\'//g' | head -1`
echo docker-testhub
echo $testhub_id $testhub_secret
echo ========================================   

notification_id=`cat /teambition/app/notification/default.yml | grep  "APP_ID" | awk '{print$2}'`
notification_secret=`cat /teambition/app/notification/default.yml | grep  "SECRET" | awk '{print$2}'`
echo docker-notification
echo $notification_id $notification_secret
echo ======================================== 


