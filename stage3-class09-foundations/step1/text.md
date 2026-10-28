# Step 1 — Where will your kubectl commands go?

1. Check `kubectl config current-context` and `kubectl get nodes`.
2. Create a namespace named **foundation9**.
3. Set **foundation9** as your current context's **default namespace**.
4. Run a command to display the current namespace and another to list Pods. A new namespace starts with no application Pods.

**Predict:** Does creating a namespace create an application Pod?

**CHECK** verifies that foundation9 exists and is your default namespace.

<details><summary>Hint 1 — Commands to investigate</summary>

Try `kubectl create namespace --help` and `kubectl config set-context --help`.
</details>

<details><summary>Hint 2 — Syntax after attempting</summary>

`kubectl create namespace foundation9`

`kubectl config set-context --current --namespace=foundation9`

`kubectl config view --minify -o jsonpath='{..namespace}'; echo`
</details>
