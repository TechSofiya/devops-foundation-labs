#!/usr/bin/env bash
set -euo pipefail
ns=$(kubectl get cm portfolio-settings -o jsonpath='{.metadata.namespace}' 2>/dev/null || true)
[[ "$ns" == foundation10 ]] || { echo 'Apply sample-objects.yaml in foundation10.'; exit 1; }
for pair in REPORT_NAME:practice-report CURRENCY:USD; do
  key=${pair%%:*}; expected=${pair#*:}
  actual=$(kubectl get cm portfolio-settings -o "jsonpath={.data.$key}" 2>/dev/null || true)
  [[ "$actual" == "$expected" ]] || { echo "ConfigMap $key should be $expected."; exit 1; }
done
secret_ns=$(kubectl get secret demo-db -o jsonpath='{.metadata.namespace}' 2>/dev/null || true)
[[ "$secret_ns" == foundation10 ]] || { echo 'Missing Secret demo-db in foundation10.'; exit 1; }
[[ "$(kubectl get secret demo-db -o jsonpath='{.type}' 2>/dev/null || true)" == Opaque ]] || { echo 'Secret demo-db should have type Opaque.'; exit 1; }
[[ -n "$(kubectl get secret demo-db -o jsonpath='{.data.DB_PASSWORD}' 2>/dev/null || true)" ]] || { echo 'Secret DB_PASSWORD key is missing.'; exit 1; }
echo 'PASS: ordinary ConfigMap values and fake Secret key exist; no Secret values shown.'
