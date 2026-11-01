# Class 11 — Passwords out of Git, and what a Pod may use 🔐

**Supplemental beginner-to-intermediate practice · about 50–75 minutes · temporary single-node Kubernetes lab · no AWS costs**

## The company story (WHY before syntax)

We operate a tiny fictional portfolio application. Two engineering responsibilities should never be confused:

**A. Where sensitive configuration comes from**

```text
REAL SCHOOL / AWS:                 THIS DISPOSABLE KILLERCODA LAB:
AWS Secrets Manager               An illustration ONLY: an ExternalSecret YAML
  → IAM role of secrets-reader      → NO operator and NO live AWS secret syncing
  → SecretStore / operator          → A fake value created locally in the lab
  → Kubernetes Secret               → a real Kubernetes Secret
  → kubelet sets container env      → kubelet sets container env
  → app process uses value          → app process uses value
```

An `ExternalSecret` is **not itself a password or a native Kubernetes Secret**. It is an instruction to an **External Secrets Operator (ESO)**. ESO is an add-on controller (not built into Kubernetes), and it needs a working SecretStore/provider identity to synchronize secrets. We **will not apply** the blueprint in this lab, because this temporary cluster has no configured AWS provider, IAM role or ESO controller. A static file check in Step 2 **does not prove a sync**.

**B. How much capacity the container is allowed to use**

```text
Local resources-patch.yaml → kubectl PATCH → API saves Deployment
                                              ↓
                                      Deployment creates Pod
                                              ↓
Scheduler compares Pod REQUESTS with available single-node capacity
                                              ↓
Kubelet/container runtime starts process, enforcing CPU/MEMORY LIMITS
```

- **Request:** scheduling reservation; the Pod must fit on one node.
- **Limit:** execution boundary; CPU can be throttled and memory overuse may result in OOMKilled.
- **Usage:** real consumption; check with `kubectl top` **only if** Metrics Server exists. Metrics may be unavailable in a one-node training VM; that is *not* evidence your workload is broken.
- A `Pending` Pod needs investigation; it isn't automatically a broken image. Read Pod conditions, `describe` Events, and scheduler messages.

## Connections to your previous classes

Class 9: a container receives `env` values when it starts, not continuously from a YAML file. Class 10: RBAC protects who can read the Kubernetes Secret; AWS IAM protects the external source. Stage 2: EC2 instances have finite CPU and RAM, just like Kubernetes nodes; one Pod is not allowed to span two nodes. Class 6/8: rollouts replace Pods and readiness controls traffic. This lab has **no real HTTP app or database**, so only configuration and capacity behavior are tested.

## Your working rules

1. Run `cd /root` in the Killercoda terminal. Open the five starter manifests before editing.
2. You decide the commands, inspect actual evidence, and use hints only as needed. `CHECK` scripts inspect real state (except the explicitly static ExternalSecret mapping in Step 2).
3. Never use genuine credentials. The only password values in instructions are **obviously fictitious** `FAKE_CLASS11_V1` and `FAKE_CLASS11_V2`, created **inside** the disposable environment. They are not GitHub files. Do not print Secret values in terminal screenshots or chat.
4. Namespace is `foundation11`; make it your context default so ordinary commands don't need `-n`.
5. Do not apply `externalsecret-blueprint.yaml`: this lab has **no ExternalSecret CRD/operator, AWS role, SecretStore, or live sync**. Likewise, this is not your school's EKS cluster.
6. Don't start a real OOM stress workload. In this lab, you will prove *scheduling* behavior safely. CPU throttling and OOMKilled are conceptual follow-ups, not falsely claimed as executed experiments.

**References:** [Official Class 11 source in Notion](https://app.notion.com/p/403e62ff57de8129910fe784e73b1308) · [External Secrets Operator concepts](https://external-secrets.io/latest/introduction/overview/) · [Kubernetes resource management](https://kubernetes.io/docs/concepts/configuration/manage-resources-containers/).
