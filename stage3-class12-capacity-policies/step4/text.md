# Step 4 — Who sets the rules for **one container**?

Open **`limitrange.yaml`**. A namespace administrator can use a **LimitRange** to fill resource defaults for newly created Pods and refuse containers above a maximum.

Set the training policy to:

- Default **requests**: CPU `50m`, memory `64Mi`.
- Default **limits**: CPU `250m`, memory `256Mi`.
- Maximum per-container: CPU `1` (one full core), memory `1Gi`.

Apply the policy. Then apply `default-demo-pod.yaml`, which has **no** `resources:` in its file. Inspect the created Pod's *stored spec*. Which actor injected the defaults: BusyBox, the scheduler, or admission?

Next, attempt `kubectl apply -f over-max-pod.yaml` and capture the **rejection text** in a file named `/root/limit-error.txt` (stdout and stderr). Inspect that text. This Pod requests `100m`, but its **limit** is two CPU cores: above the per-container max.

**CHECK** verifies the LimitRange, injected Pod defaults, missing rejected Pod, and your recorded admission error.

<details><summary>Hint 1 — Observe the difference</summary>

`kubectl get pod defaults-demo -o yaml` shows stored requests/limits even though `default-demo-pod.yaml` omits them. This happens **at creation**, not continuously.
</details>

<details><summary>Hint 2 — Capture a refused command</summary>

`kubectl apply -f over-max-pod.yaml > limit-error.txt 2>&1` may exit nonzero: that is expected. Then `cat limit-error.txt` and check `kubectl get pod exceeds-container-max` (should be absent). The error should mention the CPU **maximum**.
</details>
