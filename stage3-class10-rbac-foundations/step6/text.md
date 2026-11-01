# 6 — Read a Forbidden error and expand only the required read permissions

**Why:** A service that enumerates settings needs `list` rather than just `get`. RBAC is **additive allow rules**: extra rights should only be granted for a reason. `watch` follows future changes, but it is *not* the same verb as `get` or `list`.

**Your mission:**

1. Try listing ConfigMaps as `report-bot`. Observe the expected **Forbidden** error (the identity is known, but `list` is not authorized).
2. In `role.yaml` change **only** the verbs to `get`, `list`, `watch`; do not add Secrets, Pod deletion, `*`, or anything else.
3. Re-apply the Role, then test that `report-bot` can list ConfigMaps and read the ordinary `portfolio-settings` object.
4. Attempt to **get** Secret `demo-db` as `report-bot`. It must still be **Forbidden**. Do not decode or print any password.
5. Ask if `report-bot` can read ConfigMaps in the **default** namespace, to test the binding boundary. You aren't changing anything there.

**Prediction:** Why does changing a Role's rule take effect without recreating the ServiceAccount? And why is a Forbidden denial useful evidence here?

**CHECK** confirms the precise Role verbs, valid read access, denied Secret access, and a namespace boundary. It does not show any Secret values.

<details><summary>Hint 1 — Which error and why?</summary>

Read `kubectl auth can-i list configmaps --as=...` before editing. The `kubectl get configmaps --as=...` request requires `list`; `kubectl get configmap portfolio-settings --as=...` requires `get`.
</details>

<details><summary>Hint 2 — Syntax and safe verification</summary>

Update `verbs: ["get", "list", "watch"]`, then:

```bash
kubectl apply -f role.yaml
kubectl get configmaps --as=system:serviceaccount:foundation10:report-bot
kubectl get configmap portfolio-settings --as=system:serviceaccount:foundation10:report-bot
kubectl get secret demo-db --as=system:serviceaccount:foundation10:report-bot
kubectl auth can-i get configmaps --as=system:serviceaccount:foundation10:report-bot -n default
```

The Secret `get` should return an error and that's **expected success for the security boundary**.
</details>
