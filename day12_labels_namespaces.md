# Day 12: Labels, Selectors, Namespaces

## Labels
- Key-value pairs on any resource
- Used by Services, Deployments, NetworkPolicies to select resources

## Selectors
```bash
kubectl get pods -l tier=frontend
kubectl get pods -l tier=frontend,env=prod
kubectl get pods -l 'tier in (frontend,backend)'
kubectl get pods -l 'env!=prod'


## Fixes and Learnings

### Deprecated Endpoints → EndpointSlice
- `Endpoints` deprecated in k8s 1.33+
- Use `kubectl get endpointslice`
- Better scalability (slices of 100 endpoints)

### Never sudo kubectl
- sudo uses root's kubeconfig (~root/.kube/config)
- Your user's kubeconfig is ~/.kube/config
- Fix: chown + chmod, then use kubectl without sudo

### Current namespace
- `kubectl config view --minify | grep namespace`
- `kubectl config set-context --current --namespace=X` (no sudo)

### Quota gotchas
- ResourceQuota enforces `hard` limits only
- Tracks requested resources, not actual usage
- LimitRange sets per-pod defaults/min/max (different object)

### kubectl run --requests doesn't exist
- Generate YAML with `--dry-run=client -o yaml`
- Edit and apply with `kubectl apply -f`

### restartPolicy
- Default: Always
- `sleep 3600` causes restarts every hour
- Use `sleep infinity` for long-lived demo pods


## The Service Mechanism (Deep Understanding)

### How a Service actually works
- A Service is NOT a process — it's a set of iptables rules installed by kube-proxy on every node
- ClusterIP is a virtual IP that gets DNAT'd to real pod IPs
- EndpointSlice tracks the current pod IPs behind the Service
- kube-proxy watches EndpointSlices and updates iptables

### Verify with iptables
```bash
sudo iptables -t nat -L KUBE-SERVICES -n | grep <clusterIP>
sudo iptables -t nat -L KUBE-SVC-XXXXX -n


 sudo iptables -t nat -L KUBE-SVC-VAYC7TNILV6OFX76 -n
Chain KUBE-SVC-VAYC7TNILV6OFX76 (1 references)
target     prot opt source               destination
KUBE-MARK-MASQ  tcp  -- !10.42.0.0/16         10.43.29.136         /* day12/web-svc cluster IP */ tcp dpt:80
KUBE-SEP-5RLAVTNYUYNIP3M4  all  --  0.0.0.0/0            0.0.0.0/0            /* day12/web-svc -> 10.42.0.72:80 */ statistic mode random probability 0.20000000019
KUBE-SEP-G36XZGWLC43NEBZK  all  --  0.0.0.0/0            0.0.0.0/0            /* day12/web-svc -> 10.42.0.73:80 */ statistic mode random probability 0.25000000000
KUBE-SEP-DX7VW6SMCQN7FSZA  all  --  0.0.0.0/0            0.0.0.0/0            /* day12/web-svc -> 10.42.0.87:80 */ statistic mode random probability 0.33333333349
KUBE-SEP-3C3RD3XGJR7MM5WF  all  --  0.0.0.0/0            0.0.0.0/0            /* day12/web-svc -> 10.42.0.88:80 */ statistic mode random probability 0.50000000000
KUBE-SEP-LQR2OL4O2F3HEH7F  all  --  0.0.0.0/0            0.0.0.0/0            /* day12/web-svc -> 10.42.0.89:80 */
