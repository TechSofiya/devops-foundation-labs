#!/usr/bin/env bash
set -euo pipefail
node=$(kubectl get pod placement-test -o jsonpath='{.spec.nodeName}' 2>/dev/null || true)
[[ -z "$node" ]] || { echo 'placement-test should NOT be assigned to a node.'; exit 1; }
sel=$(kubectl get pod placement-test -o jsonpath='{.spec.nodeSelector.training\.invalid/fleet}' 2>/dev/null || true)
[[ "$sel" == a-node-that-does-not-exist ]] || { echo 'Apply the unchanged placement-test.yaml with its impossible nodeSelector.'; exit 1; }
cond=$(kubectl get pod placement-test -o 'jsonpath={.status.conditions[?(@.type=="PodScheduled")].status}' 2>/dev/null || true)
[[ "$cond" == False ]] || { echo "Wait for the scheduler, then describe placement-test. PodScheduled should be False (got '$cond')."; exit 1; }
msg=$(kubectl describe pod placement-test 2>/dev/null || true)
printf '%s' "$msg" | grep -Eqi 'FailedScheduling|didn.t match|node selector|node affinity' || { echo 'Find the scheduling/selector failure in Pod Events.'; exit 1; }
echo 'PASS: Pod exists, passed admission, but scheduler cannot match its placement rule.'
