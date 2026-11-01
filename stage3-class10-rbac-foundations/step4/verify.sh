#!/usr/bin/env bash
set -euo pipefail
role_ns=$(kubectl get role configmap-reader -o jsonpath='{.metadata.namespace}' 2>/dev/null || true)
[[ "$role_ns" == foundation10 ]] || { echo 'Apply role.yaml to foundation10.'; exit 1; }
resources=$(kubectl get role configmap-reader -o jsonpath='{range .rules[*]}{.resources[*]}{","}{end}' 2>/dev/null || true)
verbs=$(kubectl get role configmap-reader -o jsonpath='{range .rules[*]}{.verbs[*]}{","}{end}' 2>/dev/null || true)
api=$(kubectl get role configmap-reader -o jsonpath='{.rules[0].apiGroups[0]}' 2>/dev/null || true)
[[ "$resources" == 'configmaps,' && "$verbs" == 'get,' && -z "$api" ]] || { echo 'Keep only core-group configmaps with exactly the get verb for now.'; exit 1; }
access=$(kubectl auth can-i get configmaps --as=system:serviceaccount:foundation10:report-bot 2>/dev/null || true)
[[ "$access" == no ]] || { echo 'The Role exists, but do not bind it to report-bot before Step 5.'; exit 1; }
echo 'PASS: Role describes a narrow rule but has not granted it to the ServiceAccount.'
