#!/bin/bash

DEPLOY_PATH=$(pwd)

alldown() {
    docker-compose -f $DEPLOY_PATH/adguardhome/docker-compose.yml down
    docker-compose -f $DEPLOY_PATH/nginx/docker-compose.yml down
    docker-compose -f $DEPLOY_PATH/nodered/docker-compose.yml down
    docker-compose -f $DEPLOY_PATH/portainer/docker-compose.yml down
    docker-compose -f $DEPLOY_PATH/ttrss/docker-compose.yml down
    docker-compose -f $DEPLOY_PATH/unlockmusic/docker-compose.yml down
    docker-compose -f $DEPLOY_PATH/watchtower/docker-compose.yml down
}

alldown