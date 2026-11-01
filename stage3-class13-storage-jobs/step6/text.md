# Step 6 — The Pod changes; the record survives

Your `ledger-app` Deployment owns a ReplicaSet, which keeps one Pod running. Delete **only** the Pod with label `app=ledger-app`. The controller creates a replacement. Wait until the new Pod runs; inspect the UID and file.

**Predict:** Which object is responsible for recreating the Pod? Which object is responsible for keeping the data? Those are *not* the same responsibility.

<details><summary>Hint 1 — Prove replacement and persistence separately</summary>

Compare the old UID stored in `/root/persistent-before-uid.txt` with the current Pod's UID. Then `kubectl exec ... -- cat /records/trade-record.txt` to prove bytes are still present.
</details>

<details><summary>Hint 2 — After attempting</summary>

`kubectl delete pod -l app=ledger-app`, then `kubectl wait --for=condition=Ready pod -l app=ledger-app --timeout=120s`. Compare UID and inspect the mounted record. Do **not** delete the claim.
</details>
