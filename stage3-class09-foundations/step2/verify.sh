#!/usr/bin/env bash
set -euo pipefail
ns=$(kubectl get cm portfolio-settings -o jsonpath='{.metadata.namespace}' 2>/dev/null || true)
[[ "$ns" == foundation9 ]] || { echo 'Apply settings.yaml in your default foundation9 namespace.'; exit 1; }
for pair in 'APP_MODE:practice' 'DB_HOST:db' 'DB_PORT:5432' 'DB_USER:practice_user' 'TICKER:AAPL'; do
 key=${pair%%:*}; expected=${pair#*:}
 actual=$(kubectl get cm portfolio-settings -o "jsonpath={.data.$key}" 2>/dev/null || true)
 [[ "$actual" == "$expected" ]] || { echo "Check ConfigMap key $key (expected $expected)."; exit 1; }
done
echo 'PASS: five ConfigMap values are correct.'
