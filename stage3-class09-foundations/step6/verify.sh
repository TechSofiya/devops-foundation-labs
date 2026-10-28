#!/usr/bin/env bash
set -euo pipefail
[[ "$(kubectl get cm portfolio-settings -o jsonpath='{.data.TICKER}' 2>/dev/null || true)" == MSFT ]] || { echo 'ConfigMap should have TICKER=MSFT.'; exit 1; }
ready=$(kubectl get deploy portfolio-app -o jsonpath='{.status.availableReplicas}' 2>/dev/null || true)
[[ "$ready" == 1 ]] || { echo 'Wait for the new Pod to become available.'; exit 1; }
[[ "$(kubectl exec deploy/portfolio-app -- printenv TICKER 2>/dev/null || true)" == MSFT ]] || { echo 'Running container must show MSFT. Did you restart the Deployment?'; exit 1; }
echo 'PASS: new container=MSFT. No image rebuild was needed.'
