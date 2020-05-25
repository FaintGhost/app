#!/bin/bash

DEPLOY_PATH=`pwd`

checkRoot(){
    if [ $(id -u) != "0" ]; then
        echo "ROOT用户 [x]"
        echo "请使用ROOT用户执行本脚本！"
        exit 1
    fi
    echo "ROOT用户 [✓]"
    echo "执行脚本!"
}

deploy_portainer(){
    echo -e "开始部署Portainer"
    cd $DEPLOY_PATH/portainer
    docker-compose up -d
}

deploy_nginx(){
    echo -e "开始部署Nginx Proxy Manager"
    cd $DEPLOY_PATH/nginxproxymanager
    docker-compose up -d
}

deploy_adguardhome(){
    echo -e "开始部署AdGuardHome"
    cd $DEPLOY_PATH/adguardhome
    docker-compose up -d
}

deploy_homebridge(){
    echo -e "开始部署HomeBridge"
    cd $DEPLOY_PATH/homebridge
    docker-compose up -d
}

deploy_nodered(){
    echo -e "开始部署NodeRED"
    sudo chown -R 1000:1000 $DEPLOY_PATH/nodered
    cd $DEPLOY_PATH/nodered
    docker-compose up -d
}

deploy(){
    echo "----------------------------------------"
    checkRoot
    echo "----------------------------------------"
    deploy_portainer
    echo "----------------------------------------"
    deploy_nginx
    echo "----------------------------------------"
    deploy_homebridge
    echo "----------------------------------------"
    deploy_adguardhome
    echo "----------------------------------------"
    deploy_nodered
    echo "----------------------------------------"
}

deploy