# Step 1 — Where will these commands run?

You are on a disposable Killercoda VM, **not** your Mac or the school's EKS cluster. `kubectl` talks to this VM's temporary Kubernetes control plane.

**Your task:** create namespace `foundation13`, make it the default namespace of the current context, and use `kubectl get pods` to confirm you are querying the correct place. Before changing the context, inspect it.

**Predict:** Does naming a namespace change which cluster you connect to?

<details><summary>Hint 1 — Which two objects?</summary>

Create a Namespace resource; then change the **namespace setting of your current kubeconfig context**. They are different actions.
</details>

<details><summary>Hint 2 — After you try</summary>

`kubectl create namespace foundation13` then `kubectl config set-context --current --namespace=foundation13`. Verify with `kubectl config view --minify`.
</details>
