#!/usr/bin/env bash
set -euo pipefail
readpath() { kubectl get deploy portfolio-app -o "jsonpath=$1" 2>/dev/null || true; }
[[ "$(readpath '{.spec.template.spec.containers[0].envFrom[0].configMapRef.name}')" == portfolio-settings ]] || { echo 'Add envFrom referencing portfolio-settings.'; exit 1; }
[[ "$(readpath '{.spec.template.spec.containers[0].env[0].name}')" == DB_PASSWORD ]] || { echo 'Add env for DB_PASSWORD.'; exit 1; }
[[ "$(readpath '{.spec.template.spec.containers[0].env[0].valueFrom.secretKeyRef.name}')" == portfolio-credentials ]] || { echo 'Reference Secret portfolio-credentials.'; exit 1; }
[[ "$(readpath '{.spec.template.spec.containers[0].env[0].valueFrom.secretKeyRef.key}')" == DB_PASSWORD ]] || { echo 'Reference Secret key DB_PASSWORD.'; exit 1; }
ready=$(kubectl get deploy portfolio-app -o jsonpath='{.status.availableReplicas}' 2>/dev/null || true)
[[ "$ready" == 1 ]] || { echo 'Deployment is not available yet. Check rollout and Pod Events.'; exit 1; }
[[ "$(kubectl exec deploy/portfolio-app -- printenv TICKER 2>/dev/null || true)" == AAPL ]] || { echo 'Running container should have TICKER=AAPL.'; exit 1; }
kubectl exec deploy/portfolio-app -- sh -c 'test -n "$DB_PASSWORD"' >/dev/null 2>&1 || { echo 'Secret was not injected into the container.'; exit 1; }
echo 'PASS: Deployment references both objects; container has its settings.'
