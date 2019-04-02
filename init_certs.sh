#!/bin/bash

case "$1" in

up)  echo "Create CA, certs"
     cfssl gencert -initca certs/config/ca-csr.json | cfssljson -bare certs/ca
    # Gen certs:
    cfssl gencert \
        -ca=certs/ca.pem \
        -ca-key=certs/ca-key.pem \
        -config=certs/config/ca-config.json \
        -profile=default \
        certs/config/consul-csr.json | cfssljson -bare certs/consul
    
    cfssl gencert \
        -ca=certs/ca.pem \
        -ca-key=certs/ca-key.pem \
        -config=certs/config/ca-config.json \
        -profile=default \
        certs/config/vault-csr.json | cfssljson -bare certs/vault
    ls -l certs/
  ;;
down)  echo  "Delete $(ls -l certs/*.*)"
    rm -rf certs/*.* 
  ;;
*)  echo "use 'up', 'down'..! arg '$1' is not declared!"
  ;;
esac


