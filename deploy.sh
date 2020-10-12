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

install_essentials() {
    sudo apt update -y
    sudo apt install git apt-transport-https wget ca-certificates curl gnupg-agent software-properties-common apparmor-utils avahi-daemon ca-certificates dbus jq network-manager socat cifs-utils smbclient unzip fuse -y
}

install_rclone() {
    curl https://rclone.org/install.sh | sudo bash
}

install_docker() {
    curl -fsSL https://download.docker.com/linux/debian/gpg | sudo apt-key add -
    sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/debian $(lsb_release -cs) stable"
    sudo apt update -y
    sudo apt install docker-ce docker-ce-cli containerd.io docker-compose -y
}

install_ha() {
    cd ~
    apt update -y
    curl -sL https://raw.githubusercontent.com/home-assistant/supervised-installer/master/installer.sh | bash -s -- -m intel-nuc
}

deploy_portainer() {
    echo -e "开始部署Portainer"
    docker-compose -f $DEPLOY_PATH/portainer/docker-compose.yml up -d
}

deploy_nginx() {
    echo -e "开始部署Nginx Proxy Manager"
    docker-compose -f $DEPLOY_PATH/nginx/docker-compose.yml up -d
}

deploy_adguardhome() {
    echo -e "开始部署AdGuardHome"
    docker-compose -f $DEPLOY_PATH/adguardhome/docker-compose.yml up -d
}

deploy_nodered() {
    echo -e "开始部署NodeRED"
    sudo chown -R 1000:1000 $DEPLOY_PATH/nodered/data
    rm $DEPLOY_PATH/nodered/data/.gitkeep
    docker-compose -f $DEPLOY_PATH/nodered/docker-compose.yml up -d
}

deploy_unlockmusic() {
    echo -e "开始部署UnblockNeteaseMusic"
    docker-compose -f $DEPLOY_PATH/unlockmusic/docker-compose.yml up -d
}

deploy_rsshub() {
    echo -e "开始部署RSSHub"
    docker-compose -f $DEPLOY_PATH/rsshub/docker-compose.yml up -d
}

deploy_ttrss() {
    echo -e "开始部署Tiny Tiny RSS"
    docker-compose -f $DEPLOY_PATH/ttrss/docker-compose.yml up -d
}

deploy_watchtower() {
    echo -e "开始部署Watchtower"
    docker-compose -f $DEPLOY_PATH/watchtower/docker-compose.yml up -d
}

deploy() {
    echo "----------------------------------------"
    checkRoot
    deploy_adguardhome
    echo "----------------------------------------"
    deploy_portainer
    echo "----------------------------------------"
    deploy_nginx
    echo "----------------------------------------"
    deploy_unlockmusic
    echo "----------------------------------------"
    # install_ha
    # echo "----------------------------------------"
    deploy_nodered
    echo "----------------------------------------"
    deploy_rsshub
    echo "----------------------------------------"
    deploy_ttrss
    echo "----------------------------------------"
    deploy_watchtower
}

deploy
