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
