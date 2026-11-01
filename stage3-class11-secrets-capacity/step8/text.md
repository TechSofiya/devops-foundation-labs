# 8 — SCHEDULER: Why is this Pod Pending?

**WHY:** Kubernetes chooses a *single* node for each Pod. If a Pod's CPU/memory request won't fit on any eligible node, the scheduler cannot assign it. This is a different failure layer from image pulling, application crashes, or memory OOM kills.

**Mission:**

- Inspect `scheduling-test.yaml`. The deliberately unrealistic request is **1000 CPU cores**. This is an isolated training Pod; don't change it to a realistic value yet.
- Predict the phase, `spec.nodeName`, and what `kubectl describe pod` Events will say.
- Apply the Pod, inspect the **live** phase, PodScheduled condition, scheduler Events, and node allocatable capacity. Do **not** scale the cluster to satisfy the request.
- Press CHECK only when you have evidence it cannot be scheduled. Then delete `cannot-fit` as cleanup.

**Explain out loud:** Would adding a second node of the same size necessarily fix this? Why not? Is `Pending` the same as `OOMKilled`? What decides placement, and what enforces a memory limit?

**CHECK** requires actual `Pending` and an `Unschedulable` scheduling condition, not just a YAML file.

<details><summary>Hint 1 — choose the evidence layer</summary>

The scheduler, not the application log, owns this decision. Use `get pod -o wide`, `describe pod`, and `describe node` to reason about placement. Node `allocatable` is smaller than total node capacity.
</details>

<details><summary>Hint 2 — example commands</summary>

```bash
kubectl apply -f scheduling-test.yaml
kubectl get pod cannot-fit -o wide
kubectl describe pod cannot-fit
kubectl get nodes
```

After CHECK: `kubectl delete pod cannot-fit`.
</details>
