#!/usr/bin/env bash

set -euo pipefail

key_dir="$(mktemp -d)"
./generate-keys.sh "$key_dir"

kubectl delete secret tls-secret || true
kubectl create secret tls tls-secret \
  --cert "${key_dir}/tls.crt" \
  --key "${key_dir}/tls.key"

rm -rf "$key_dir"

image_tag="${1:-'distroless'}"
echo "$image_tag"
sed -e 's@${image_tag}@'"$image_tag"'@g' <"./resources-compose.yaml.template" | kubectl apply -f -