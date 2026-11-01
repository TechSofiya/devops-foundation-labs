#!/usr/bin/env bash
set -euo pipefail
readp() { kubectl get limitrange team-container-rules -o "jsonpath=$1" 2>/dev/null || true; }
for pair in 'defaultRequest.cpu:50m' 'defaultRequest.memory:64Mi' 'default.cpu:250m' 'default.memory:256Mi' 'max.cpu:1' 'max.memory:1Gi'; do
 field=${pair%%:*}; want=${pair#*:}; got=$(readp "{.spec.limits[0].$field}")
 [[ "$got" == "$want" ]] || { echo "LimitRange $field should be $want (got '$got')."; exit 1; }
done
pval() { kubectl get pod defaults-demo -o "jsonpath=$1" 2>/dev/null || true; }
for pair in 'requests.cpu:50m' 'requests.memory:64Mi' 'limits.cpu:250m' 'limits.memory:256Mi'; do
 field=${pair%%:*}; want=${pair#*:}
 [[ "$(pval "{.spec.containers[0].resources.$field}")" == "$want" ]] || { echo "defaults-demo admission should fill $field with $want."; exit 1; }
done
[[ -f /root/limit-error.txt ]] || { echo 'Capture the rejected over-max attempt as limit-error.txt.'; exit 1; }
grep -qi 'maximum' /root/limit-error.txt && grep -qi 'cpu' /root/limit-error.txt || { echo 'Inspect the rejection: it should mention a CPU maximum. Capture stderr and stdout.'; exit 1; }
if kubectl get pod exceeds-container-max >/dev/null 2>&1; then echo 'Over-max Pod must not be admitted.'; exit 1; fi
echo 'PASS: defaults were injected at admission, and an over-max CPU limit was rejected.'
