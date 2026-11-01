# Class 11 foundations complete 🎉

You practiced **two distinct responsibility chains**:

1. **External Secrets (source-to-cluster):** read a real-shaped, harmless ExternalSecret blueprint and locate its store, source reference, sync interval and target. **That exercise was a static blueprint check only**, because ESO, AWS IAM, AWS Secrets Manager and the SecretStore weren't installed. Then you created a fake Kubernetes Secret in the temporary cluster and connected it to a running container. A Kubernetes Secret is not the AWS source.
2. **Requests/limits (scheduler-to-runtime):** changed the live Deployment with a strategic patch; verified actual scheduling requests and runtime limits; diagnosed an unschedulable Pod from Kubernetes Events. `kubectl top` is optional and only works if Metrics Server is installed. **This lab did not experimentally demonstrate CPU throttling or OOMKilled.**

## Your own five-minute architecture challenge

- Trace *who talks to whom* in a **real** EKS External Secrets setup (include AWS IAM and Kubernetes RBAC, not as interchangeable controls).
- When a Secret changes but an env-var container is still running, why doesn't it immediately see the new value?
- What does `kubectl patch` modify: your local YAML, a live Deployment, or both? What can go wrong on the next apply?
- Request vs usage vs limit: which belongs to the scheduler, metrics system, and container runtime? What makes a Pod stay Pending?
- Explain what **OOMKilled** would mean and why a repeating container restart is different from a Pending scheduling problem.

## Cleanup and security

- After passing Step 8, run `kubectl delete pod cannot-fit`.
- Remove the local fake password file: `rm -f /root/demo-password.txt`. It contains no actual credentials.
- Temporary cluster disappears with the Killercoda lab session; nothing was deployed to AWS or the school's cluster. No account keys, real passwords, API tokens or private kubeconfigs are needed.

This was **custom supplemental practice based on School 312 Stage 3 Class 11**, not the original AWS/ESO Hands-On. Your evidence and level of AI help determine your independence rating, not just a green CHECK.
