# Class 12 — A namespace is a shared team budget

**Supplemental Killercoda scenario · ~50–75 minutes · temporary single-node Kubernetes · no AWS charges.**

## The story: your team hosts a small app

You already know from Classes 5–11 that a **Deployment** asks for Pods and that each Pod needs enough CPU and memory on a **node**. This class adds three independent decisions:

| Actor | Question it answers | Evidence |
| --- | --- | --- |
| Your Deployment's **container resources** | What does this one container request and what limits apply? | `kubectl get deploy -o yaml` |
| Namespace **LimitRange** (admission) | What defaults or per-container maximum are allowed for new Pods? | `kubectl get limitrange -o yaml` and rejected creation |
| Namespace **ResourceQuota** (admission) | Do all Pods' declared requests and limits fit the team's total budget? | `kubectl describe resourcequota`, `kubectl describe rs` |
| **Scheduler** | Can this accepted Pod fit on a suitable node? | `kubectl describe pod` → `FailedScheduling` |
| **HPA controller** | If CPU metrics are available, should the Deployment request more Pods? | `kubectl get/describe hpa`; metrics provider needed |
| **Node autoscaler** | If a Pod cannot fit, should more machines be provisioned? | EKS Auto Mode/Karpenter in the school, **not installed here** |

**Do not confuse control flow with the web request path:** `kubectl` sends a desired-state change to the Kubernetes API; controllers/admission/scheduler process the change. HTTP users do not send requests through a ResourceQuota.

This scenario reproduces the school's Class 12 concepts, not its EKS cluster. We use fake app objects and a temporary namespace called **foundation12**. No AWS secrets, IAM, production workloads or real autoscaling infrastructure are required.

### Execution and learner boundary

- Files are delivered to `/root` (you may start with `cd /root`). Run commands in the Killercoda terminal, **not** your Mac or school EKS.
- You decide commands, edit the starter YAML, interpret Events and press **CHECK**. Progressive hints appear below each challenge.
- Use the current `kubectl` default namespace; do not use `-n` unless investigating another namespace in a **safe read-only command**.
- **A real HPA object can be created without Metrics Server, but the CPU target may show `<unknown>` and replicas may not change. This lab never requires CPU scaling to succeed.** The HPA arithmetic and boundaries are assessed separately from live metrics.
- `kubectl patch` changes the live object; the original YAML does **not** automatically change. That is intentional drift you will inspect.
- CHECK scripts assess live state and a few explanation artifacts; they do not measure interview readiness on their own.
