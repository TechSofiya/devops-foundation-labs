# 1 — Who are you, and where will your commands go?

**Why:** Kubernetes checks the identity, action, resource and namespace for every API request. A correct Role in the wrong namespace will not help your program.

**Your mission:**

- Examine `kubectl config current-context`, `kubectl get nodes` and `kubectl auth whoami` (where supported).
- Create a namespace named **foundation10**.
- Make it the **default namespace** for your current kubectl context. Inspect the selected namespace.
- Check that no application Pods were created simply by creating a namespace.

**Prediction:** Does creating a namespace grant a new ServiceAccount permission to read Secrets? Why not?

**CHECK** verifies the namespace exists and that kubectl is using it by default. No need to add `-n` for ordinary commands in this lab.

<details><summary>Hint 1 — Which commands?</summary>

Try `kubectl create namespace --help` and `kubectl config set-context --help`. Your context and default namespace are different concepts.
</details>

<details><summary>Hint 2 — Exact syntax, after attempting</summary>

```bash
kubectl create namespace foundation10
kubectl config set-context --current --namespace=foundation10
kubectl config view --minify -o jsonpath='{..namespace}'; echo
kubectl get pods
```
</details>
