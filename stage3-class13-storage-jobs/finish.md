# Finish — You repaired the full chain 🎉

## What each result proves

1. **Ephemeral:** the standalone Pod was deleted and recreated with a different UID; a file written in its unmounted writable layer disappeared.
2. **Persistence:** the PVC was Bound to a static PV on the temporary node. A Deployment-managed Pod was replaced with a different UID; the record still existed in the mounted directory.
3. **Jobs:** the first one-time Job failed on an absent Service; after repairing the Service and creating a *new* Job, its process finished successfully and Job reached Complete.
4. **CronJobs:** a suspended CronJob stores a schedule and Job template; a manually created Job ran to completion. We did **not** prove scheduled execution at 02:00.
5. **Architecture only:** `ebs-storageclass-reference.yaml` and `statefulset-reference.yaml` weren't applied. We did **not** test EBS provisioning, AZ binding, multi-node storage, PostgreSQL persistence, real schema SQL, or AWS.

## One final verbal challenge

Tell the story out loud, once in beginner language and once professionally: local manifest → API object → controller/kubelet → running process; **what replaces a Pod?** **What preserves data?** **How does a one-time Job reach a Service?** **What does a CronJob schedule?**

## Safe cleanup — only this lab's resources

Run after you have gathered evidence and checked logs:

```bash
kubectl delete cronjob nightly-ledger --ignore-not-found
kubectl delete job manual-nightly ledger-setup --ignore-not-found
kubectl delete service ledger-db --ignore-not-found
kubectl delete deployment ledger-app --ignore-not-found
kubectl delete pod transient-note --ignore-not-found
kubectl delete pvc ledger-data --ignore-not-found
kubectl delete pv foundation13-pv --ignore-not-found
```

The static PV used `Retain`: **deleting the PVC or PV is not proof that the node directory's bytes were erased**. Do not reuse this hostPath method for company databases. In this training platform, the disposable VM teardown removes the lab environment. Never run host-level destructive cleanup commands on a real cluster.

**Notion status:** Publishing / passing CHECKs / technical understanding / independence are four different things. Document them separately in the Practice Lab Library. This is custom supplemental training; the formal School 312 Unit 6 Hands-On remains separate.
