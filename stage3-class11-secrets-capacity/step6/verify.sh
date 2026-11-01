#!/usr/bin/env bash
set -euo pipefail
[[ "$(kubectl get deploy portfolio-app -o jsonpath='{.status.availableReplicas}' 2>/dev/null || true)" == 1 ]] || { echo 'Wait for the replacement Pod to become available.'; exit 1; }
value=$(kubectl get secret portfolio-credentials -o jsonpath='{.data.DB_PASSWORD}' 2>/dev/null || true)
[[ "$(printf '%s' "$value" | base64 -d 2>/dev/null || true)" == 'FAKE_CLASS11_V2' ]] || { echo 'Secret must remain fictional V2.'; exit 1; }
kubectl exec deploy/portfolio-app -- sh -c 'test "$DB_PASSWORD" = "FAKE_CLASS11_V2"' >/dev/null 2>&1 || { echo 'Restart the Deployment to inject Secret V2 into a new container.'; exit 1; }
echo 'PASS: new Pod environment uses rotated value. This required a rollout, not an image rebuild.'
