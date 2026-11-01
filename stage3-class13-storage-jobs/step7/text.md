# Step 7 — Why did the setup Job fail?

The school demo's schema Job originally failed because the **database Service was missing**. Our smaller stand-in demonstrates exactly the DNS/dependency failure, not SQL initialization.

Inspect `one-time-job.yaml`. It runs `wget` against `http://ledger-db:8080`. **Do not apply `ledger-service.yaml` yet.** Verify the Service is absent, create the Job, and wait for the Job to fail. Inspect its logs and status.

**Explain:** Job controller → one-time Pod → `wget` process → Service DNS. At which layer did it fail? Why does changing the Job's CPU limit not fix it?

<details><summary>Hint 1 — No endpoint yet</summary>

`kubectl get svc ledger-db` should return NotFound. `kubectl get job ledger-setup` and `kubectl logs job/ledger-setup` reveal why the process exited nonzero.
</details>

<details><summary>Hint 2 — After attempting</summary>

`kubectl apply -f one-time-job.yaml`, `kubectl wait --for=condition=failed job/ledger-setup --timeout=120s`, `kubectl logs job/ledger-setup`. Keep the failed Job for CHECK; you'll repair the Service in the next step.
</details>
