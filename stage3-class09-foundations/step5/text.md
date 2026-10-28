# Step 5 — The ConfigMap changes, but your running process doesn't

1. First predict: if you edit a ConfigMap, will an already-running process immediately get new environment variables?
2. Edit `/root/settings.yaml` and change only **TICKER: AAPL** to **TICKER: MSFT**.
3. Apply the changed ConfigMap.
4. Compare what `kubectl describe cm portfolio-settings` says with `kubectl exec deploy/portfolio-app -- printenv TICKER`.

**CHECK** verifies the live ConfigMap is **MSFT** while the *existing running container* still has **AAPL**. **Do not restart the Deployment yet.**

<details><summary>Hint 1</summary>

Environment variables are copied into the container when it starts. Editing the ConfigMap does not rewrite a running process's environment.
</details>
<details><summary>Hint 2 — Syntax after attempting</summary>

`kubectl apply -f settings.yaml`

`kubectl describe cm portfolio-settings`

`kubectl exec deploy/portfolio-app -- printenv TICKER`
</details>
