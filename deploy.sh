#!/bin/bash

DEPLOY_PATH=`pwd`

choose(){
    echo -e "请输入你的选择: \n"
    until
    echo "1.开始部署"
    echo "2.停止部署"
    echo -e "3.退出脚本 \n"
    read input
    test $input = 6
    do
        case $input in
            1) deploy
            break;;
            2) stop
            break;;
            3)
            break;;
        esac
    done
}

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
    sudo chown -R 1000:1000 $DEPLOY_PATH/nodered/data
    cd $DEPLOY_PATH/nodered
    docker-compose up -d
}

down_portainer(){
    echo -e "正在停止Portainer"
    cd $DEPLOY_PATH/portainer
    docker-compose down
}

down_nginx(){
    echo -e "正在停止Nginx Proxy Manager"
    cd $DEPLOY_PATH/nginxproxymanager
    docker-compose down
}

down_adguardhome(){
    echo -e "正在停止AdGuardHome"
    cd $DEPLOY_PATH/adguardhome
    docker-compose down
}

down_homebridge(){
    echo -e "正在停止HomeBridge"
    cd $DEPLOY_PATH/homebridge
    docker-compose down
}

down_nodered(){
    echo -e "正在停止NodeRED"
    cd $DEPLOY_PATH/nodered
    docker-compose down
}

deploy(){
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

stop(){
    checkRoot
    echo "----------------------------------------"
    down_portainer
    echo "----------------------------------------"
    down_nginx
    echo "----------------------------------------"
    down_homebridge
    echo "----------------------------------------"
    down_adguardhome
    echo "----------------------------------------"
    down_nodered
    echo "----------------------------------------"
}

choose