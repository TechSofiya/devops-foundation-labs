# 3 — Who is `report-bot`?

**Why:** A *ServiceAccount* gives a program a Kubernetes identity. It does not start a Pod, and creating one does not grant read/write rights to your application objects.

**Your mission:**

- Read `serviceaccount.yaml`. Identify the `kind` and `metadata.name`.
- Apply it and inspect the live ServiceAccount.
- Ask whether `report-bot` may **get** ConfigMaps in this namespace. The full Kubernetes identity is `system:serviceaccount:foundation10:report-bot`.

**Prediction:** Should it be allowed to read `portfolio-settings` *before* a RoleBinding exists? Why?

**CHECK** verifies `report-bot` exists and still cannot read ConfigMaps or Secrets. This is deliberately a *no-permissions-yet* checkpoint.

<details><summary>Hint 1 — How to test a different identity?</summary>

Your admin kubeconfig can ask the API to check permissions *as* a ServiceAccount, using `kubectl auth can-i --as=...`. The flag changes the requested identity for that test; it is not changing the ServiceAccount itself.
</details>

<details><summary>Hint 2 — Exact syntax</summary>

```bash
kubectl apply -f serviceaccount.yaml
kubectl get serviceaccount report-bot
kubectl auth can-i get configmaps --as=system:serviceaccount:foundation10:report-bot
kubectl auth can-i get secrets --as=system:serviceaccount:foundation10:report-bot
```

Both permission questions should answer `no` at this point.
</details>
