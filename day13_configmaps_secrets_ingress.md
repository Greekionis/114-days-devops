# Day 13: ConfigMaps, Secrets, Ingress

## ConfigMaps
- Decouple config from images
- Create: `kubectl create configmap <name> --from-literal=k=v --from-file=path`
- Use as env: `envFrom: configMapRef`
- Use as file: mount volume, file appears in pod
- Env vars: frozen at pod start
- Mounted files: update automatically within ~30s

## Secrets
- Base64-encoded, NOT encrypted
- Create: `kubectl create secret generic <name> --from-literal=k=v`
- Decode: `kubectl get secret <name> -o jsonpath='{.data.KEY}' | base64 -d`
- Real security: RBAC + etcd encryption at rest
- Never commit secrets to git

## Ingress
- HTTP routing layer
- Traefik (k3s default) watches for Ingress resources
- Chain: client → Traefik → Service → pods
- No config reload — Traefik reacts to API changes

### Ingress YAML
```yaml
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: web-ingress
spec:
  ingressClassName: traefik
  rules:
  - host: day13.local
    http:
      paths:
      - path: /
        pathType: Prefix
        backend:
          service:
            name: web-svc
            port: { number: 80 }


## Verified Working — Day 13 Lab

### Outputs
$ kubectl get ingress -n day12
NAME CLASS HOSTS ADDRESS PORTS AGE
web-ingress traefik day13.local 192.168.1.99 80 15m

$ curl http://day13.local
[nginx welcome page]

$ curl http://day13.local/api
Hello from API


### The Chain (verified)
Browser → Traefik (port 80) → Ingress rule (Host + Path) → Service ClusterIP → kube-proxy DNAT → Pod → App

### Ingress vs Ingress Controller
- **Ingress** = k8s API object. The spec. Declares rules.
- **Ingress Controller** = software (Traefik) that implements the rules.
- In k3s, Traefik is the default Ingress Controller.
- Traefik watches the k8s API for Ingress resources and configures itself.

### "Traefik 404" mystery from Day 4 — SOLVED
- Day 4: `curl http://day4.local` returned 404 from Traefik
- Reason: no Ingress resource existed for `day4.local`
- Today: created Ingress → Traefik routes → works
- Lesson: **Ingress is the rule. Controller is the implementation. No rule = 404.**
