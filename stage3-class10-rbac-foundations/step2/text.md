# 2 — Create normal settings and a fake password

**Why:** The permissions you will grant need actual objects to protect. A ConfigMap is a live Kubernetes object, not the YAML file used to create it. A Secret is also a live object, and `stringData` in a training manifest is plaintext input—not encryption.

**Your mission:**

- Open `sample-objects.yaml`. It defines **two objects**, separated by `---`: ConfigMap `portfolio-settings` and Secret `demo-db`.
- Explain which program might need `CURRENCY` and why a reporting identity should not need `DB_PASSWORD`.
- Apply the file into **foundation10** and inspect the two object *names and keys*, without printing the fake password value.

**Prediction:** If `kubectl apply -f sample-objects.yaml` succeeds, has any program started? What did the API server create?

**CHECK** verifies the two separate live objects and their expected key names. It deliberately never prints a Secret value.

<details><summary>Hint 1 — Source file vs live object</summary>

`kubectl apply -f ...` sends definitions to the API server. `kubectl get configmap` and `kubectl get secret` query objects already stored in Kubernetes. `kubectl describe secret demo-db` displays keys/lengths without revealing the values.
</details>

<details><summary>Hint 2 — Suggested commands</summary>

```bash
kubectl apply -f sample-objects.yaml
kubectl get configmaps
kubectl get secrets
kubectl describe secret demo-db
```
</details>
