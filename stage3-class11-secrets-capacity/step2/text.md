# 2 — ACTORS: Who actually reads an ExternalSecret?

**Class 11's real EKS architecture:** AWS Secrets Manager holds the sensitive values → the **External Secrets Operator** watches an `ExternalSecret` → its **SecretStore** identifies the provider/auth method → AWS IAM authorizes the read → ESO writes a standard Kubernetes Secret → a new container reads that Secret when starting.

**This lab is different:** there is *no ESO or SecretStore or AWS*. The `externalsecret-blueprint.yaml` starter exists so you can trace the **desired configuration** without pretending a sync happened.

**Mission:** open `externalsecret-blueprint.yaml`. Identify the source (a training-only path), the store, the target Kubernetes Secret name, and the interval. Replace **only** `REPLACE_ME` in the path with `foundation11`. Do **not** run `kubectl apply` on this file. The CHECK inspects the saved local YAML **only**, not a live ExternalSecret object.

**Reasoning:** If the target Secret does not exist in a real cluster with ESO, is it the ExternalSecret YAML, the operator, or the application that fetches the AWS password? Why can putting a reference in Git still be safer than putting the password in Git?

<details><summary>Hint — exact source field</summary>

Under `spec.dataFrom[].extract.key`, use the fictitious path `/training/foundation11/portfolio-app`. Under `spec.target.name`, keep `portfolio-credentials`. This path is a fictional teaching value and has no AWS secret behind it.
</details>
