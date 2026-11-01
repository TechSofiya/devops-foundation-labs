# Step 5 — A team budget is **not** the same as a container maximum

Open **`resourcequota.yaml`** and edit the team totals to:

- CPU requests: `500m`; memory requests: `1Gi`.
- CPU limits: `2` cores; memory limits: `2Gi`.
- Pod count: `8`.

Apply the ResourceQuota; inspect **Used** versus **Hard**. The already-running `capacity-app` requests `100m`; `defaults-demo` has `50m` from the LimitRange. So this small team is below its 500m request budget.

Now apply **`quota-blocked.yaml`**. Its container requests **600m CPU** (within the one-core LimitRange maximum) but **more than the entire namespace quota**. Inspect what exists: Deployment? ReplicaSet? Pod?

**Troubleshooting challenge:** don't invent a Pod name if there is no Pod. Find the **FailedCreate** message on the controller that attempted Pod creation.

**CHECK** verifies the configured quota, live rejected Deployment + ReplicaSet, **zero matching Pods**, and the ReplicaSet's `exceeded quota` evidence.

<details><summary>Hint 1</summary>

Try `kubectl get deploy,rs,pods -l app=quota-blocked`, `kubectl describe rs -l app=quota-blocked`, and `kubectl describe resourcequota team-budget`.
</details>

<details><summary>Hint 2 — Why a new node cannot help</summary>

The API **admission** layer refuses the Pod before the scheduler can place it. More EC2 nodes might fix insufficient node capacity, but they cannot raise this namespace's quota.
</details>
