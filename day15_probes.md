# Day 15: Health Checks (Probes)

## The Three Probes

| Probe | Purpose | On Failure |
|-------|---------|------------|
| **Startup** | Grants time for slow-booting apps. Pauses liveness. | Restart container (if threshold exceeded) |
| **Liveness** | Is the app alive/not deadlocked? | RESTART container |
| **Readiness** | Can the app serve traffic right now? | REMOVE from Service endpoints (NO restart) |

## Key Takeaways
- **Liveness** = App is broken. Fix: restart it.
- **Readiness** = App is temporarily unavailable (e.g., DB down). Fix: stop sending traffic, but don't restart.
- **Startup** = App needs time to boot. Fix: wait before checking liveness.

## Conventions
- `/healthz` (or `/livez`) -> liveness
- `/ready` (or `/readyz`) -> readiness
- Paths are conventions, not hardcoded. You define them.

## Best Practice YAML
```yaml
startupProbe:
  httpGet: { path: /healthz, port: 8080 }
  failureThreshold: 30
  periodSeconds: 10
livenessProbe:
  httpGet: { path: /healthz, port: 8080 }
  periodSeconds: 10
readinessProbe:
  httpGet: { path: /ready, port: 8080 }
  periodSeconds: 5
