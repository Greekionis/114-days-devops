# Day 17: Horizontal Pod Autoscaler (HPA)

## How HPA Works
- Watches metrics (CPU/Memory) via `metrics-server`
- Compares current usage to the target (e.g., 50% of CPU request)
- If above target: add pods (up to max)
- If below target: remove pods (down to min)

## Requirements
1. `metrics-server` must be running.
2. Pods must have `resources.requests` defined (HPA needs a baseline).
3. Deployment (not bare Pod).

## Create HPA
```bash
kubectl autoscale deployment <name> --cpu-percent=50% --min=1 --max=5


## HPA Deep Dive
- **HPA requires requests**, not limits. Utilization is calculated against the *request*.
- Limits protect the node; requests drive HPA math.
- **Cooldown:** Scale-up is fast (seconds). Scale-down has a 5-minute default cooldown to prevent "flapping" (rapid up/down scaling).
- **HPA handles application load**, NOT node resource pressure. Node pressure (MemoryPressure, DiskPressure) causes Kubelet to evict pods, not scale them.
