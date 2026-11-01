#!/usr/bin/env bash
set -euo pipefail
[[ "$(kubectl get cm portfolio-settings -o jsonpath='{.data.TICKER}' 2>/dev/null || true)" == 'AAPL' ]] || { echo 'Apply portfolio-settings.yaml; check TICKER=AAPL.'; exit 1; }
[[ "$(kubectl get cm portfolio-settings -o jsonpath='{.metadata.namespace}' 2>/dev/null || true)" == foundation11 ]] || { echo 'ConfigMap must live in namespace foundation11.'; exit 1; }
secret_type=$(kubectl get secret portfolio-credentials -o jsonpath='{.type}' 2>/dev/null || true)
[[ "$secret_type" == Opaque ]] || { echo 'Create Opaque Secret portfolio-credentials.'; exit 1; }
value=$(kubectl get secret portfolio-credentials -o jsonpath='{.data.DB_PASSWORD}' 2>/dev/null || true)
[[ -n "$value" ]] || { echo 'Secret must have DB_PASSWORD key.'; exit 1; }
[[ "$(printf '%s' "$value" | base64 -d 2>/dev/null || true)" == 'FAKE_CLASS11_V1' ]] || { echo 'Use the fictional initial value FAKE_CLASS11_V1 (not a real credential).'; exit 1; }
echo 'PASS: ordinary settings and fictional Secret exist in Kubernetes. The value was not printed.'
