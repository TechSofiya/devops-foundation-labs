#!/usr/bin/env bash
set -euo pipefail
phase=$(kubectl get namespace foundation11 -o jsonpath='{.status.phase}' 2>/dev/null || true)
[[ "$phase" == Active ]] || { echo 'Create the foundation11 namespace first.'; exit 1; }
ns=$(kubectl config view --minify -o jsonpath='{..namespace}' 2>/dev/null || true)
[[ "$ns" == foundation11 ]] || { echo 'Make foundation11 the current context default namespace.'; exit 1; }
echo 'PASS: foundation11 is active and is your current default namespace.'
