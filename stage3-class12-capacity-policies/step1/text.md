# Step 1 — Pick your isolated namespace

**Why:** You don't want a command meant for a temporary training team to change another namespace. The **context** identifies the cluster; the namespace identifies the resource scope within it.

1. Inspect the current cluster and nodes before changing state.
2. Create a namespace named **`foundation12`**.
3. Set it as the **default namespace** on your current context.
4. Verify the default namespace. Don't use `-n` for later commands.

**Predict:** Does creating a namespace automatically create an application Pod?

**CHECK** verifies the namespace exists and is the default for `kubectl`.

<details><summary>Hint 1 — Where to look</summary>

Inspect `kubectl config current-context`, `kubectl get nodes`, and `kubectl create namespace --help`.
</details>

<details><summary>Hint 2 — Command patterns</summary>

`kubectl create namespace foundation12` and `kubectl config set-context --current --namespace=foundation12`; inspect `kubectl config view --minify`.
</details>
