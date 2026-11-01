#!/usr/bin/env bash
set -euo pipefail
[[ "$(kubectl get sa report-bot -o jsonpath='{.metadata.namespace}' 2>/dev/null || true)" == foundation10 ]] || { echo 'Create ServiceAccount report-bot in foundation10.'; exit 1; }
as_user=system:serviceaccount:foundation10:report-bot
get=$(kubectl auth can-i get configmaps --as="$as_user" 2>/dev/null || true)
[[ "$get" == no ]] || { echo 'report-bot should not have ConfigMap access before a RoleBinding. Check whether you already applied a binding.'; exit 1; }
secret=$(kubectl auth can-i get secrets --as="$as_user" 2>/dev/null || true)
[[ "$secret" == no ]] || { echo 'report-bot must not be able to read Secrets.'; exit 1; }
echo 'PASS: ServiceAccount exists but has no ConfigMap/Secret permissions yet.'
