# Certificates

These certs were generated based on the instructions from the Kubernetes the hardway page: [Provisioning a CA and Generating TLS Certificates](https://github.com/kelseyhightower/kubernetes-the-hard-way/blob/master/docs/04-certificate-authority.md#provisioning-a-ca-and-generating-tls-certificates).

## Certificate Authority

| File | Description |
|-------|----------|
| ca-config.json  | CA configuration file  |
| ca-csr.json | Signing certificate configuration file |
| ca-key.pem | This is the CA key. This would normally be kept secret because it is the key that is trusted by things like your browser. |
| ca.pem | This is the public key of the CA. This has been signed using the ca signing key. It must be placed in a browser, or other client, to trust certificates that are issued by the CA i.e. signed by the ca.csr |
| ca.csr | This is the CA signing key. It was issued by the CA key and is used to sign certificates. Certificates signed by this certificate will be trusted by clients that have ca.pem in their truststore |

## Admin Client Certificate
