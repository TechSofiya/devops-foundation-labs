# Step 6 — Roll out fresh Pods to pick up configuration

You've proved the stored object and running process can have different values.

1. Trigger a **rolling restart** of the `portfolio-app` Deployment.
2. Wait for it to complete, inspect the new Pod and read *only* `TICKER` inside the container.
3. Explain why you did **not** need a new Docker image.

**CHECK** verifies the app is available and a fresh container has **TICKER=MSFT**.

<details><summary>Hint 1</summary>

The Deployment controls Pods. A rolling restart asks it to replace Pods; the newly starting containers receive the current ConfigMap values.
</details>
<details><summary>Hint 2 — Syntax after attempting</summary>

`kubectl rollout restart deploy/portfolio-app`

`kubectl rollout status deploy/portfolio-app`

`kubectl get pods -l app=portfolio-app`

`kubectl exec deploy/portfolio-app -- printenv TICKER`
</details>
