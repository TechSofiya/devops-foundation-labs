# Kubernetes Class 9 — Foundational practice

**Original beginner exercise · 30–45 minutes · No AWS charges**

Your mission is to supply configuration to a tiny portfolio web app and understand what changes in Kubernetes. This is **foundational practice**, deliberately easier than advanced troubleshooting labs.

The system: **local YAML → Kubernetes API → ConfigMap / Secret → Deployment → running process**.

- A **ConfigMap** holds ordinary settings such as `DB_HOST=db` and `TICKER=AAPL`.
- A **Secret** holds sensitive-type values. This lab contains only obviously fake example values.
- A **Deployment** manages a container that reads its environment **when it starts**.
- The example's `DB_HOST=db` is just an environment variable: **there is no real database in this pilot**. A later lab can add PostgreSQL.

The real cluster is created temporarily in Killercoda. It is not the school's retired EKS cluster. No real ECR images, AWS keys or passwords are required.

**Files:** Open the terminal and use `cd /root`. We supplied `settings.yaml`, `credentials.yaml` and `deployment.yaml` for you. You decide which commands to run. Each CHECK inspects actual Kubernetes resources. You can read progressive hints after trying yourself.

**Command rule:** Use the current kubectl context's default namespace; don't add namespace override flags. Step 1 sets it.
