#!/bin/bash
#This script accepts 1 parameter. The resource group where the workers are deployed.
RESOURCE_GROUP="$1"
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

INTERNAL_IP=$(az vm list-ip-addresses -g kubernetesrg -n worker-1 --query "[].virtualMachine.network.privateIpAddresses[0]" -o tsv)

cfssl gencert \
  -ca=ca.pem \
  -ca-key=ca-key.pem \
  -config=ca-config.json \
  -hostname=${instance},${INTERNAL_IP} \
  -profile=kubernetes \
  ${instance}-csr.json | cfssljson -bare ${instance}
done

rm *.csr
