# Completed: Class 9 foundation lab! 🎉

You practiced in a real temporary Kubernetes cluster:

- Context and default namespace: where kubectl sends commands.
- `kubectl apply -f FILE` (local file) versus `kubectl get TYPE NAME` (live object).
- ConfigMap and Secret creation, and safe `get` versus `describe`.
- `envFrom.configMapRef` and `env.valueFrom.secretKeyRef` inside a Deployment.
- `kubectl rollout status`, `kubectl exec ... -- printenv TICKER` and `kubectl rollout restart`.
- Live ConfigMap values versus the running process's environment.

**Explain out loud:** Why did a ConfigMap update not affect the running container? What did restarting the Deployment change? Why is a Secret's base64 data not automatically secure?

This pilot intentionally has no PostgreSQL or real API keys. Our next foundation lab can cover missing references, startup failures and DB-to-app mapping. Then use the school's advanced Phase-4 Labs.

Your Killercoda VM disappears at session end. Nothing was deployed to AWS.
