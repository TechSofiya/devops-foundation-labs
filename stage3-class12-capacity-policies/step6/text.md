# Step 6 — Create an HPA and investigate its evidence honestly

Your app still declares a CPU request of **100m**. An HPA target of **60%** means **60m** CPU per Pod, not 60% of the whole node.

1. Open `hpa-demo.yaml`. Edit **maxReplicas** to `2` and **averageUtilization** to `60`. Keep minimum `1` and target Deployment `capacity-app`.
2. Apply the **HorizontalPodAutoscaler** and inspect its spec and status.
3. Try `kubectl top pods` and `kubectl describe hpa capacity-app-cpu`. If Metrics Server is missing, the target may stay `<unknown>` or show a metric retrieval error. **Do not install cluster add-ons; this is a valid observation.**
4. In `/root/hpa-reasoning.txt`, write FOUR separate lines in this exact key/value format, using reasoning rather than copying an answer:

```
utilization_percent: YOUR_NUMBER
hpa_scales: YOUR_CHOICE
nodes_added_by_hpa: YOUR_CHOICE
quota_can_block_new_pods: YOUR_CHOICE
```

Scenario: if measured CPU were `200m` and request `100m`, calculate utilization. In the remaining fields use `pods` or `nodes`, `yes`/`no`, and `yes`/`no`. Think carefully: what controller creates Pods, and what supplies *machines* in real EKS?

**CHECK** verifies the HPA spec and all four reasoning fields. **It does NOT require a live CPU-driven scale event.**

<details><summary>Hint 1 — Ask the right layer</summary>

`kubectl get hpa capacity-app-cpu -o yaml` checks desired autoscaling rules. Metrics Server is a separate data source. `kubectl top pods` tests whether those resource metrics are available.
</details>

<details><summary>Hint 2 — Formula</summary>

CPU utilization (%) = measured CPU (`200m`) ÷ CPU request (`100m`) × 100. The HPA changes **Deployment replicas**; it does not create nodes or bypass namespace policy.
</details>
