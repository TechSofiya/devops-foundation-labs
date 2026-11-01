#!/usr/bin/env bash
set -euo pipefail
[[ -s /root/persistent-before-uid.txt ]] || { echo 'Save the ledger-app Pod UID in /root/persistent-before-uid.txt.'; exit 1; }
# Keep checks bounded: wait for rollout if kubelet is still mounting.
kubectl rollout status deploy/ledger-app --timeout=35s >/dev/null 2>&1 || { echo 'Deployment is not ready. Check PVC and Pod Events.'; exit 1; }
c=$(kubectl get deploy ledger-app -o jsonpath='{.spec.template.spec.containers[0].volumeMounts[0].name}' 2>/dev/null || true)
p=$(kubectl get deploy ledger-app -o jsonpath='{.spec.template.spec.containers[0].volumeMounts[0].mountPath}' 2>/dev/null || true)
v=$(kubectl get deploy ledger-app -o jsonpath='{.spec.template.spec.volumes[0].name}' 2>/dev/null || true)
claim=$(kubectl get deploy ledger-app -o jsonpath='{.spec.template.spec.volumes[0].persistentVolumeClaim.claimName}' 2>/dev/null || true)
[[ -n "$c" && "$c" == "$v" && "$p" == /records && "$claim" == ledger-data ]] || { echo 'Fix volumeMounts.name, volumes.name, mountPath and claimName.'; exit 1; }
uid=$(kubectl get pod -l app=ledger-app -o jsonpath='{.items[0].metadata.uid}' 2>/dev/null || true)
[[ -n "$uid" && "$uid" == "$(cat /root/persistent-before-uid.txt)" ]] || { echo 'The UID file should record the currently running ledger Pod.'; exit 1; }
[[ "$(kubectl exec deploy/ledger-app -- cat /records/trade-record.txt 2>/dev/null || true)" == 'BUY 150' ]] || { echo 'Write BUY 150 to the mounted /records/trade-record.txt.'; exit 1; }
echo 'PASS: PVC mounted, record saved, Pod UID captured.'
