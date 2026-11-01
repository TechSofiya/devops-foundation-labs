# Stage 3 · Class 13 — Storage That Survives, and Jobs That Finish

## The company story first

Your small investment team runs two types of workloads: a web process that may be replaced safely, and a database-like ledger whose records must survive. When a Pod dies, Kubernetes can recreate the process. **What replaces the data?** A persistent volume has a separate lifecycle.

You will prove this twice, then diagnose why a one-time setup Job fails when its Service is missing, repair the request path, and create a suspended CronJob.

**Actual flow, in professional terms:** local YAML → `kubectl apply` → API objects → controllers (Deployment / Job / CronJob) → Pods → node runtime. For persistence: namespace PVC → cluster PV → mount inside container → file survives replacement. In the school's EKS scenario, StorageClass + EBS CSI dynamically creates EBS storage. **Here** we use one predeclared `hostPath`-backed PV on one disposable node to isolate the storage concept. These are **not equivalent storage technologies**.

## Boundaries and safety

- This is custom supplemental Killercoda practice, **not** the instructor's Unit 6 execution or a real Postgres/EBS demonstration.
- You will work only in namespace `foundation13`, except for a clearly named single static PV that is cluster-scoped. No AWS account, persistent cloud disks, real passwords or Git secrets.
- `hostPath` is **unsafe as general production storage**; this single-node example is intentionally disposable. `Retain` means deletion of a claim does **not** erase backing data and is **not a backup**.
- The ledger HTTP server and the setup Job **simulate the architecture**, not a real SQL database, schema migration, or trade processing.
- StatefulSet and EBS StorageClass YAMLs are **read-only references**. They are not applied or verified as running workloads. CronJob scheduling was theoretical in the school class; executing a manual Job from it here is added practice.
- Don't modify/delete unrelated objects. Do not delete the training namespace before cleaning up its workload objects. The temporary lab VM will be disposed of.

## Your learning contract

You lead: inspect starter files, predict the result, choose the commands, make changes, observe output, and click **CHECK**. Hints are available at two levels; solutions are not handed to you at the start. If something fails, troubleshoot by layer, not random edits.

### Who reads what?

**File on VM** → `kubectl` sends manifest → **API server** stores PV/PVC/Deployment/Job objects → **PV binder** connects claim to PV → **kubelet** mounts storage and starts container → **process** reads/writes files. A **Service** routes traffic to selected ready Pods; a **Job** creates a Pod that exits when its work succeeds.
