#!/bin/bash

init_nginx_config(){
    docker-compose -f $PWD/docker-compose.yml up -d
    docker container cp nginx:/etc/nginx .
    docker-compose -f $PWD/docker-compose.yml down
}

issue_cert(){
    docker-compose -f $PWD/docker-compose.yml up -d
    # init acme.sh regist
    docker exec acme.sh --register-account -m youremail@example.com
    # issue the new wildcard cert
    docker exec acme.sh --issue -d example.com -d *.example.com --dns dns_cf --ocsp-must-staple --keylength ec-256
    # deploy the cert to nginx container
    docker exec acme.sh --deploy --ecc -d example.com -d *.example.com --deploy-hook docker
}

init_nginx_config
issue_cert