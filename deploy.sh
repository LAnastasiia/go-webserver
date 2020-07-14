#!/usr/bin/env bash

set -euo pipefail

key_dir="$(mktemp -d)"
./generate-keys.sh "$key_dir"

kubectl create secret tls webhook-server-tls \
    --cert "${key_dir}/tls.crt" \
    --key "${key_dir}/tls.key"

rm -rf "$key_dir"