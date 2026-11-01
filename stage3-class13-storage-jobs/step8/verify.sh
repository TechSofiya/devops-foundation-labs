#!/usr/bin/env bash
set -euo pipefail
[[ "$(kubectl get svc ledger-db -o jsonpath='{.spec.selector.app}' 2>/dev/null || true)" == ledger-app ]] || { echo 'Create Service ledger-db selecting app=ledger-app.'; exit 1; }
[[ "$(kubectl get svc ledger-db -o jsonpath='{.spec.ports[0].port}' 2>/dev/null || true)" == 8080 ]] || { echo 'The Service should expose HTTP on 8080.'; exit 1; }
[[ "$(kubectl get job ledger-setup -o jsonpath='{.status.succeeded}' 2>/dev/null || true)" == 1 ]] || { echo 'Recreate the failed Job AFTER the Service exists; wait for Complete.'; exit 1; }
logs=$(kubectl logs job/ledger-setup 2>/dev/null || true)
[[ "$logs" == *ONE_TIME_TASK_OK* ]] || { echo 'Job log should contain ONE_TIME_TASK_OK after a successful endpoint request.'; exit 1; }
echo 'PASS: Service repaired; newly created Job completed.'
