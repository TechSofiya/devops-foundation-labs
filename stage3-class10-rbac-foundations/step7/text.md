# 7 — A read-only auditor: RoleBinding to a ClusterRole

**Why:** In Class 10 the instructor used a separate read-only identity for an AI assistant: it should investigate without being able to change the system or read passwords. Kubernetes provides a built-in **ClusterRole** called `view`. A **RoleBinding** to that ClusterRole grants its rules only in the RoleBinding's namespace.

**Your mission:**

- Open `auditor.yaml`. It defines a new ServiceAccount `audit-agent` plus a RoleBinding `audit-agent-view`.
- Fill both TODOs in the RoleBinding: `roleRef.kind` and `roleRef.name`. The desired role is the existing built-in ClusterRole `view`—you are **not creating it**.
- Apply the file and prove that the auditor can list Pods in **foundation10**, but cannot create Pods, read Secrets or list Pods in the **default** namespace.
- Explain how this is different from a `ClusterRoleBinding`, and why an AI agent should not inherit your administrator credentials.

**CHECK** confirms the binding is namespace-scoped, references built-in `view`, and enforces the expected yes/no results.

**Important boundary:** This exercises Kubernetes RBAC with impersonation on the temporary cluster. It is not an actual AWS SSO identity or securely isolated `KUBECONFIG` for a real agent. Those require separate environment configuration and verification.

<details><summary>Hint 1 — What controls scope?</summary>

The *RoleBinding's namespace* determines scope even when `roleRef.kind` is `ClusterRole`. `ClusterRoleBinding` would apply the referenced ClusterRole across the cluster; you do not need that here.
</details>

<details><summary>Hint 2 — Exact references and evidence</summary>

```yaml
roleRef:
  apiGroup: rbac.authorization.k8s.io
  kind: ClusterRole
  name: view
```

```bash
kubectl apply -f auditor.yaml
kubectl auth can-i list pods --as=system:serviceaccount:foundation10:audit-agent
kubectl auth can-i create pods --as=system:serviceaccount:foundation10:audit-agent
kubectl auth can-i get secrets --as=system:serviceaccount:foundation10:audit-agent
kubectl auth can-i list pods --as=system:serviceaccount:foundation10:audit-agent -n default
```

Expected answers: **yes, no, no, no**.
</details>
