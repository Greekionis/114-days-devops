## Deep Dive: Cross-Node Networking (Calico)

### DNS vs IPs
- **Bare Pod names do NOT resolve in DNS.** (Only Services resolve).
- To test pod-to-pod, use the Pod IP (e.g., `10.244.116.129`).
- The error `ping: bad address <pod-name>` is a DNS failure.

### The Ping Test
- Ran a busybox pod on `deb1testgdi`.
- Pinged a Pod IP on `deb2testgdi`.
- Result: 0% packet loss, ~0.5ms latency.
- **Lesson:** Calico creates a flat network where every Pod can reach every other Pod by IP, regardless of the physical node.

### The Drain Test
- Ran `kubectl drain deb1testgdi --ignore-daemonsets --delete-emptydir-data`.
- **Cordoned:** Marked node unschedulable.
- **Evicted:** Moved `spread-test` and `metrics-server` to other nodes.
- **Ignored:** DaemonSets (Calico, node-agent) stayed because they are tied to the node.
- **Lesson:** Drain is how you safely perform maintenance on a node.
- Remember to `kubectl uncordon <node>` when finished!
