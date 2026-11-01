#!/usr/bin/env bash
set -euo pipefail
phase=$(kubectl get pod cannot-fit -o jsonpath='{.status.phase}' 2>/dev/null || true)
[[ "$phase" == Pending ]] || { echo 'Create scheduling-test.yaml and inspect why Pod cannot-fit is Pending.'; exit 1; }
node=$(kubectl get pod cannot-fit -o jsonpath='{.spec.nodeName}' 2>/dev/null || true)
[[ -z "$node" ]] || { echo 'This exercise expects an unscheduled Pod (no assigned node).'; exit 1; }
reason=$(kubectl get pod cannot-fit -o 'jsonpath={.status.conditions[?(@.type=="PodScheduled")].reason}' 2>/dev/null || true)
[[ "$reason" == Unschedulable ]] || { echo 'Scheduler condition not yet Unschedulable. Wait briefly, then inspect kubectl describe pod cannot-fit Events.'; exit 1; }
echo 'PASS: scheduler cannot place the Pod. The request must fit on ONE eligible node; no application process started.'
