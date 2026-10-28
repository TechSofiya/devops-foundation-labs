# Step 3 — A Secret is a separate object

Inspect `/root/credentials.yaml`: the fake values are under `stringData`, and the two keys are DB_PASSWORD and API_KEY.

1. Confirm they are **demo values, not real passwords**.
2. Apply the local Secret YAML.
3. Use `get secret` and `describe secret` to see the type, key names and sizes **without printing the values**.
4. Explain why base64 encoding is not encryption.

**CHECK** verifies that `portfolio-credentials` exists with both expected keys. It never prints their values.

<details><summary>Hint 1</summary>

A Secret is not a container. Creating it does not create a Pod. `describe secret` shows keys and sizes but not values.
</details>
<details><summary>Hint 2 — Commands after attempting</summary>

`kubectl apply -f credentials.yaml`

`kubectl get secret portfolio-credentials`

`kubectl describe secret portfolio-credentials`
</details>
