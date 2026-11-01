#!/usr/bin/env bash
set -euo pipefail
[[ "$(kubectl get sa audit-agent -o jsonpath='{.metadata.namespace}' 2>/dev/null || true)" == foundation10 ]] || { echo 'Apply auditor.yaml to create audit-agent.'; exit 1; }
read_binding() { kubectl get rolebinding audit-agent-view -o "jsonpath=$1" 2>/dev/null || true; }
[[ "$(read_binding '{.metadata.namespace}')" == foundation10 ]] || { echo 'Create RoleBinding audit-agent-view in foundation10.'; exit 1; }
[[ "$(read_binding '{.roleRef.kind}')" == ClusterRole && "$(read_binding '{.roleRef.name}')" == view ]] || { echo 'roleRef should reference ClusterRole view (not Role or ClusterRoleBinding).'; exit 1; }
[[ "$(read_binding '{.subjects[0].kind}')" == ServiceAccount && "$(read_binding '{.subjects[0].name}')" == audit-agent && "$(read_binding '{.subjects[0].namespace}')" == foundation10 ]] || { echo 'Bind the ServiceAccount audit-agent in foundation10.'; exit 1; }
u=system:serviceaccount:foundation10:audit-agent
[[ "$(kubectl auth can-i list pods --as="$u" 2>/dev/null || true)" == yes ]] || { echo 'audit-agent should be able to list Pods in foundation10.'; exit 1; }
[[ "$(kubectl auth can-i create pods --as="$u" 2>/dev/null || true)" == no ]] || { echo 'audit-agent must not create Pods.'; exit 1; }
[[ "$(kubectl auth can-i get secrets --as="$u" 2>/dev/null || true)" == no ]] || { echo 'audit-agent must not read Secrets.'; exit 1; }
[[ "$(kubectl auth can-i list pods --as="$u" -n default 2>/dev/null || true)" == no ]] || { echo 'Do not grant audit-agent access to the default namespace.'; exit 1; }
echo 'PASS: auditor is read-only in foundation10 via ClusterRole view + namespace RoleBinding.'
