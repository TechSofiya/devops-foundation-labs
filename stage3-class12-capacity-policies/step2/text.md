# Step 2 — A Deployment declares Pods, but no resource budget yet

Open `/root/baseline-deployment.yaml`. This is a tiny `busybox` application; it has one container that sleeps. There is **no** `resources:` field yet.

1. Apply the manifest and inspect the Deployment's requested replica count and its Pod template.
2. Find which **Pod** and **container** this Deployment owns.
3. Check that the live container has no explicit CPU/memory requests or limits before the policy is created.

**Architecture:** local YAML → `kubectl apply` → API server creates Deployment → Deployment controller/ReplicaSet creates Pod → scheduler places it → kubelet runs BusyBox. The YAML file does not execute the container.

**CHECK** verifies the live Deployment has one replica and no explicit resources.

<details><summary>Hint 1</summary>

Try `kubectl apply -f baseline-deployment.yaml`, `kubectl get deploy,rs,pod -l app=capacity-app` and `kubectl get deployment capacity-app -o yaml`.
</details>

<details><summary>Hint 2</summary>

The `resources` object lives under `spec.template.spec.containers[0]`, not at the Deployment's top level. If your Pod is starting, inspect `kubectl describe pod` rather than guessing.
</details>
