#!/usr/bin/env bash
set -euo pipefail
p() { kubectl get deploy portfolio-app -o "jsonpath=$1" 2>/dev/null || true; }
[[ "$(p '{.spec.template.spec.containers[0].resources.requests.cpu}')" == 100m ]] || { echo 'CPU request must be 100m.'; exit 1; }
[[ "$(p '{.spec.template.spec.containers[0].resources.requests.memory}')" == 64Mi ]] || { echo 'Memory request must be 64Mi.'; exit 1; }
[[ "$(p '{.spec.template.spec.containers[0].resources.limits.cpu}')" == 250m ]] || { echo 'CPU limit must be 250m.'; exit 1; }
[[ "$(p '{.spec.template.spec.containers[0].resources.limits.memory}')" == 128Mi ]] || { echo 'Memory limit must be 128Mi.'; exit 1; }
[[ "$(p '{.status.availableReplicas}')" == 1 ]] || { echo 'Wait for the rollout; inspect any Pod scheduling or startup events.'; exit 1; }
echo 'PASS: Deployment specifies CPU/memory requests and limits and a Pod is available. Usage/throttling were not measured.'
