# Step 2 — A YAML filename is not a Kubernetes object name

Go to `/root`. Inspect `settings.yaml` and find `kind`, `metadata.name`, and all five keys. Notice that `DB_PORT` is quoted because ConfigMap values are strings.

1. **Apply the file** to Kubernetes.
2. **Get the ConfigMap** by its live Kubernetes name, not its YAML filename.
3. **Describe** it and identify its five non-sensitive values.
4. Explain: which command reads a local file and which asks the Kubernetes API for a live object?

**CHECK** verifies `portfolio-settings` with TICKER=AAPL and the five required values.

<details><summary>Hint 1</summary>

`apply -f` takes a file path; `get cm` takes an object name from `metadata.name`.
</details>
<details><summary>Hint 2 — Commands after attempting</summary>

`kubectl apply -f settings.yaml`

`kubectl get cm portfolio-settings`

`kubectl describe cm portfolio-settings`
</details>
