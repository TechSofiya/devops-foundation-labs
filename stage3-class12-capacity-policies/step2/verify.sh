#!/usr/bin/env bash
set -euo pipefail
readp() { kubectl get deploy capacity-app -o "jsonpath=$1" 2>/dev/null || true; }
[[ "$(readp '{.spec.replicas}')" == 1 ]] || { echo 'Apply baseline-deployment.yaml (one replica).'; exit 1; }
[[ "$(readp '{.spec.template.spec.containers[0].name}')" == capacity-app ]] || { echo 'Check the named capacity-app container.'; exit 1; }
[[ "$(readp '{.spec.template.spec.containers[0].resources.requests.cpu}')" == '' ]] || { echo 'Do not patch yet; Step 2 inspects a baseline without requests.'; exit 1; }
[[ "$(readp '{.spec.template.spec.containers[0].resources.limits.cpu}')" == '' ]] || { echo 'Do not set limits yet; this is the initial object.'; exit 1; }
[[ -n "$(kubectl get rs -l app=capacity-app -o jsonpath='{.items[0].metadata.name}' 2>/dev/null || true)" ]] || { echo 'Wait for the Deployment controller to create a ReplicaSet.'; exit 1; }
echo 'PASS: Deployment and ReplicaSet exist; the live template has no explicit resources.'
