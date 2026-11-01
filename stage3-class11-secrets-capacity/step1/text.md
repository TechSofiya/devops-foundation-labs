# 1 — WHERE: Which cluster and namespace?

Before a single resource change, identify the destination. Your terminal sends `kubectl` requests to the API server for the **current kubecontext**; a namespace scopes namespaced objects within that cluster.

**Mission:** inspect context and node; create namespace **foundation11**; make it the current context's **default namespace**; confirm it is selected. This is the temporary Killercoda cluster, *not* EKS.

**Prediction:** Will creating a namespace create Pods or change the AWS Secret Manager configuration? Explain why.

**CHECK** tests existence and default namespace.

<details><summary>Hint 1 — Where to look</summary>

Try `kubectl config current-context`, `kubectl get nodes`, `kubectl create namespace --help` and `kubectl config set-context --help`.
</details>

<details><summary>Hint 2 — Example commands</summary>

```bash
kubectl create namespace foundation11
kubectl config set-context --current --namespace=foundation11
kubectl config view --minify -o jsonpath='{..namespace}'; echo
```
</details>
