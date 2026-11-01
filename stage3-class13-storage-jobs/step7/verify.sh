#!/usr/bin/env bash
set -euo pipefail
if kubectl get svc ledger-db >/dev/null 2>&1; then echo 'Service exists too early. Step 7 requires it to be missing; restart the temporary scenario to follow the failure chronology.'; exit 1; fi
f=$(kubectl get job ledger-setup -o jsonpath='{.status.failed}' 2>/dev/null || true)
[[ "$f" =~ ^[1-9][0-9]*$ ]] || { echo 'Wait until the one-time Job fails and inspect its logs.'; exit 1; }
[[ "$(kubectl get job ledger-setup -o jsonpath='{.spec.backoffLimit}' 2>/dev/null || true)" == 0 ]] || { echo 'This exercise expects the one-attempt Job from one-time-job.yaml.'; exit 1; }
logs=$(kubectl logs job/ledger-setup 2>/dev/null || true)
[[ "$logs" == *'Looking for ledger-db Service'* ]] || { echo 'Inspect the failed Job logs to confirm which endpoint it tried.'; exit 1; }
[[ "$logs" != *ONE_TIME_TASK_OK* ]] || { echo 'A missing Service should prevent a success marker.'; exit 1; }
echo 'PASS: Job failed because its Service dependency was not present.'
