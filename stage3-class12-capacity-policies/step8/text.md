# Step 8 — Clean up, then explain the architecture

You created temporary resources in your dedicated `foundation12` namespace. Now remove **only this lab's objects**. Preserve the namespace until the end so the CHECK can inspect it.

Clean up:

- HPA `capacity-app-cpu`.
- Deployments `capacity-app`, `quota-blocked`.
- Pods `defaults-demo`, `placement-test` (and the rejected `exceeds-container-max` if somehow present).
- ResourceQuota `team-budget` and LimitRange `team-container-rules`.

Do **not** delete arbitrary `kube-system` resources or edit the school's EKS cluster. The VM will be disposed when you finish Killercoda.

**Final architecture challenge — explain in your own words:**

- `kubectl patch` changes **which live object**, and why does the old YAML disagree afterward?
- When 600m exceeds a 500m namespace budget, **which layer refuses the Pod** and which controller's Events explain it?
- When a Pod exists but has no suitable node, **which layer** is responsible?
- Who adds **Pods** (HPA) versus **nodes** (Karpenter in the school)? Why can't either fix a database outage?

**CHECK** verifies lab cleanup and that the temporary namespace is still selected. Your explanation is for learning and is not automatically graded.

<details><summary>Hint</summary>

Delete by original manifest or by explicit object name, using `--ignore-not-found` if helpful. Then run `kubectl get deploy,pod,hpa,limitrange,resourcequota` and check the named test resources are absent.
</details>
