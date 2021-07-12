#!/bin/bash

init_nginx_config(){
    echo "init nginx config files"
    sed -i "s%- ./conf:/etc/nginx%#- ./conf:/etc/nginx%g" docker-compose.yml
    docker-compose -f $PWD/docker-compose.yml run --name=nginx --rm -d nginx
    docker container cp nginx:/etc/nginx .
    mv nginx conf
    sed -i "s%#- ./conf:/etc/nginx%- ./conf:/etc/nginx%g" docker-compose.yml  
    docker-compose -f $PWD/docker-compose.yml down
}

issue_cert(){
    read -p "Pleas input your CF_TOKEN: " cf_token
    sed -i "s/CF_Token=/CF_Token=$cf_token/g" .env
    read -p "Please input your Account_ID: " account_id
    sed -i "s/CF_Account_ID=/CF_Account_ID=$account_id/g" .env
    read -p "Please input your domain(without http): " domain
    sed -i "s/example.com/$domain/g" .env
    sed -i "s/sh.acme.autoload.domain=example.com/sh.acme.autoload.domain=$domain/g" docker-compose.yml
    read -p "Please input your email: " email
    openssl dhparam -out ./conf/dhparam.pem 2048
    docker-compose -f $PWD/docker-compose.yml up -d
    # init acme.sh regist
    docker exec acme.sh --register-account -m $email
    # issue the new wildcard cert
    docker exec acme.sh --issue -d $domain -d *.$domain --dns dns_cf --ocsp-must-staple --keylength ec-256
    # deploy the cert to nginx container
    docker exec acme.sh --deploy --ecc -d $domain -d *.$domain --deploy-hook docker
}

init_nginx_config
issue_cert