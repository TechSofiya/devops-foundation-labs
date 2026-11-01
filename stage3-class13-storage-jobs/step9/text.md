# Step 9 — CronJob: schedule versus execution

CronJob → Job → Pod → process. A CronJob **creates** Jobs on a schedule; it doesn't keep an application running like a Deployment.

Read `cronjob.yaml`: schedule `0 2 * * *`, with `suspend: true` to prevent automatic tasks in this lab. Apply it, then manually create a one-off Job **from the CronJob template** called `manual-nightly`, wait for completion, and check the logs for `NIGHTLY_TASK_OK`.

Next, **read but do not apply** `statefulset-reference.yaml`: compare stable Pod identities (`-0`, `-1`) and `volumeClaimTemplates` (a distinct claim for each replica) with the Deployment and one shared claim you just used. There is no StorageClass provisioner for this reference here.

**Finish question:** Why would a production database need backups even if a PVC is Bound and its reclaim policy is Retain? Why might a company use RDS instead of managing the DB in Kubernetes?

<details><summary>Hint 1 — No overnight wait needed</summary>

`kubectl create job` has a `--from=cronjob/NAME` option. The CronJob remains suspended, but you can instantiate a Job from its template manually.
</details>

<details><summary>Hint 2 — After attempting</summary>

`kubectl apply -f cronjob.yaml`; `kubectl create job manual-nightly --from=cronjob/nightly-ledger`; `kubectl wait --for=condition=complete job/manual-nightly --timeout=120s`; `kubectl logs job/manual-nightly`.
</details>
