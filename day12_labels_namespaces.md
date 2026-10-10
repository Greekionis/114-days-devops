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
