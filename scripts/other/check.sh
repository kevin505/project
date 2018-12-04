#!/bin/sh


# shell script: checklink.sh
# function: auto check the link of server IP and PORT

#根据系统类型的不同，加载系统环境变量
if [ `uname` = "Linux" ]
then
  PROFILE=.bash_profile
else
  PROFILE=.profile
fi

. $HOME/$PROFILE

#在脚本执行目录下创建日志文件 .log 和检测的最终结果文件.dat
resultfile=$PWD/checklink.dat
log_file=$PWD/checklink.log

#读取传递的脚本参数
IP=127.0.0.1

array=(22 80 5000 5011 15432 6040 6379 7700 8081 8082 8083 8085 9200 9205 27017)

for port in ${array[@]}
do

if [ -z $IP -o -z ${port} ]
then
    echo `date +"%Y.%m.%d %T"`"the parameter should not be null,exit!" >>${log_file}
    exit
fi

RATE=`ping -c 4 -w 3 $IP | grep 'packet loss' | grep -v grep | awk -F',' '{print $3}' | awk -F'%' '{print $1}'`     #得到丢包的比例的数值

if [ $RATE -eq 10 ]     #这个值具体可以设置成75、50等等，这里设置成包全丢的情况下为不通
then
    echo `date +"%Y.%m.%d %T"`" ping the $IP is not connected, FAILURE " >>${log_file}
    echo -e "ping $IP \033[31m FAILURE \033[0m"           #全丢了说明该IP地址不通
else
    telnet $IP $port<<@@@ 2>${resultfile} 1>&2               #否则telnet命令检测指定端口号PORT是否连通，如果可以连通，则立马quit退出连接，将连接结果和错误信息等都写入到结果文件中
quit
@@@


    RESULT=`cat ${resultfile} 2>/dev/null | grep "Connection closed by foreign host" | wc -l`        #匹配看结果文件中手否有这句话
    echo `date +"%Y.%m.%d %T"`" the result of telnet is $RESULT" >>${log_file}
    
    if [ $RESULT -eq 1 ]
    then
        echo `date +"%Y.%m.%d %T"`" telnet the  $IP and $port SUCCESS" >>${log_file}         #如果有的话就说明该端口是通的，返回结果字符串SUCCESS到文件并同时打印大屏幕上
        echo -e "ip:$IP port:$port \033[32m SUCCESS \033[0m"
    else
        echo `date +"%Y.%m.%d %T"`" telnet the $IP and $port FAILURE" >>${log_file}           #否则就说明该端口是不通的，打印FAILURE
        echo -e "ip:$IP port:$port \033[31m FAILURE \033[0m"
    fi
fi

done

#####################################apple###############################################

IP=gateway.push.apple.com
port=2195
if [ -z $IP -o -z ${port} ]
then
    echo `date +"%Y.%m.%d %T"`"the parameter should not be null,exit!" >>${log_file}
    exit
fi

RATE=`ping -c 4 -w 3 $IP | grep 'packet loss' | grep -v grep | awk -F',' '{print $3}' | awk -F'%' '{print $1}'`     #得到丢包的比例的数值

if [ $RATE -eq 10 ]     #这个值具体可以设置成75、50等等，这里设置成包全丢的情况下为不通
then
    echo `date +"%Y.%m.%d %T"`" ping the $IP is not connected, FAILURE " >>${log_file}
    echo -e "ping $IP \033[31m FAILURE \033[0m"           #全丢了说明该IP地址不通
else
    telnet $IP $port<<@@@ 2>${resultfile} 1>&2               #否则telnet命令检测指定端口号PORT是否连通，如果可以连通，则立马quit退出连接，将连接结果和错误>信息等都写入到结果文件中
quit
@@@


    RESULT=`cat ${resultfile} 2>/dev/null | grep "Connection closed by foreign host" | wc -l`        #匹配看结果文件中手否有这句话
    echo `date +"%Y.%m.%d %T"`" the result of telnet is $RESULT" >>${log_file}

    if [ $RESULT -eq 1 ]
    then
        echo `date +"%Y.%m.%d %T"`" telnet the  $IP and $port SUCCESS" >>${log_file}         #如果有的话就说明该端口是通的，返回结果字符串SUCCESS到文件并同
        echo -e "ip:$IP port:$port \033[32m SUCCESS \033[0m"
    else
        echo `date +"%Y.%m.%d %T"`" telnet the $IP and $port FAILURE" >>${log_file}           #否则就说明该端口是不通的，打印FAILURE
        echo -e "ip:$IP port:$port \033[31m FAILURE \033[0m"
    fi
fi

#######################################android################################
IP=api.xmpush.xiaomi.com
port=443
if [ -z $IP -o -z ${port} ]
then
    echo `date +"%Y.%m.%d %T"`"the parameter should not be null,exit!" >>${log_file}
    exit
fi

RATE=`ping -c 4 -w 3 $IP | grep 'packet loss' | grep -v grep | awk -F',' '{print $3}' | awk -F'%' '{print $1}'`     #得到丢包的比例的数值

if [ $RATE -eq 10 ]     #这个值具体可以设置成75、50等等，这里设置成包全丢的情况下为不通
then
    echo `date +"%Y.%m.%d %T"`" ping the $IP is not connected, FAILURE " >>${log_file}
    echo -e "ping $IP \033[31m FAILURE \033[0m"           #全丢了说明该IP地址不通
else
    telnet $IP $port<<@@@ 2>${resultfile} 1>&2               #否则telnet命令检测指定端口号PORT是否连通，如果可以连通，则立马quit退出连接，将连接结果和错误>信息等都写入到结果文件中
quit
@@@


    RESULT=`cat ${resultfile} 2>/dev/null | grep "Connection closed by foreign host" | wc -l`        #匹配看结果文件中手否有这句话
    echo `date +"%Y.%m.%d %T"`" the result of telnet is $RESULT" >>${log_file}

    if [ $RESULT -eq 1 ]
    then
        echo `date +"%Y.%m.%d %T"`" telnet the  $IP and $port SUCCESS" >>${log_file}         #如果有的话就说明该端口是通的，返回结果字符串SUCCESS到文件并同
        echo -e "ip:$IP port:$port \033[32m SUCCESS \033[0m"
    else
        echo `date +"%Y.%m.%d %T"`" telnet the $IP and $port FAILURE" >>${log_file}           #否则就说明该端口是不通的，打印FAILURE
        echo -e "ip:$IP port:$port \033[31m FAILURE \033[0m"
    fi
fi






rm -f ${resultfile}            #删除结果文件，日志文件保留
