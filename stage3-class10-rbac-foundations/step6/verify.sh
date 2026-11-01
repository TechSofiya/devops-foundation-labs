#!/usr/bin/env bash
set -euo pipefail
resources=$(kubectl get role configmap-reader -o jsonpath='{range .rules[*]}{.resources[*]}{","}{end}' 2>/dev/null || true)
[[ "$resources" == 'configmaps,' ]] || { echo 'Role should cover only ConfigMaps.'; exit 1; }
verbs=$(kubectl get role configmap-reader -o jsonpath='{range .rules[*]}{.verbs[*]}{" "}{end}' 2>/dev/null || true)
for verb in get list watch; do
  [[ " $verbs " == *" $verb "* ]] || { echo "Role needs $verb permission on ConfigMaps."; exit 1; }
done
[[ $(wc -w <<< "$verbs") -eq 3 ]] || { echo 'Only get, list, and watch should be granted.'; exit 1; }
u=system:serviceaccount:foundation10:report-bot
[[ "$(kubectl auth can-i list configmaps --as="$u" 2>/dev/null || true)" == yes ]] || { echo 'Expected list configmaps to be allowed.'; exit 1; }
[[ "$(kubectl auth can-i watch configmaps --as="$u" 2>/dev/null || true)" == yes ]] || { echo 'Expected watch configmaps to be allowed.'; exit 1; }
[[ "$(kubectl auth can-i get secrets --as="$u" 2>/dev/null || true)" == no ]] || { echo 'Secret read must remain denied.'; exit 1; }
[[ "$(kubectl auth can-i delete pods --as="$u" 2>/dev/null || true)" == no ]] || { echo 'Pod deletion must remain denied.'; exit 1; }
[[ "$(kubectl auth can-i get configmaps --as="$u" -n default 2>/dev/null || true)" == no ]] || { echo 'RoleBinding should not give access to default namespace.'; exit 1; }
[[ "$(kubectl get configmap portfolio-settings --as="$u" -o jsonpath='{.data.CURRENCY}' 2>/dev/null || true)" == USD ]] || { echo 'Attempt an actual permitted ConfigMap read as report-bot.'; exit 1; }
err=$(kubectl get secret demo-db --as="$u" 2>&1 || true)
[[ "$err" == *Forbidden* ]] || { echo 'Expected a Forbidden response when report-bot attempts to read the Secret.'; exit 1; }
echo 'PASS: get/list/watch ConfigMaps allowed in foundation10; Secrets, writes and other namespaces denied.'
