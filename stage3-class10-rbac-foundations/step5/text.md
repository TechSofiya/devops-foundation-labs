# 5 — Connect the WHO to the WHAT

**Why:** A `RoleBinding` is the bridge between a set of permissions and an identity. `roleRef` points to the Role; `subjects` names the recipient. It grants those rights *only in the namespace of this RoleBinding*.

**Your mission:**

- Open `binding.yaml` and fill both TODO fields with **the exact live object names**, not filenames.
- Apply it and inspect the RoleBinding. Do not change `role.yaml` yet.
- Ask the API what `report-bot` can now do. It should be allowed to **get** one ConfigMap, **not list** all of them, and **not get** a Secret.

**Prediction:** Does the RoleBinding give `report-bot` access to Secrets because the Secret happens to live in the same namespace? Explain.

**CHECK** verifies the RoleBinding points to the intended Role and ServiceAccount and checks allowed/denied actions as that identity.

<details><summary>Hint 1 — Different kinds of `name`</summary>

`roleRef.name` matches the Role object's `metadata.name`. The `subjects[].name` matches the ServiceAccount's `metadata.name`. Neither is a YAML filename.
</details>

<details><summary>Hint 2 — Intended YAML references and evidence</summary>

```yaml
roleRef:
  apiGroup: rbac.authorization.k8s.io
  kind: Role
  name: configmap-reader
subjects:
  - kind: ServiceAccount
    name: report-bot
    namespace: foundation10
```

```bash
kubectl apply -f binding.yaml
kubectl get rolebinding report-bot-reads-config -o yaml
kubectl auth can-i get configmaps --as=system:serviceaccount:foundation10:report-bot
kubectl auth can-i list configmaps --as=system:serviceaccount:foundation10:report-bot
```
</details>
