# War Stories (Interview Prep)

## Story 1: Port conflict between Traefik and nginx
- **Situation:** Installed nginx, but port 80 was already taken by k3s Traefik.
- **Action:** Identified owner via `ss -tulpen`, moved nginx to 8080.
- **Result:** Both services coexist. Learned about namespace-level port binding.
- **Lesson:** Understand port ownership before installing services.

## Story 2: Ceph S3 production deployment
- **Situation:** [your story]
- **Action:** [your actions]
- **Result:** 2 production clusters, [scale, capacity]
- **Lesson:** [what you learned]

## Story 3: LVM typo cascade
- **Situation:** Typo in `mkfs.ext4` device name caused 4 downstream errors.
- **Action:** Traced back to the first error, fixed the typo, re-ran.
- **Result:** Understood root cause analysis.
- **Lesson:** Always find the FIRST error, not the last.
## Story: Helm CronJob for SAN Switch Config Backup

### Context
Production system to back up SAN switch configurations weekly.

### Architecture
- **Helm chart** deployed on Kubernetes
- **CronJob** (weekly schedule)
- **Python script** connects to SAN switch APIs
- **CSI SMB driver** mounts a Samba share as the storage backend
- Originally used FTP, migrated to SMB for better integration

### The Problem
The CSI SMB driver kept crashing. Pod would go down unexpectedly,
often during large config transfers.

### The Diagnosis
Root cause: the CSI driver's default **resource requests/limits** were
too low. Under load (many switches, large configs), the pod hit its
memory limit and was OOM-killed by the kernel.

### The Fix
Tuned the CSI driver's Helm values:
- Increased memory request/limit
- Increased CPU request/limit
- Verified with monitoring

### Lesson
- **Default resources are often wrong for production.** Always review
  and tune based on real workload.
- **CSI drivers are critical infrastructure.** If they fail, pods lose
  storage — and don't always fail gracefully.
- **Kubernetes debugging:** pod crashes → `kubectl describe` → look for
  OOMKilled → check resource limits → adjust.

### Why This Matters (Interview Value)
- Real production problem
- Multi-layer debugging (k8s → CSI → storage → kernel)
- Demonstrated initiative (FTP → SMB migration)
- Fixed root cause, not symptom

## Story: Ceph Cluster PG Recovery After Rebalancing

### Context
Production Ceph cluster. After a rebalancing operation, ~400 PGs
(Placement Groups) were not deep-scrubbed. Cluster was unstable:
OSD stalls and latencies spiking above 90%.

### The Problem
- 400 PGs not deep-scrubbed
- OSDs showing stalls
- PGs going down instead of recovering
- Latency above acceptable thresholds

### The Diagnosis
Deep-scrub backlog after rebalance. Ceph's default scrub/backfill
scheduling was overwhelming OSDs, causing them to stall and
PGs to drop into down state.

### The Fix
Calibrated cluster tunables:
- Adjusted scrub/backfill scheduling
- Allowed PGs to go down briefly to prevent OSD stalls
- Prioritized deep-scrub for stale PGs
- Monitored latency throughout

### The Result
- PGs recovering progressively
- Latency stayed under 90%
- No OSDs stalled
- Follow-up scheduled for next day

### Lesson
- **Ceph deep-scrub is expensive.** Large rebalances create backlogs.
- **Defaults are tuned for small clusters.** Production needs tuning.
- **Scrub priority matters.** Deep-scrub catches silent corruption;
  regular scrub catches replication drift. Both are critical.
- **Latency > throughput.** Keeping OSDs responsive is more important
  than finishing scrubs fast.

### Why This Matters (Interview Value)
- Ceph is enterprise storage. Rare on a DevOps CV.
- Real production problem, not a tutorial.
- Multi-factor debugging (PGs, OSDs, latency, scheduling).
- Experience with a system most engineers have never touched.
