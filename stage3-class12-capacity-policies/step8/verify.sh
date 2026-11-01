#!/usr/bin/env bash
set -euo pipefail
[[ "$(kubectl config view --minify -o jsonpath='{..namespace}' 2>/dev/null || true)" == foundation12 ]] || { echo 'Leave foundation12 as the active namespace for cleanup verification.'; exit 1; }
for resource in 'hpa/capacity-app-cpu' 'deploy/capacity-app' 'deploy/quota-blocked' 'pod/defaults-demo' 'pod/placement-test' 'pod/exceeds-container-max' 'resourcequota/team-budget' 'limitrange/team-container-rules'; do
 if kubectl get "$resource" >/dev/null 2>&1; then echo "Delete temporary lab resource $resource."; exit 1; fi
done
kubectl get namespace foundation12 >/dev/null 2>&1 || { echo 'Keep the foundation12 namespace until CHECK completes.'; exit 1; }
echo 'PASS: all named lab resources removed; temporary namespace remains isolated.'
