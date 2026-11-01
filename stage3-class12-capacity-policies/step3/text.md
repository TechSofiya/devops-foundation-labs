# Step 3 — Change a live Deployment with `kubectl patch`

The team wants trial **requests** of `100m` CPU and `128Mi` memory and **limits** of `250m` CPU and `256Mi` memory for its one container.

1. Open **`resources-patch.yaml`**, inspect the strategic-merge path, and edit the FOUR trial numbers.
2. Apply this **patch to the named Deployment**, not with `kubectl apply -f`.
3. Inspect the live Deployment's resources and confirm its rollout. Observe what happened to the Pod template and ReplicaSet.
4. Compare `/root/baseline-deployment.yaml` with the live values. **Do not fix the old file yet**; the difference is the point.

**WHY:** the API server updates the live Deployment; a Pod-template change causes a new ReplicaSet/Pod. Your local Git-tracked manifest is not edited by `kubectl patch`.

**CHECK** requires the live four values and that the local starter manifest still has no resources (a drift experiment).

<details><summary>Hint 1</summary>

The command has the form `kubectl patch deployment NAME --type=strategic --patch-file FILE`. Look at the `containers` list item named `capacity-app`.
</details>

<details><summary>Hint 2 — Syntax</summary>

`kubectl patch deployment capacity-app --type=strategic --patch-file resources-patch.yaml` followed by `kubectl rollout status deploy/capacity-app --timeout=120s`.
</details>
