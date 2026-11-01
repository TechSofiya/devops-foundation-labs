#!/usr/bin/env bash
set -euo pipefail
read_binding() { kubectl get rolebinding report-bot-reads-config -o "jsonpath=$1" 2>/dev/null || true; }
[[ "$(read_binding '{.metadata.namespace}')" == foundation10 ]] || { echo 'Apply binding.yaml in foundation10.'; exit 1; }
[[ "$(read_binding '{.roleRef.kind}')" == Role && "$(read_binding '{.roleRef.name}')" == configmap-reader ]] || { echo 'roleRef must point to Role configmap-reader.'; exit 1; }
[[ "$(read_binding '{.subjects[0].kind}')" == ServiceAccount && "$(read_binding '{.subjects[0].name}')" == report-bot && "$(read_binding '{.subjects[0].namespace}')" == foundation10 ]] || { echo 'subjects must name ServiceAccount report-bot in foundation10.'; exit 1; }
u=system:serviceaccount:foundation10:report-bot
[[ "$(kubectl auth can-i get configmaps --as="$u" 2>/dev/null || true)" == yes ]] || { echo 'report-bot should now GET ConfigMaps. Check the Role and binding.'; exit 1; }
[[ "$(kubectl auth can-i list configmaps --as="$u" 2>/dev/null || true)" == no ]] || { echo 'GET is allowed; LIST should still be denied. Leave the verbs for Step 6.'; exit 1; }
[[ "$(kubectl auth can-i get secrets --as="$u" 2>/dev/null || true)" == no ]] || { echo 'report-bot must not receive Secret permissions.'; exit 1; }
echo 'PASS: the binding grants GET ConfigMaps, not LIST ConfigMaps or GET Secrets.'
