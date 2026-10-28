#!/usr/bin/env bash
set -euo pipefail
phase=$(kubectl get namespace foundation9 -o jsonpath='{.status.phase}' 2>/dev/null || true)
[[ "$phase" == "Active" ]] || { echo 'Create the foundation9 namespace first.'; exit 1; }
current=$(kubectl config view --minify -o jsonpath='{..namespace}' 2>/dev/null || true)
[[ "$current" == "foundation9" ]] || { echo 'Set your current context default namespace to foundation9.'; exit 1; }
echo 'PASS: namespace exists and kubectl uses it by default.'
