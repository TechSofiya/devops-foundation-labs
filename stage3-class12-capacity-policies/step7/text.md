# Step 7 — Admission passed, but scheduling cannot find a node

In Step 5 a Deployment existed, but **its Pod was refused by ResourceQuota**. Here, a Pod will exist but remain **unscheduled**. These are different failure layers.

1. Inspect `placement-test.yaml`, including its unusual `nodeSelector`. Its CPU request is only `50m`, and it has resource limits inside the policy.
2. Apply the Pod. Inspect its phase, `PodScheduled` condition and Events.
3. Explain: would adding another ordinary Pod replica solve this? Would an autoscaler blindly add an arbitrary node even though the special selector isn't satisfied?

**CHECK** verifies this Pod exists, has no `.spec.nodeName`, has `PodScheduled=False`, and was rejected by the scheduler rather than ResourceQuota. No EKS/Karpenter node provisioning happens here.

<details><summary>Hint 1</summary>

`kubectl get pod placement-test -o wide` and `kubectl describe pod placement-test` are the right evidence. Compare to `kubectl describe rs -l app=quota-blocked` from Step 5.
</details>

<details><summary>Hint 2 — Root cause</summary>

The Pod asks for `training.invalid/fleet=a-node-that-does-not-exist`. No node in this temporary cluster has that label. This is a **placement-rule failure**, not an example of insufficient CPU or an AWS scale-up test.
</details>
