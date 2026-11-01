# Step 2 — Does a container's file belong to the Pod?

Inspect `ephemeral-pod.yaml`. It defines a single `transient-note` Pod with BusyBox sleeping. The Pod has **no volume**. Apply it, wait until ready, then use `kubectl exec` to write exactly `BUY 150` into `/tmp/trade-record.txt` **inside** the running container.

Save the Pod's immutable Kubernetes UID in `/root/ephemeral-before-uid.txt`. You'll need that proof in the next step.

**Think:** `kubectl exec` runs a process inside a container. It is not an HTTP request like `curl`. Who actually writes the bytes?

<details><summary>Hint 1 — Evidence</summary>

`kubectl get pod transient-note -o jsonpath='{.metadata.uid}'` reads the current object's UID. `kubectl exec transient-note -- ...` runs a program in the container.
</details>

<details><summary>Hint 2 — After attempting</summary>

Apply the Pod, `kubectl wait --for=condition=Ready pod/transient-note --timeout=120s`, then `kubectl exec transient-note -- sh -c 'echo "BUY 150" > /tmp/trade-record.txt'`. Save the UID with `kubectl get pod transient-note -o jsonpath='{.metadata.uid}' > /root/ephemeral-before-uid.txt`. Read the file inside the container.
</details>
