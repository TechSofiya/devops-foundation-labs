# 4 — Write the WHAT: Role permissions

**Why:** A Kubernetes `Role` states *what operations* may be performed on *which API resources* in a namespace. It does **not** name the person or program receiving those rights.

**Your mission:**

- Read `role.yaml`. Find `apiGroups`, `resources`, and `verbs`.
- Explain in your own words: `get` **one named** ConfigMap vs `list` **all** ConfigMaps.
- Keep this first version deliberately narrow: **only `get` on `configmaps`**; do not add `secrets`, wildcards, `list`, or write actions yet.
- Apply `role.yaml` and inspect its rules. Check that `report-bot` still cannot read a ConfigMap yet.

**Prediction:** Why doesn't a Role automatically change what a ServiceAccount can do?

**CHECK** verifies the Role's exact narrow scope and confirms no access has been granted to `report-bot` yet.

<details><summary>Hint 1 — Inspect actual Role rules</summary>

Try `kubectl get role configmap-reader -o yaml` or `kubectl describe role configmap-reader`. Compare its YAML to the future RoleBinding, which assigns the rule to an identity.
</details>

<details><summary>Hint 2 — Apply and test</summary>

```bash
kubectl apply -f role.yaml
kubectl describe role configmap-reader
kubectl auth can-i get configmaps --as=system:serviceaccount:foundation10:report-bot
```
</details>
