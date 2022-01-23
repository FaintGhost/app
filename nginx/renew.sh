#!/bin/bash

domain=`ls conf/ssl`

renew_cert(){
    docker exec acme.sh --issue -d ${domain} -d *.${domain} --dns dns_cf --ocsp-must-staple --keylength ec-256 --force
    docker exec acme.sh --deploy --ecc -d ${domain} -d *.${domain} --deploy-hook docker
}

renew_cert
