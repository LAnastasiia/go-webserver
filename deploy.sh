#!/usr/bin/env bash

set -euo pipefail

key_dir="$(mktemp -d)"
./generate-keys.sh "$key_dir"

kubectl create secret tls tls-secret \
  --cert "${key_dir}/tls.crt" \
  --key "${key_dir}/tls.key"

rm -rf "$key_dir"

kubectl apply -f resources-compose.yaml