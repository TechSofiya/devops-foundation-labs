#!/usr/bin/env bash
set -euo pipefail
old=$(cat /root/persistent-before-uid.txt 2>/dev/null || true)
new=$(kubectl get pod -l app=ledger-app -o jsonpath='{.items[0].metadata.uid}' 2>/dev/null || true)
[[ -n "$old" && -n "$new" && "$old" != "$new" ]] || { echo 'Delete the original ledger-app Pod and wait for a new UID.'; exit 1; }
[[ "$(kubectl get pvc ledger-data -o jsonpath='{.status.phase}' 2>/dev/null || true)" == Bound ]] || { echo 'Do not delete the claim; it must stay Bound.'; exit 1; }
[[ "$(kubectl exec deploy/ledger-app -- cat /records/trade-record.txt 2>/dev/null || true)" == 'BUY 150' ]] || { echo 'The replacement must read the same record from the mounted claim.'; exit 1; }
echo 'PASS: ReplicaSet replaced the Pod, while the mounted claim preserved the record.'
