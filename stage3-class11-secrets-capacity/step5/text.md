# 5 — ROTATION: Secret changes, but does the current process notice?

**Why:** External Secrets may refresh a Kubernetes Secret when AWS rotates its underlying credential. But a container with a Secret provided through **environment variables** receives those values only at startup. Updating the object alone doesn't replace the environment of an existing process.

**Mission:**

- Update your **local temporary file** `/root/demo-password.txt` to `FAKE_CLASS11_V2` (fake only).
- Update the **existing Kubernetes Secret** from that file, **without deleting the Deployment or restarting its Pod**.
- Inspect Kubernetes Secret metadata (not its value), then reason about the old running app.

**Prediction before CHECK:** will the current container's `DB_PASSWORD` be V1 or V2? Why? What would be different if the application read a mounted Secret volume rather than an env var?

**CHECK** verifies the Secret object contains fake V2 while the existing container still holds fake V1. This contrast is the entire learning goal. **Do not restart until Step 6.**

<details><summary>Hint 1 — declarative change to a Secret</summary>

You can use `kubectl create secret generic ... --from-file=... --dry-run=client -o yaml` to generate a new object definition, and pipe it to `kubectl apply -f -`. No actual external controller is involved.
</details>

<details><summary>Hint 2 — fake value only</summary>

```bash
printf '%s' 'FAKE_CLASS11_V2' > /root/demo-password.txt
kubectl create secret generic portfolio-credentials --from-file=DB_PASSWORD=/root/demo-password.txt --dry-run=client -o yaml | kubectl apply -f -
kubectl get secret portfolio-credentials
```
</details>
