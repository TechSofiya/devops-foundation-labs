#!/usr/bin/env bash
set -euo pipefail
f=/root/externalsecret-blueprint.yaml
[[ -f "$f" ]] || { echo 'Find the starter ExternalSecret blueprint in /root.'; exit 1; }
grep -Eq '^[[:space:]]*kind:[[:space:]]*ExternalSecret([[:space:]]*)$' "$f" || { echo 'The file should remain kind: ExternalSecret.'; exit 1; }
grep -Eq '^[[:space:]]*name:[[:space:]]*aws-secrets-manager([[:space:]]*)$' "$f" || { echo 'Trace the SecretStore reference (aws-secrets-manager).'; exit 1; }
grep -Eq '^[[:space:]]*refreshInterval:[[:space:]]*1h([[:space:]]*)$' "$f" || { echo 'Keep refreshInterval: 1h.'; exit 1; }
grep -Eq '^[[:space:]]*key:[[:space:]]*/training/foundation11/portfolio-app([[:space:]]*#.*)?$' "$f" || { echo 'Edit the fictional extract.key path to /training/foundation11/portfolio-app.'; exit 1; }
grep -A 2 '^[[:space:]]*target:' "$f" | grep -Eq '^[[:space:]]*name:[[:space:]]*portfolio-credentials([[:space:]]*)$' || { echo 'Target Kubernetes Secret name must remain portfolio-credentials.'; exit 1; }
[[ $(kubectl get externalsecrets --ignore-not-found -o name 2>/dev/null | wc -l) -eq 0 ]] || { echo 'Do not apply ExternalSecret objects here; this cluster has no configured ESO/AWS sync.'; exit 1; }
echo 'PASS: safe ExternalSecret BLUEPRINT mapping. This is a static check, not a real AWS/ESO synchronization.'
