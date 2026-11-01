#!/usr/bin/env bash
set -euo pipefail
readp() { kubectl get resourcequota team-budget -o "jsonpath=$1" 2>/dev/null || true; }
for pair in 'requests.cpu:500m' 'requests.memory:1Gi' 'limits.cpu:2' 'limits.memory:2Gi' 'pods:8'; do
 field=${pair%%:*}; want=${pair#*:}
 escaped=${field//./\\.}
 got=$(readp "{.spec.hard.$escaped}")
 [[ "$got" == "$want" ]] || { echo "ResourceQuota $field expected $want, got '$got'."; exit 1; }
done
kubectl get deploy quota-blocked >/dev/null 2>&1 || { echo 'Apply quota-blocked.yaml; Deployment should be created.'; exit 1; }
[[ -n "$(kubectl get rs -l app=quota-blocked -o jsonpath='{.items[0].metadata.name}' 2>/dev/null || true)" ]] || { echo 'Wait for the quota-blocked ReplicaSet.'; exit 1; }
count=$(kubectl get pods -l app=quota-blocked -o jsonpath='{range .items[*]}x{end}' 2>/dev/null || true)
[[ -z "$count" ]] || { echo 'There should be no quota-blocked Pod: the admission layer refuses creation.'; exit 1; }
evidence=$(kubectl describe rs -l app=quota-blocked 2>/dev/null || true)
printf '%s' "$evidence" | grep -qi 'exceeded quota' || { echo 'ReplicaSet events should show FailedCreate: exceeded quota. Wait briefly, then inspect kubectl describe rs.'; exit 1; }
printf '%s' "$evidence" | grep -qi 'FailedCreate' || { echo 'Look for the FailedCreate event on the ReplicaSet.'; exit 1; }
echo 'PASS: namespace quota refused Pod creation; Deployment/ReplicaSet exist and explain the failure.'
