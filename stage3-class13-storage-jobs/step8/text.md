# Step 8 — Fix the missing connection

Inspect `ledger-service.yaml`. Which Pod label does its selector point at? Why is the Service a stable address even when Deployment Pods are replaced?

Apply the Service, verify it has an endpoint, then **delete the failed Job and re-apply `one-time-job.yaml`**. Kubernetes doesn't automatically retry a terminally failed Job after you repair the Service.

Wait for Job Complete, then read its logs. `ONE_TIME_TASK_OK` is a stand-in for a completed schema step. It does not prove any SQL table was created.

<details><summary>Hint 1 — Service versus Job lifecycle</summary>

Before rerunning, inspect `kubectl get svc ledger-db` and `kubectl get endpoints ledger-db`. A Job with a terminal Failed condition cannot be made to rerun just by editing the Service.
</details>

<details><summary>Hint 2 — After attempting</summary>

`kubectl apply -f ledger-service.yaml`; inspect Service and endpoints; `kubectl delete job ledger-setup`; `kubectl apply -f one-time-job.yaml`; `kubectl wait --for=condition=complete job/ledger-setup --timeout=120s`; `kubectl logs job/ledger-setup`.
</details>
