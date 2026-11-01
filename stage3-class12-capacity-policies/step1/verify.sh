#!/usr/bin/env bash
set -euo pipefail
phase=$(kubectl get namespace foundation12 -o jsonpath='{.status.phase}' 2>/dev/null || true)
[[ "$phase" == Active ]] || { echo 'Create namespace foundation12.'; exit 1; }
current=$(kubectl config view --minify -o jsonpath='{..namespace}' 2>/dev/null || true)
[[ "$current" == foundation12 ]] || { echo 'Set foundation12 as your current-context default namespace.'; exit 1; }
echo 'PASS: disposable namespace is active and default.'
