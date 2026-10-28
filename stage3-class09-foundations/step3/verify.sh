#!/usr/bin/env bash
set -euo pipefail
type=$(kubectl get secret portfolio-credentials -o jsonpath='{.type}' 2>/dev/null || true)
[[ "$type" == Opaque ]] || { echo 'Create the Opaque Secret portfolio-credentials.'; exit 1; }
for k in DB_PASSWORD API_KEY; do
 val=$(kubectl get secret portfolio-credentials -o "jsonpath={.data.$k}" 2>/dev/null || true)
 [[ -n "$val" ]] || { echo "Missing Secret key $k."; exit 1; }
done
echo 'PASS: Secret exists with both keys. Values were not displayed.'
