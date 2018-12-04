# 私有部署脚本仓库

## 目录说明
gamma包目录结构:  

- conf
- docker
- elasticsearch
- fonts
- haproxy
- init.d
- license
- logrotate
- modifycfg
- mongo
- nginx
- node
- nova
- scripts
- tbapp


其中script为所有脚本目录，结构如下:
- deploy.sh
- deployha.sh
- other
        - check-appid.sh
        - check.sh
        - http2https.sh
        - mongoauth.sh
        - server_init.sh
        - teambition_index.js
- docker
        - install-base.sh (安装docker,docker-compose)
        - install-docker.sh (导入els6,rabbitmq等镜像)
- elasticsearch
        - install-es.sh
- fonts
        - xx.sh
- license
        - xx.sh
- modify
        - xx.sh
- mongo
        - xx.sh
- nginx
        - xx.sh
- node
        - xx.sh
- redis
        - xx.sh

script目录存放所有脚本，安装包存放在deploy.sh定义的gammadir下  
注意：安装包目录下面的目录名与脚本中路径相对应,即以nginx为例，安装脚本找安装包的路径为`$gammadir/nginx`

待解决问题:
初次执行modify是在mongo没有加密的情况下,升级的时候mongo加密了,需要手动执行升级时的刷库脚本。