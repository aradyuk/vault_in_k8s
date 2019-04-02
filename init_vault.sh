#!/bin/bash

case "$1" in

up)  echo "Create Consul, Vault..."
     sleep 2

     echo "Creating vault namespace"
     kubectl create namespace vault
     
     echo "Generating the Gossip encryption key..."
     export GOSSIP_ENCRYPTION_KEY=$(consul keygen)
     
     echo "Creating the Consul Secret to store the Gossip key and the TLS certificates..."
     kubectl create secret generic consul \
       --from-literal="gossip-encryption-key=${GOSSIP_ENCRYPTION_KEY}" \
       --from-file=certs/ca.pem \
       --from-file=certs/consul.pem \
       --from-file=certs/consul-key.pem
     
     echo "Storing the Consul config in a ConfigMap..."
     kubectl create configmap consul --from-file=consul/config.json
     
     echo "Creating the Consul Service..."
     kubectl create -f consul/service.yaml
     
     echo "Creating the Consul StatefulSet..."
     kubectl create -f consul/statefulset.yaml
     
     echo "Creating a Secret to store the Vault TLS certificates..."
     kubectl create secret generic vault \
         --from-file=certs/ca.pem \
         --from-file=certs/vault.pem \
         --from-file=certs/vault-key.pem
     
     echo "Storing the Vault config in a ConfigMap..."
     kubectl create configmap vault --from-file=vault/config.json
     
     echo "Creating the Vault Service..."
     kubectl create -f vault/service.yaml
     
     echo "Creating the Vault Deployment..."
     kubectl apply -f vault/deployment.yaml
     
     echo "All done! Forwarding port 8200..."
     #POD=$(kubectl get pods -o=name | grep vault | sed "s/^.\{4\}//")

     watch -n1 "echo -e "-------Completed----------"; kubectl get all -n=vault"
     
#     while true; do
#       STATUS=$(kubectl get pods ${POD} -o jsonpath="{.status.phase}")
#       if [ "$STATUS" == "Running" ]; then
#         break
#       else
#         echo "Pod status is: ${STATUS}"
#         sleep 5
#       fi
#     done
     
     #kubectl port-forward --address 0.0.0.0 $POD 8200:8200
  ;;
down)  echo  "Delete Counsul, Vault.."
       sleep 2

       echo "Delete the Consul Secret.."
       kubectl delete secret generic consul
       
       echo "Delete the Consul config in a ConfigMap..."
       kubectl delete configmap consul
       
       echo "Deleting the Consul Service..."
       kubectl delete -f consul/service.yaml
       
       echo "Deleting the Consul StatefulSet..."
       kubectl delete -f consul/statefulset.yaml
       
       echo "Deleting a Secret to store the Vault TLS certificates..."
       kubectl delete secret generic vault
       
       echo "Delete the Vault config from a ConfigMap..."
       kubectl delete configmap vault
       
       echo "Deleting the Vault Service..."
       kubectl delete -f vault/service.yaml
       
       echo "Deleting the Vault Deployment..."
       kubectl delete -f vault/deployment.yaml
       
       watch -n1 kubectl get all -n=vault
  ;;
*)  echo "use 'up', 'down'..! arg '$1' is not declared!"
  ;;
esac

