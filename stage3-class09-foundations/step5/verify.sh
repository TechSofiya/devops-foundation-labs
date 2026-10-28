#!/usr/bin/env bash
set -euo pipefail
value=$(kubectl get cm portfolio-settings -o jsonpath='{.data.TICKER}' 2>/dev/null || true)
[[ "$value" == MSFT ]] || { echo 'Change ConfigMap TICKER to MSFT and apply the file.'; exit 1; }
running=$(kubectl exec deploy/portfolio-app -- printenv TICKER 2>/dev/null || true)
[[ "$running" == AAPL ]] || { echo 'The contrast requires the original AAPL container. If it restarted already, restart the temporary lab and repeat steps 1–5.'; exit 1; }
echo 'PASS: ConfigMap=MSFT, old running container=AAPL.'
