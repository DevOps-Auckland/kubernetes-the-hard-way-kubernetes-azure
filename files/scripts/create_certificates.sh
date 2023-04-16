#!/bin/bash
#This script accepts 1 parameter. The resource group where the workers are deployed.
RESOURCE_GROUP="kubernetesrg"
IP_NAME="KubeLB_PublicIP"
KUBERNETES_HOSTNAMES="kubernetes,kubernetes.default,kubernetes.default.svc,kubernetes.default.svc.cluster,kubernetes.svc.cluster.local"
KUBERNETES_PUBLIC_ADDRESS=$(az network public-ip show -g ${RESOURCE_GROUP} -n ${IP_NAME} --query "address" )
cd ../certs/

#Generate the Certificate Authority

cfssl gencert -initca ca-csr.json | cfssljson -bare ca

cfssl gencert \
  -ca=ca.pem \
  -ca-key=ca-key.pem \
  -config=ca-config.json \
  -profile=kubernetes \
  admin-csr.json | cfssljson -bare admin

#Generate Worker credentials
for instance in worker-3 worker-1 worker-2; do
INTERNAL_IP=$(az vm list-ip-addresses -g ${RESOURCE_GROUP} -n ${instance} --query "[].virtualMachine.network.privateIpAddresses[0]" -o tsv)

cfssl gencert \
  -ca=ca.pem \
  -ca-key=ca-key.pem \
  -config=ca-config.json \
  -hostname=${instance},${INTERNAL_IP} \
  -profile=kubernetes \
  ${instance}-csr.json | cfssljson -bare ${instance}
done

cfssl gencert \
  -ca=ca.pem \
  -ca-key=ca-key.pem \
  -config=ca-config.json \
  -profile=kubernetes \
  kube-controller-manager-csr.json | cfssljson -bare kube-controller-manager

cfssl gencert \
  -ca=ca.pem \
  -ca-key=ca-key.pem \
  -config=ca-config.json \
  -profile=kubernetes \
  kube-proxy-csr.json | cfssljson -bare kube-proxy

cfssl gencert \
  -ca=ca.pem \
  -ca-key=ca-key.pem \
  -config=ca-config.json \
  -profile=kubernetes \
  kube-scheduler-csr.json | cfssljson -bare kube-scheduler

CONTROLLER_IPS=$(az vm list -g kubernetesrg --query "[?contains(name,'worker')].vmId")
IFS=,

cfssl gencert \
  -ca=ca.pem \
  -ca-key=ca-key.pem \
  -config=ca-config.json \
  -hostname=10.32.0.1,$(printf "%s" "${CONTROLLER_IPS[*]}"),${KUBERNETES_PUBLIC_ADDRESS},127.0.0.1,${KUBERNETES_HOSTNAMES} \
  -profile=kubernetes \
  kubernetes-csr.json | cfssljson -bare kubernetes

cfssl gencert \
  -ca=ca.pem \
  -ca-key=ca-key.pem \
  -config=ca-config.json \
  -profile=kubernetes \
  service-account-csr.json | cfssljson -bare service-account

rm *.csr
