#!/usr/bin/env bash

: "${1?'missing key directory'}"

key_dir="$1"

chmod 0700 "$key_dir"
cd "$key_dir" || exit

# Generate the CA cert and private key
openssl req -nodes -new -x509 -keyout ca.key -out ca.crt -subj "/CN=Admission Controller Webhook Demo CA"

# Generate the private key for the webhook server
openssl genrsa -out tls.key 2048

# Generate a Certificate Signing Request (CSR) for the private key, and sign it with the private key of the CA.
openssl req -new -key tls.key -subj "/CN=webhook-server.webhook-demo.svc" \
    | openssl x509 -req -CA ca.crt -CAkey ca.key -CAcreateserial -out tls.crt
