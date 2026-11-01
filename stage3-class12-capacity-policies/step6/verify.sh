#!/usr/bin/env bash
set -euo pipefail
hpa() { kubectl get hpa capacity-app-cpu -o "jsonpath=$1" 2>/dev/null || true; }
[[ "$(hpa '{.spec.scaleTargetRef.name}')" == capacity-app ]] || { echo 'Create HPA pointing to the capacity-app Deployment.'; exit 1; }
[[ "$(hpa '{.spec.minReplicas}')" == 1 ]] || { echo 'HPA minReplicas must be 1.'; exit 1; }
[[ "$(hpa '{.spec.maxReplicas}')" == 2 ]] || { echo 'HPA maxReplicas must be 2.'; exit 1; }
[[ "$(hpa '{.spec.metrics[0].resource.target.averageUtilization}')" == 60 ]] || { echo 'Set HPA CPU average utilization target to 60%.'; exit 1; }
[[ "$(hpa '{.spec.metrics[0].resource.name}')" == cpu ]] || { echo 'HPA should target CPU resource metrics.'; exit 1; }
[[ -f /root/hpa-reasoning.txt ]] || { echo 'Create hpa-reasoning.txt with four key/value explanations.'; exit 1; }
python3 - <<'PY2'
from pathlib import Path
lines=Path('/root/hpa-reasoning.txt').read_text().splitlines(); d={}
for line in lines:
 if ':' in line:
  k,v=line.split(':',1);d[k.strip()]=v.strip().lower()
expected={'utilization_percent':'200','hpa_scales':'pods','nodes_added_by_hpa':'no','quota_can_block_new_pods':'yes'}
for k,want in expected.items():
 if d.get(k)!=want: raise SystemExit(f'Reconsider {k} in hpa-reasoning.txt. Hint: 200m use / 100m request; HPA affects Pods, not machines or quota.')
PY2
echo 'PASS: correct HPA control-plane spec and CPU-utilization reasoning. No live metrics/scaling is implied.'
