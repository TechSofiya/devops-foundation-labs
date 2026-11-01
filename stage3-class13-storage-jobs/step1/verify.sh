#!/usr/bin/env bash
set -euo pipefail
[[ "$(kubectl get ns foundation13 -o jsonpath='{.status.phase}' 2>/dev/null || true)" == Active ]] || { echo 'Namespace foundation13 is not Active.'; exit 1; }
[[ "$(kubectl config view --minify -o jsonpath='{..namespace}' 2>/dev/null || true)" == foundation13 ]] || { echo 'Set the current context default namespace to foundation13.'; exit 1; }
echo 'PASS: your kubectl context defaults to foundation13.'
