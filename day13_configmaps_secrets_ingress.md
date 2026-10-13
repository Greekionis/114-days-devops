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
