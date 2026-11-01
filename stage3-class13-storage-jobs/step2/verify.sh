#!/usr/bin/env bash
set -euo pipefail
[[ -s /root/ephemeral-before-uid.txt ]] || { echo 'Record the initial Pod UID in /root/ephemeral-before-uid.txt.'; exit 1; }
u=$(kubectl get pod transient-note -o jsonpath='{.metadata.uid}' 2>/dev/null || true)
[[ -n "$u" && "$u" == "$(cat /root/ephemeral-before-uid.txt)" ]] || { echo 'The UID file must record the running transient-note Pod.'; exit 1; }
v=$(kubectl exec transient-note -- cat /tmp/trade-record.txt 2>/dev/null || true)
[[ "$v" == 'BUY 150' ]] || { echo 'Write BUY 150 into /tmp/trade-record.txt inside transient-note.'; exit 1; }
echo 'PASS: a file exists in the first Pod, and its UID was recorded.'
