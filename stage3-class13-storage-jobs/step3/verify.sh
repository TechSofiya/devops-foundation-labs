#!/usr/bin/env bash
set -euo pipefail
old=$(cat /root/ephemeral-before-uid.txt 2>/dev/null || true)
new=$(kubectl get pod transient-note -o jsonpath='{.metadata.uid}' 2>/dev/null || true)
[[ -n "$old" && -n "$new" && "$new" != "$old" ]] || { echo 'The Pod UID must change: delete and re-create transient-note.'; exit 1; }
kubectl exec transient-note -- sh -c 'test ! -e /tmp/trade-record.txt' >/dev/null 2>&1 || { echo 'The replacement should not contain the unmounted temporary file.'; exit 1; }
echo 'PASS: new Pod UID; no old file in the new container.'
