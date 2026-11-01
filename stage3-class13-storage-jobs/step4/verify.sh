#!/usr/bin/env bash
set -euo pipefail
phase=$(kubectl get pvc ledger-data -o jsonpath='{.status.phase}' 2>/dev/null || true)
[[ "$phase" == Bound ]] || { echo 'PVC ledger-data should be Bound; inspect describe pvc and describe pv.'; exit 1; }
pv=$(kubectl get pvc ledger-data -o jsonpath='{.spec.volumeName}' 2>/dev/null || true)
[[ "$pv" == foundation13-pv ]] || { echo 'Claim must bind specifically to foundation13-pv.'; exit 1; }
path=$(kubectl get pv foundation13-pv -o jsonpath='{.spec.hostPath.path}' 2>/dev/null || true)
[[ "$path" == /var/tmp/foundation13-ledger-data ]] || { echo 'Use the lab-only static hostPath PV.'; exit 1; }
[[ "$(kubectl get pv foundation13-pv -o jsonpath='{.spec.persistentVolumeReclaimPolicy}' 2>/dev/null || true)" == Retain ]] || { echo 'PV reclaim policy should be Retain.'; exit 1; }
echo 'PASS: namespace claim and cluster PV are Bound.'
