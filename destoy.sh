#!/bin/bash

echo "Delete the Consul Secret.." 
kubectl delete secret generic consul \

echo "Delete the Consul config in a ConfigMap..."
kubectl delete configmap consul --from-file=consul/config.json

echo "Deleting the Consul Service..."
kubectl delete -f consul/service.yaml

echo "Deleting the Consul StatefulSet..."
kubectl delete -f consul/statefulset.yaml

echo "Deleting a Secret to store the Vault TLS certificates..."
kubectl delete secret generic vault 

echo "Delete the Vault config from a ConfigMap..."
kubectl delete configmap vault --from-file=vault/config.json

echo "Deleting the Vault Service..."
kubectl delete -f vault/service.yaml

echo "Deleting the Vault Deployment..."
kubectl delete -f vault/deployment.yaml

watch -n1 kubectl get all -n=vault
