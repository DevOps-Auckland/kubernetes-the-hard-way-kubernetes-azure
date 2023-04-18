#!/bin/bash
cd ../certs/
rm ca-key.pem && rm ca.pem
for file in $(find -name "*key.pem" | sed -e "s/\.\///")
do
  CERT_NAME=$(echo ${file} | sed -e "s/-key//")
  NEW_NAME=kv-${CERT_NAME}
  echo "Creating combined certificate ${NEW_NAME}"
  touch ${NEW_NAME}
  cat ${CERT_NAME} > ${NEW_NAME}
  cat ${file} >> ${NEW_NAME}
done
