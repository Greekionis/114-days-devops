# Day 11: Kubernetes Core — Pods, Deployments, Services

## Pods
- Smallest unit in k8s
- One or more containers sharing network + storage
- Lifecycle: Pending → ContainerCreating → Running → Succeeded/Failed

## Init Containers
- Run before main containers
- Sequential, to completion
- Use: setup, wait for dependency, download data

## Sidecars
- Run alongside main container
- Same pod, shared network + volumes
- Use: logging, proxy, monitoring

## Deployments
- Manage ReplicaSets, which manage Pods
- Handle: rolling updates, rollbacks, scaling
- Self-healing: RS recreates deleted pods

## Services
| Type | Reachable from |
|------|----------------|
| ClusterIP | Inside cluster |
| NodePort | Outside via node port |
| LoadBalancer | Outside via real LB |
| ExternalName | DNS alias |

## Commands
```bash
kubectl create namespace day11
kubectl config set-context --current --namespace=day11
kubectl apply -f <yaml>
kubectl get pods,deployments,rs,svc -o wide
kubectl describe pod <name>
kubectl logs <pod> [-c container] [--previous]
kubectl exec -it <pod> -- sh
kubectl scale deployment <name> --replicas=N
kubectl set image deployment/<name> <container>=<image>
kubectl rollout status deployment/<name>
kubectl rollout history deployment/<name>
kubectl rollout undo deployment/<name>
kubectl expose deployment <name> --port=80 --type=NodePort
