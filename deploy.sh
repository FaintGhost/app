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
    cd $DEPLOY_PATH/nginx
    docker-compose up -d
}

deploy_adguardhome(){
    echo -e "开始部署AdGuardHome"
    mkdir /etc/systemd/resolved.conf.d
    cat > /etc/systemd/resolved.conf.d/a.txt << EOF
    [Resolve]
    DNS=127.0.0.1
    DNSStubListener=no
EOF
    mv /etc/resolv.conf /etc/resolv.conf.backup
    ln -s /run/systemd/resolve/resolv.conf /etc/resolv.conf
    systemctl restart systemd-resolved
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

deploy_ttrss(){
    echo -e "开始部署Tiny Tiny RSS"
    cd $DEPLOY_PATH/ttrss
    docker-compose up -d
}

install_ha(){
    cd ~
    apt-get install software-properties-common
    apt-get update
    apt-get install -y apparmor-utils apt-transport-https avahi-daemon ca-certificates curl dbus jq network-manager socat
    curl -sL https://raw.githubusercontent.com/FaintGhost/supervised-installer/master/installer.sh | bash -s -- -m intel-nuc
}

deploy(){
    echo "----------------------------------------"
    checkRoot
    echo "----------------------------------------"
    deploy_portainer
    echo "----------------------------------------"
    deploy_nginx
    echo "----------------------------------------"
    install_ha
    echo "----------------------------------------"
    deploy_nodered
    echo "----------------------------------------"
    deploy_homebridge
    echo "----------------------------------------"
    # deploy_adguardhome
    # echo "----------------------------------------"
    deploy_ttrss
    echo "----------------------------------------"
}

deploy