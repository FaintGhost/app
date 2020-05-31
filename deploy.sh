#!/bin/bash

DEPLOY_PATH=$(pwd)

checkRoot() {
    if [ $(id -u) != "0" ]; then
        echo "ROOT用户 [x]"
        echo "请使用ROOT用户执行本脚本！"
        exit 1
    fi
    echo "ROOT用户 [✓]"
    echo "执行脚本!"
}

install_rclone() {
    sudo apt-get install unzip fuse -y
    curl https://rclone.org/install.sh | sudo bash
}

install_docker() {
    sudo apt-get update -y
    sudo apt-get install apt-transport-https wget ca-certificates curl gnupg-agent software-properties-common -y
    curl -fsSL https://download.docker.com/linux/debian/gpg | sudo apt-key add -
    sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/debian $(lsb_release -cs) stable"
    sudo apt-get update -y
    sudo apt-get install docker-ce docker-ce-cli containerd.io docker-compose -y
}

deploy_portainer() {
    echo -e "开始部署Portainer"
    cd $DEPLOY_PATH/portainer
    docker-compose up -d
}

deploy_nginx() {
    echo -e "开始部署Nginx Proxy Manager"
    cd $DEPLOY_PATH/nginx
    docker-compose up -d
}

deploy_adguardhome() {
    echo -e "开始部署AdGuardHome"
    cd $DEPLOY_PATH/adguardhome
    docker-compose up -d
}

deploy_nodered() {
    echo -e "开始部署NodeRED"
    sudo chown -R 1000:1000 $DEPLOY_PATH/nodered
    cd $DEPLOY_PATH/nodered
    docker-compose up -d
}

deploy_ttrss() {
    echo -e "开始部署Tiny Tiny RSS"
    cd $DEPLOY_PATH/ttrss
    docker-compose up -d
}

install_ha() {
    cd ~
    apt-get install software-properties-common
    apt-get update -y
    apt-get install -y apparmor-utils apt-transport-https avahi-daemon ca-certificates curl dbus jq network-manager socat
    curl -sL https://raw.githubusercontent.com/FaintGhost/supervised-installer/master/installer.sh | bash -s -- -m intel-nuc
}

deploy_watchtower() {
    echo -e "开始部署Watchtower"
    cd $DEPLOY_PATH/watchtower
    docker-compose up -d
}

deploy() {
    echo "----------------------------------------"
    checkRoot
    deploy_adguardhome
    echo "----------------------------------------"
    echo "----------------------------------------"
    deploy_portainer
    echo "----------------------------------------"
    deploy_nginx
    echo "----------------------------------------"
    install_ha
    echo "----------------------------------------"
    deploy_nodered
    echo "----------------------------------------"
    deploy_ttrss
    echo "----------------------------------------"
    deploy_watchtower
}

deploy
