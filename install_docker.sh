#!/bin/bash

install_essentials() {
    sudo apt update -y
    sudo apt install git apt-transport-https wget ca-certificates curl gnupg-agent software-properties-common apparmor-utils avahi-daemon ca-certificates dbus jq network-manager socat cifs-utils smbclient unzip fuse -y
}

install_rclone() {
    curl https://rclone.org/install.sh | sudo bash
}

install_docker() {
    curl -fsSL https://get.docker.com -o get-docker.sh
    sh get-docker.sh
}

install_essentials
install_docker
