# Class 12 foundation lab complete 🎉

Your temporary cluster exercised multiple actors, not one vague “Kubernetes scaling” process:

1. **You + kubectl + API server** changed live Deployment state with a strategic merge patch. Local YAML was unchanged.
2. **Deployment / ReplicaSet controllers** tried to create and maintain Pods after the Pod template changed.
3. **LimitRange admission** filled per-container defaults and refused an excessive per-container CPU limit.
4. **ResourceQuota admission** refused a Pod request above the namespace's total; read `FailedCreate` on the **ReplicaSet**, because there was no new Pod to describe.
5. **HPA controller** holds an autoscaling specification; its live CPU decisions require working metrics. You calculated CPU utilization relative to the request and proved the spec exists, not a fabricated scaling event.
6. **Scheduler** failed to place an admitted Pod whose nodeSelector matched no node; that is different from quota refusal.

**Connect to Stage 2:** HPA adds **Pods**; EKS Auto Mode/Karpenter adds **nodes**. This training cluster does not demonstrate AWS node provisioning.

**Explain out loud before considering the skill understood:** If the database is down, why won't HPA or additional nodes fix the application? What would readiness prove that liveness would not? Why do live object, resource policies and local Git file represent different layers?

**Platform truth:** This lab did not test EKS, Metrics Server installation, real HPA scale-up, Karpenter, an actual resource-pressure workload, AWS billing, or production Secret permissions. It used actual Kubernetes API objects and admission/scheduling evidence. The Killercoda VM is temporary; you already cleaned up named lab objects.
