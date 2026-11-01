# 6 — RUNTIME: How does the replacement container get V2?

**Mission:** use the **Deployment** controller to restart its Pods and wait for the rollout to complete. Check the new container receives the rotated value **without printing it**. Clean up the temporary password file once CHECK passes.

**WHO does what?** Your `kubectl rollout restart` modifies the live Deployment template annotation. The Deployment controller creates a replacement Pod, Kubernetes injects the current Secret when its container starts, and the new process receives fake V2. The Docker image did **not** need rebuilding.

**Contrast:** What does `kubectl rollout restart` change that updating a YAML file on your local computer does not?

<details><summary>Hint 1 — identify the controller</summary>

Try `kubectl rollout --help`. Which resource manages replacement Pods? Inspect `kubectl get deploy,rs,pods -l app=portfolio-app`.
</details>

<details><summary>Hint 2 — command examples</summary>

```bash
kubectl rollout restart deployment/portfolio-app
kubectl rollout status deployment/portfolio-app
kubectl get pods -l app=portfolio-app
```

For safety, don't run `printenv DB_PASSWORD`. CHECK tests it without displaying the value.
</details>
