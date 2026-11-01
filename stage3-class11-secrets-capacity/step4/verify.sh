#!/usr/bin/env bash
set -euo pipefail
readpath() { kubectl get deploy portfolio-app -o "jsonpath=$1" 2>/dev/null || true; }
[[ "$(readpath '{.spec.template.spec.containers[0].envFrom[0].configMapRef.name}')" == portfolio-settings ]] || { echo 'Add envFrom.configMapRef.name: portfolio-settings to your Deployment.'; exit 1; }
[[ "$(readpath '{.spec.template.spec.containers[0].env[0].name}')" == DB_PASSWORD ]] || { echo 'The container variable name must be DB_PASSWORD.'; exit 1; }
[[ "$(readpath '{.spec.template.spec.containers[0].env[0].valueFrom.secretKeyRef.name}')" == portfolio-credentials ]] || { echo 'Reference Kubernetes Secret portfolio-credentials.'; exit 1; }
[[ "$(readpath '{.spec.template.spec.containers[0].env[0].valueFrom.secretKeyRef.key}')" == DB_PASSWORD ]] || { echo 'Reference the Secret key DB_PASSWORD.'; exit 1; }
[[ "$(readpath '{.spec.replicas}')" == 1 ]] || { echo 'Keep 1 app replica for this isolated lab.'; exit 1; }
[[ "$(readpath '{.status.availableReplicas}')" == 1 ]] || { echo 'Wait for Deployment availability; check Pod Events and image pull.'; exit 1; }
[[ "$(kubectl exec deploy/portfolio-app -- printenv TICKER 2>/dev/null || true)" == AAPL ]] || { echo 'App must receive safe TICKER=AAPL from ConfigMap.'; exit 1; }
kubectl exec deploy/portfolio-app -- sh -c 'test "$DB_PASSWORD" = "FAKE_CLASS11_V1"' >/dev/null 2>&1 || { echo 'App must receive the ORIGINAL fake Secret value. Do not print its contents.'; exit 1; }
echo 'PASS: live Deployment references and running environment confirmed (without exposing Secret value).'
