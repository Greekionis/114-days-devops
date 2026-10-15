# Day 14: StatefulSets, DaemonSets, Jobs, CronJobs

## Workload Comparison

| Type | Purpose | Pod naming | Storage | Use case |
|------|---------|-----------|---------|----------|
| Deployment | Stateless | Random suffix | Shared/ephemeral | Web apps, APIs |
| StatefulSet | Stateful | Stable (`app-0`, `app-1`) | Per-pod PVC | Databases, queues |
| DaemonSet | Per-node | One per node | Node-local | Logs, monitoring, CNI |
| Job | Run once | Random | Any | Migrations, batch |
| CronJob | Scheduled | Random per run | Any | Backups, reports |

## StatefulSet
- Sequential startup (0 → 1 → 2)
- Reverse deletion (2 → 1 → 0)
- Stable DNS: `<pod>.<svc>.<ns>.svc.cluster.local`
- Headless Service required (`clusterIP: None`)
- `volumeClaimTemplates` creates a PVC per pod

## DaemonSet
- One pod per node
- Used for: log shippers, monitoring, storage, CNI
- k3s ships several: svclb-traefik, etc.
- Auto-scheduled to new nodes

## Job
- `restartPolicy: Never` (required)
- `backoffLimit` = retries
- Pod goes to `Completed` state
- Used for: DB migrations, batch jobs

## CronJob
- `schedule`: cron syntax
- `concurrencyPolicy`: Allow/Forbid/Replace
- `suspend: true` pauses
- Manual run: `kubectl create job --from=cronjob/<name>`
- RedVirt project uses this pattern

## Cron syntax

│ │ │ │ │
│ │ │ │ └── day of week (0-7)
│ │ │ └──── month (1-12)
│ │ └────── day of month (1-31)
│ └──────── hour (0-23)
└────────── minute (0-59)

## Commands
```bash
kubectl get statefulsets,daemonsets,jobs,cronjobs -n <ns>
kubectl get pvc -l app=redis
kubectl logs -l app=redis
kubectl patch cronjob <name> -p '{"spec":{"suspend":true}}'
kubectl create job --from=cronjob/<name> <job-name>


