# 4 — CONSUMER: Which Pod process receives the value?

You now have **live objects**. The next step is to configure **a separate Deployment** to reference them. At container startup, Kubernetes provides the selected values as environment variables. The process does **not** read the original YAML file from GitHub.

**Mission:** edit `portfolio-app.yaml` below the container `command:`. Add:

- `envFrom` pointing to all keys in ConfigMap `portfolio-settings`.
- `env` with variable **DB_PASSWORD** from Secret `portfolio-credentials`, key **DB_PASSWORD**.
- Apply the Deployment and wait for it to become available. Confirm the **safe** `TICKER` value via an `exec` command. Avoid printing `DB_PASSWORD`.

**CHECK** verifies the live Deployment references and running Pod environment without exposing the password.

**Architecture challenge:** What does `kubectl exec` do differently from `kubectl get secret`? Which one queries the Kubernetes API object, and which one runs a process inside an already-running container?

<details><summary>Hint 1 — fields</summary>

`envFrom.configMapRef.name` and `env[].valueFrom.secretKeyRef` live inside the **container specification** next to `command:`. The ConfigMap and Secret files don't refer back to the Deployment.
</details>

<details><summary>Hint 2 — relevant YAML example</summary>

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

Try `kubectl apply -f portfolio-app.yaml`, `kubectl rollout status deploy/portfolio-app`, `kubectl exec deploy/portfolio-app -- printenv TICKER`.
</details>
