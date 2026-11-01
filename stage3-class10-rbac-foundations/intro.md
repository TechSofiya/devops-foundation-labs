# Class 10 — Who is allowed to read the password? 🪪

**Original supplemental practice · ~40–60 minutes · Temporary Kubernetes cluster · No AWS costs**

In Class 9, you created a ConfigMap (ordinary settings) and a Secret (sensitive settings). You also learned that a Secret's base64 encoding is **not encryption**. So who is allowed to read either object?

## The company story

Imagine a **reporting service** that needs to read normal configuration but must **not** read a database password or modify workloads. We will create a Kubernetes identity for it, define what it may do, connect the two, and prove the boundary using actual API checks.

```text
You (admin kubectl)
  └── Kubernetes API server: authentication → RBAC authorization
        ├── ServiceAccount report-bot: WHO
        ├── Role configmap-reader: WHAT (get/list/watch configmaps)
        └── RoleBinding: grants WHAT to WHO in foundation10

A later auditor identity gets a namespace-only binding to built-in ClusterRole view.
```

**Actors:** Your terminal sends kubectl requests to the API server. Kubernetes RBAC checks the **identity, action, resource and namespace**. The ServiceAccount is a program identity, **not a Pod or a program by itself**. Here, the `--as` flag lets an authorized lab administrator ask the API server to check as that identity. On the school's EKS cluster, students **could not** create Roles or impersonate; that portion was an instructor demo. Here it is your safe practice in a disposable cluster.

## What this lab does **not** simulate

- There is **no AWS SSO, EKS access entry, AWS Secrets Manager or real Claude Code** here. In the school's actual EKS flow, authentication is bridged through AWS; here, the local cluster uses its own administrator kubeconfig.
- There is no application Pod required to understand the RBAC objects. You will create a ServiceAccount that a future Pod could use with `serviceAccountName`.
- A `RoleBinding` to ClusterRole `view` **is not the same** as an actual isolated kubeconfig for a production AI agent. It only demonstrates the authorization rules such an identity could receive.
- All data and passwords in this training scenario are **deliberately fake**. Do not use real secrets.

## How to work

1. Open the Killercoda terminal. Run `cd /root` and examine the five starter YAML files: `sample-objects.yaml`, `serviceaccount.yaml`, `role.yaml`, `binding.yaml`, `auditor.yaml`.
2. Do each challenge yourself. **Predict** who should be allowed to do what before pressing **CHECK**.
3. Use official documentation for syntax, or open Hint 1 and then Hint 2 if needed. Don't blindly paste entire sequences.
4. Do not use the school's EKS kubecontext or AWS account. This is a temporary single-node training cluster. The lab's namespace is `foundation10`.
5. If `kubectl auth can-i --as=...` says *you are not allowed to impersonate*, do **not** try to work around platform permissions. Tell your tutor; that is a sandbox capability issue.

**Helpful comparison:** AWS IAM policy/role from Stage 2 is not the same object as a Kubernetes `Role`. A Kubernetes Role describes *permissions*, much like an IAM **policy**; a RoleBinding attaches those permissions to an identity **in a namespace**.

[Official Kubernetes RBAC reference](https://kubernetes.io/docs/reference/access-authn-authz/rbac/) · [School Class 10 notes in Notion](https://app.notion.com/p/3ffe62ff57de81249e55f05165496f54)
