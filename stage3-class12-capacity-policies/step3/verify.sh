#!/usr/bin/env bash
set -euo pipefail
readp() { kubectl get deploy capacity-app -o "jsonpath=$1" 2>/dev/null || true; }
for pair in 'requests.cpu:100m' 'requests.memory:128Mi' 'limits.cpu:250m' 'limits.memory:256Mi'; do
 p=${pair%%:*}; want=${pair#*:}
 got=$(readp "{.spec.template.spec.containers[0].resources.$p}")
 [[ "$got" == "$want" ]] || { echo "Live $p should be $want (got '$got'). Edit resources-patch.yaml and use kubectl patch."; exit 1; }
done
[[ "$(readp '{.spec.template.spec.containers[0].name}')" == capacity-app ]] || { echo 'Patch the named capacity-app container only.'; exit 1; }
if grep -Eq '^[[:space:]]+resources:' /root/baseline-deployment.yaml; then echo 'Keep the original baseline manifest without a resources field to observe drift.'; exit 1; fi
[[ -n "$(kubectl get rs -l app=capacity-app -o jsonpath='{.items[0].metadata.name}' 2>/dev/null || true)" ]] || { echo 'No ReplicaSet visible.'; exit 1; }
echo 'PASS: live resource declarations updated; original YAML still differs (drift).'
