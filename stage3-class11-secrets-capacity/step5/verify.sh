#!/usr/bin/env bash
set -euo pipefail
value=$(kubectl get secret portfolio-credentials -o jsonpath='{.data.DB_PASSWORD}' 2>/dev/null || true)
[[ -n "$value" ]] || { echo 'Secret is missing.'; exit 1; }
[[ "$(printf '%s' "$value" | base64 -d 2>/dev/null || true)" == 'FAKE_CLASS11_V2' ]] || { echo 'Update live Secret to the fictional V2 value.'; exit 1; }
[[ "$(kubectl get deploy portfolio-app -o jsonpath='{.status.availableReplicas}' 2>/dev/null || true)" == 1 ]] || { echo 'Keep the old Deployment running for this comparison.'; exit 1; }
kubectl exec deploy/portfolio-app -- sh -c 'test "$DB_PASSWORD" = "FAKE_CLASS11_V1"' >/dev/null 2>&1 || { echo 'This checkpoint requires the OLD container with V1. If already restarted, relaunch this disposable lab.'; exit 1; }
echo 'PASS: Kubernetes Secret is V2; running container still has V1. Secret contents were not displayed.'
