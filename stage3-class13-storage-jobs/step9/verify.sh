#!/usr/bin/env bash
set -euo pipefail
[[ "$(kubectl get cronjob nightly-ledger -o jsonpath='{.spec.schedule}' 2>/dev/null || true)" == '0 2 * * *' ]] || { echo 'Create nightly-ledger with the supplied daily schedule.'; exit 1; }
[[ "$(kubectl get cronjob nightly-ledger -o jsonpath='{.spec.suspend}' 2>/dev/null || true)" == true ]] || { echo 'Keep the CronJob suspended; do not schedule uncontrolled Jobs.'; exit 1; }
[[ "$(kubectl get job manual-nightly -o jsonpath='{.status.succeeded}' 2>/dev/null || true)" == 1 ]] || { echo 'Create a one-off Job from the CronJob and wait for Complete.'; exit 1; }
logs=$(kubectl logs job/manual-nightly 2>/dev/null || true)
[[ "$logs" == *NIGHTLY_TASK_OK* ]] || { echo 'Manual Job should print NIGHTLY_TASK_OK.'; exit 1; }
echo 'PASS: suspended CronJob template spawned a manually completed one-off Job.'
