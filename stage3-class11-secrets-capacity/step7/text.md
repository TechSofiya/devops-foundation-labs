# 7 — CAPACITY: How much must fit, and how much can run?

Your current Deployment declares no explicit CPU or memory resources. Kubernetes still runs it, but you cannot reason clearly about scheduling reservations and runtime constraints until you configure them.

**Mission:**

- Open `resources-patch.yaml`. It is a **strategic merge patch**, not a full Deployment.
- Replace both placeholders: request CPU **100m**; limit memory **128Mi**. Leave request memory **64Mi** and limit CPU **250m**.
- Apply it to the **live Deployment** using a strategic patch; inspect the Deployment's resource section and replacement Pod's resource section.
- Compare with unchanged `portfolio-app.yaml`. Why do they differ?

**Prediction:** Does `100m` mean the container is *using* 0.1 CPU right now? And what happens if the container tries to use more than its CPU limit versus more than its memory limit?

**CHECK** checks the actual Deployment resources and that a new Pod is available. It does not claim to measure CPU throttling or OOMKills.

<details><summary>Hint 1 — how to target the live Deployment</summary>

`kubectl patch deployment portfolio-app --type=strategic --patch-file resources-patch.yaml` targets the API object. This operation changes the pod template, so it creates a new ReplicaSet/Pod. Your local `portfolio-app.yaml` remains unchanged and now drifts from live state.
</details>

<details><summary>Hint 2 — example evidence commands</summary>

```bash
kubectl patch deployment portfolio-app --type=strategic --patch-file resources-patch.yaml
kubectl rollout status deploy/portfolio-app
kubectl get deploy portfolio-app -o yaml
kubectl describe pods -l app=portfolio-app
kubectl top pods  # only if Metrics Server is present
```
</details>
