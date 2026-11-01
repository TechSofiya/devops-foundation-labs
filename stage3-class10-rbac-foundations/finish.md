# Lab complete — Explain who may do what 🪪

You built and tested **one chain of authorization**:

```text
ServiceAccount report-bot (WHO)
    └── RoleBinding report-bot-reads-config (CONNECTION, in foundation10)
          └── Role configmap-reader (WHAT: get/list/watch ConfigMaps)
                ├── ✅ read ordinary ConfigMaps in foundation10
                ├── ⛔ read Secrets: not granted
                └── ⛔ ConfigMaps in another namespace: not granted
```

You also bound `audit-agent` to built-in `view` **through a RoleBinding**, without cluster-wide permission and without access to Secrets or mutation.

**Explain out loud (or to your tutor):**

1. Why did creating the Role alone not give `report-bot` access?
2. What was different about `get` vs `list`? Why did a real Forbidden response matter?
3. Why can the auditor read Pods in `foundation10` but not in `default`, even though its binding references a **ClusterRole**?
4. What does the ServiceAccount actually represent? How would a Pod reference it?
5. In the school EKS architecture, which additional **AWS authentication/access-entry** step happens before Kubernetes RBAC? Why can't we claim to have tested that here?
6. Why should a Claude Code / agent identity be separately scoped, and why isn't `--as` proof of a production-safe agent kubeconfig?

**Cleanup:** The Killercoda host and cluster are temporary. Do not paste real credentials or use this repo against your school EKS cluster. This sandbox is not evidence that you did the instructor-only demo on school infrastructure.

**Source distinction:** This is an **original supplemental learner lab** based on School 312 Stage 3 Class 10; the real class limited creating Roles and impersonating other identities to the instructor.
