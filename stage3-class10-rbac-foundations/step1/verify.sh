#!/usr/bin/env bash
set -euo pipefail
ns=$(kubectl get namespace foundation10 -o jsonpath='{.status.phase}' 2>/dev/null || true)
[[ "$ns" == Active ]] || { echo 'Create namespace foundation10 first.'; exit 1; }
current=$(kubectl config view --minify -o jsonpath='{..namespace}' 2>/dev/null || true)
[[ "$current" == foundation10 ]] || { echo 'Set the current context default namespace to foundation10.'; exit 1; }
echo 'PASS: foundation10 exists and is the current default namespace.'
