# Step 4 — What are a PV and a PVC actually for?

Inspect `manual-pv.yaml` and `pvc.yaml`. **This deliberately differs from the school's EBS example.** The school had an admin-owned StorageClass that created EBS disks dynamically. This temporary one-node backend has no guaranteed CSI provisioner, so **you create a static PV first** and then a PVC that claims it.

Apply these two files, then inspect the **Bound** relationship. Your namespace contains the claim, while the PV belongs to the cluster.

The `hostPath` directory is on the lab node. The access mode is `ReadWriteOnce` (one node; this does not mean one Pod), and `Retain` prevents automatic backend data deletion on claim removal. It does not make data portable to another node or region.

Read **but do not apply** `ebs-storageclass-reference.yaml`. Explain how the StorageClass and provisioner automate PV creation on school EKS.

<details><summary>Hint 1 — What proves binding?</summary>

Check `kubectl get pvc ledger-data` and `kubectl get pv foundation13-pv`. These refer to two different API objects connected by binding.
</details>

<details><summary>Hint 2 — After attempting</summary>

`kubectl apply -f manual-pv.yaml -f pvc.yaml`, then `kubectl get pvc ledger-data` and `kubectl get pv foundation13-pv`. The PVC must be Bound; otherwise inspect both objects with `kubectl describe`.
</details>
