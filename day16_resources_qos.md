# Day 16: Resource Requests, Limits, and QoS

## Requests vs Limits
| Concept | Purpose | Effect |
|---------|---------|--------|
| **Request** | Guaranteed minimum | Scheduler finds a node with this much free |
| **Limit** | Hard ceiling | CPU: throttled. Memory: OOMKilled. |

## Key Rules
1. If Request > node capacity → Pod stays **Pending** forever.
2. If Memory usage > Limit → **OOMKilled** (Exit code 137).
3. If CPU usage > Limit → **Throttled** (slow, but alive).

## QoS Classes
| Class | Condition | Priority |
|-------|-----------|----------|
| **Guaranteed** | Requests == Limits | Highest (killed last) |
| **Burstable** | Requests < Limits | Medium |
| **BestEffort** | No requests, no limits | Lowest (killed first) |

## Production Best Practices
- **Always set requests.** Required for scheduling and autoscaling.
- **Set memory limits slightly above requests.** Too low = OOMKill.
- **Omit CPU limits** (or set very high). CPU throttling slows apps.
- **Critical apps (DBs):** Requests == Limits (Guaranteed QoS).

## Lab Verification
- Requested 8 CPUs → Pod Pending ("Insufficient cpu")
- Python memory bomb with 100Mi limit → OOMKilled (exit 137)
- Python CPU hog with 200m limit → throttled (no kill)
- Checked QoS classes: BestEffort, Burstable, Guaranteed
