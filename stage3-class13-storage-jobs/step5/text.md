# Step 5 — Who puts the disk inside the container?

Open `ledger-deployment.yaml`. The Deployment runs a tiny BusyBox HTTP server, standing in for a database process. **Your job:** make the existing PVC available to the container as directory `/records`.

Find the two TODO comments and add matching names to `volumeMounts` and `volumes`, and point the latter to `persistentVolumeClaim.claimName: ledger-data`. Apply the Deployment and wait until its Pod runs.

Write exactly `BUY 150` into `/records/trade-record.txt` **inside** the container and save its Pod UID into `/root/persistent-before-uid.txt`.

**Explain the chain:** PVC → Pod's `volumes` → container's `volumeMounts` → process reading/writing `/records`.

<details><summary>Hint 1 — Three links</summary>

Container `volumeMounts.name` must equal Pod `volumes.name`. Pod `volumes.persistentVolumeClaim.claimName` must equal your PVC's metadata.name. The mount path is the view of storage from **inside** the container.
</details>

<details><summary>Hint 2 — After attempting</summary>

Add inside the container:
```yaml
volumeMounts:
  - name: database-files
    mountPath: /records
```
Add under `spec.template.spec` alongside `containers`:
```yaml
volumes:
  - name: database-files
    persistentVolumeClaim:
      claimName: ledger-data
```
Then apply and wait: `kubectl rollout status deploy/ledger-app --timeout=120s`. Write using `kubectl exec deploy/ledger-app -- sh -c 'echo "BUY 150" > /records/trade-record.txt'`. Save UID using `kubectl get pod -l app=ledger-app -o jsonpath='{.items[0].metadata.uid}' > /root/persistent-before-uid.txt`.
</details>
