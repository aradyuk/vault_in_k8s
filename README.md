# Running Vault and Consul on Kubernetes
Related/Useful links: 
[post](https://testdriven.io/running-vault-and-consul-on-kubernetes), 
[Nginx ingress](https://kubernetes.github.io/ingress-nginx/user-guide/external-articles/).

### Prerequisites

##### Install:

1. [Installing Go](https://linux4one.com/how-to-install-go-on-centos-7/)
1. [Install CloudFlare's SSL ToolKit](https://github.com/cloudflare/cfssl) (`cfssl` and `cfssljson`)
1. [Consul](https://www.consul.io/docs/install/index.html)
1. [Vault](https://www.vaultproject.io/docs/install/)
1. Pre-installed k8s, by default will be used `vault` namespace
1. Pre-configured AWS KMS key and access (Role/Policy)

### TLS Certificates

Create a Certificate Authority:

```sh
$ cfssl gencert -initca certs/config/ca-csr.json | cfssljson -bare certs/ca
```

Create the private keys and TLS certificates:

```sh
$ cfssl gencert \
    -ca=certs/ca.pem \
    -ca-key=certs/ca-key.pem \
    -config=certs/config/ca-config.json \
    -profile=default \
    certs/config/consul-csr.json | cfssljson -bare certs/consul

$ cfssl gencert \
    -ca=certs/ca.pem \
    -ca-key=certs/ca-key.pem \
    -config=certs/config/ca-config.json \
    -profile=default \
    certs/config/vault-csr.json | cfssljson -bare certs/vault
```

### Vault and Consul

Spin up Vault and Consul on Kubernetes:

```sh
$ sh create.sh
```

### Environment Variables

In a new terminal window, navigate to the project directory and set the following environment variables:

```sh
$ export VAULT_ADDR=https://127.0.0.1:8200
$ export VAULT_TOKEN=your_token
```
If having problem with x509, without a proper cert is first way with cert the second one:
```sh
$ export VAULT_SKIP_VERIFY=true
$ export VAULT_CACERT="certs/ca.pem"
```

### Verify

```sh
$ kubectl get pods
$ vault status
```

# Under development:
##### - AWS KMS integration (for auto-unsealing, and encryption of ```root-token```, ```unseal keys```);
##### - AWS DynamoDB as a backend-storage of vault;
##### - Consider to add affinity for consul/vault nodes.
...
