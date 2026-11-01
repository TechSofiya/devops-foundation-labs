# Step 3 — Replacement Pod, missing file

Delete the `transient-note` Pod. Because it is **standalone**, no Deployment/ReplicaSet recreates it. Apply `ephemeral-pod.yaml` again and wait for it to be Ready.

Compare the new UID with `/root/ephemeral-before-uid.txt` and check `/tmp/trade-record.txt` inside the new container.

**Predict:** Does the original file survive? Why is the new UID useful evidence?

<details><summary>Hint 1 — Two checks</summary>

Check the UID with `kubectl get pod -o jsonpath` and ask the container whether the old file exists using `test -e` (or `ls`).
</details>

<details><summary>Hint 2 — After attempting</summary>

`kubectl delete pod transient-note`, `kubectl apply -f ephemeral-pod.yaml`, `kubectl wait --for=condition=Ready pod/transient-note --timeout=120s`, `kubectl exec transient-note -- sh -c 'test ! -e /tmp/trade-record.txt'`.
</details>
