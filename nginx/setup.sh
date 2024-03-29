#!/bin/bash

timezone=${cat /etc/timezone}

init_nginx_config(){
    echo "初始化 Nginx 配置文件"
    docker run --name=nginx --rm -d nginx:stable-alpine
    docker cp nginx:/etc/nginx .
    mv nginx conf
    docker stop nginx
    echo "----------------------------------------------"
}

issue_cert(){
read -p "Please input your CF_Token: " cf_token
read -p "Please input your Account_ID: " account_id
read -p "Please input your domain(without http): " domain
read -p "Please input your email: " email
sed -i "17s/$/\n      - sh.acme.autoload.domain=${domain}/g" docker-compose.yml
cat>.env<<EOF
TZ=${timezone}
CF_Token=${cf_token}
CF_Account_ID=${account_id}
DEPLOY_DOCKER_CONTAINER_LABEL=sh.acme.autoload.domain=${domain}
DEPLOY_DOCKER_CONTAINER_KEY_FILE=/etc/nginx/ssl/${domain}/key.pem
DEPLOY_DOCKER_CONTAINER_CERT_FILE=/etc/nginx/ssl/${domain}/cert.pem
DEPLOY_DOCKER_CONTAINER_CA_FILE=/etc/nginx/ssl/${domain}/ca.pem
DEPLOY_DOCKER_CONTAINER_FULLCHAIN_FILE=/etc/nginx/ssl/${domain}/full.pem
DEPLOY_DOCKER_CONTAINER_RELOAD_CMD="service nginx force-reload"
EOF
docker-compose -f ${PWD}/docker-compose.yml up -d
# init acme.sh regist
docker exec acme.sh --register-account -m ${email}
# issue the new wildcard cert
docker exec acme.sh --issue -d ${domain} -d *.${domain} --dns dns_cf --ocsp-must-staple --keylength ec-256
# deploy the cert to nginx container
docker exec acme.sh --deploy --ecc -d ${domain} -d *.${domain} --deploy-hook docker
}

init_nginx_config
issue_cert
openssl dhparam -out ${PWD}/conf/dhparam.pem 2048
