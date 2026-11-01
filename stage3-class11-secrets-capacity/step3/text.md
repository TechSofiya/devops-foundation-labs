# 3 — STORAGE: Create a fictional Kubernetes Secret without checking in a password

In the school's AWS setup, ESO would have created a regular Secret. In this isolated lab we create the **Kubernetes Secret ourselves**, to practice what the workload sees *after* synchronization. This is a **local analogue**, not an ESO operation.

**Mission:**

- Apply `portfolio-settings.yaml`, which defines an ordinary ConfigMap.
- Generate a file *inside this temporary VM* containing only the text `FAKE_CLASS11_V1` (a deliberately fake classroom value) and use that file with `kubectl create secret generic portfolio-credentials --from-file=DB_PASSWORD=...`.
- Verify ConfigMap `portfolio-settings` and Secret `portfolio-credentials` exist. Inspect Secret *key names*, not its data values. **Never add the local password file to the GitHub scenario.**

**Connection:** your terminal sends the Secret definition to the Kubernetes API, which stores the Secret object. The future Deployment will **refer to the object by its metadata.name**, not read a file from your terminal.

**Prediction:** Will the ConfigMap and Secret alone start an application process?

**CHECK** verifies both live Kubernetes objects and the fictional Secret key without printing its value.

<details><summary>Hint 1 — safer than a password inside a YAML committed to Git</summary>

Use a temporary file: `printf '%s' ... > /root/demo-password.txt`; the literal used here is fictional. Use `--from-file=DB_PASSWORD=/root/demo-password.txt`. Remove the local file only after completing Step 5, when you will reuse it for the simulated rotation.
</details>

<details><summary>Hint 2 — complete example (fake value ONLY)</summary>

```bash
kubectl apply -f portfolio-settings.yaml
printf '%s' 'FAKE_CLASS11_V1' > /root/demo-password.txt
kubectl create secret generic portfolio-credentials --from-file=DB_PASSWORD=/root/demo-password.txt
kubectl describe secret portfolio-credentials
```
</details>
