# Step 4 — How does a Pod receive the values?

Inspect `deployment.yaml` and look for two TODO comments under the container.

**Edit the local Deployment:**

1. Add `envFrom` referencing **ConfigMap `portfolio-settings`** (all five keys).
2. Add `env` with one variable named **DB_PASSWORD**, sourced via `valueFrom.secretKeyRef` from **Secret `portfolio-credentials`**, key **DB_PASSWORD**.
3. Apply the Deployment, inspect Pods and wait for the rollout.
4. Run a command *inside* the container to show **only** the safe variable TICKER. It should be `AAPL`.

**CHECK** inspects the live Deployment references, an available Pod and its safe runtime value. It verifies the Secret variable exists **without displaying its contents**.

<details><summary>Hint 1</summary>

The `envFrom:` and `env:` sections go at the same indentation as `ports:` inside the container. If the container fails, inspect `kubectl describe pod` Events and `kubectl logs`.
</details>
<details><summary>Hint 2 — YAML structure after attempting</summary>

```yaml
envFrom:
  - configMapRef:
      name: portfolio-settings
env:
  - name: DB_PASSWORD
    valueFrom:
      secretKeyRef:
        name: portfolio-credentials
        key: DB_PASSWORD
```

Then try `kubectl apply -f deployment.yaml`, `kubectl rollout status deploy/portfolio-app` and `kubectl exec deploy/portfolio-app -- printenv TICKER`.
</details>
