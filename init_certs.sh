#!/bin/bash

case "$1" in

up) echo "Creating CA, certs.."

    num=$(ls -l ./certs | grep -E "consul|vault" | wc -l)

    if [ "$num" -eq 0 ]; then 
      cfssl gencert -initca certs/config/ca-csr.json | cfssljson -bare certs/ca
      sleep 2
      cfssl gencert \
          -ca=certs/ca.pem \
          -ca-key=certs/ca-key.pem \
          -config=certs/config/ca-config.json \
          -profile=default \
          certs/config/consul-csr.json | cfssljson -bare certs/consul
      
      echo; sleep 2; echo
  
      cfssl gencert \
          -ca=certs/ca.pem \
          -ca-key=certs/ca-key.pem \
          -config=certs/config/ca-config.json \
          -profile=default \
          certs/config/vault-csr.json | cfssljson -bare certs/vault
    
      echo; ls -l certs/ | grep -E "consul|vault"; echo
    else
      echo "Already exist" 
    fi
  ;;
down)  echo  "Deleting certs.."
       sleep 2
       rm -rf certs/*.* 
  ;;
*)  echo "use 'up', 'down'..! arg '$1' is not declared!"
  ;;
esac

