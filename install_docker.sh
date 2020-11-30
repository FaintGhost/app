#!/bin/bash

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

install_essentials
install_docker
