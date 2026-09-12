# Day 4: DNS, HTTP, curl

## Port Conflict Resolution
- k3s Traefik owns :80/:443 (ingress controller)
- Host nginx moved to :8080
- Both coexist: Traefik for k8s ingress, nginx for host testing
- Lesson: understand port ownership before installing services

## DNS
- `/etc/hosts` overrides DNS
- `day4.local → 192.168.1.99` added
- `dig`, `nslookup`, `host` — three tools
- Record types: A, AAAA, CNAME, MX, TXT, NS

## HTTP Status Codes
| Code | Meaning |
|------|---------|
| 200 | OK |
| 301 | Moved Permanently |
| 403 | Forbidden |
| 404 | Not Found |
| 500 | Internal Server Error |
| 502 | Bad Gateway |

## curl Commands
```bash
curl -I http://day4.local:8080/ok
curl -IL http://day4.local:8080/redirect
curl -w "DNS: %{time_namelookup}s | Total: %{time_total}s\n" -o /dev/null -s http://day4.local:8080


## Deep Notes

### /etc/hosts vs DNS
| Aspect | /etc/hosts | DNS |
|--------|-----------|-----|
| Scope | Local machine only | Global |
| Update | Manual | Centralized |
| Speed | Instant | Network round trip |
| Use case | Dev, overrides | Production |

### HTTP 5xx Codes
| Code | Meaning | Cause |
|------|---------|-------|
| 500 | Internal Server Error | Server bug |
| 502 | Bad Gateway | Upstream broken |
| 503 | Service Unavailable | Overloaded/maintenance |
| 504 | Gateway Timeout | Upstream too slow |

### curl -w Variables
- `%{time_namelookup}` — DNS resolution
- `%{time_connect}` — TCP handshake
- `%{time_appconnect}` — TLS handshake
- `%{time_starttransfer}` — TTFB
- `%{time_total}` — Full request

### Traefik vs nginx Routing
- **Traefik:** reads Ingress/IngressRoute from k8s API. No resource → 404.
- **nginx:** reads static config. Server block exists → 200.
- **Lesson:** ingress controllers are cluster-resource-driven.


## Corrections & Deep Notes

### Traefik 404 vs nginx 200
- **Traefik:** routes via k8s Ingress/IngressRoute resources. No resource = 404.
- **nginx:** routes via static config. Server block exists = 200.
- **Lesson:** ingress controllers are dynamic, config-file servers are static.

### HTTP 502 — Precise Definition
> A gateway/proxy received an invalid response from an upstream server.

| Code | Who's broken |
|------|-------------|
| 500 | The server itself (code bug) |
| 502 | The upstream/backend (crash, refuse, garbage) |
| 503 | The server is overloaded |
| 504 | The upstream is too slow |

### curl -w Best Practice
```bash
curl -w "\nDNS: %{time_namelookup}s | TCP: %{time_connect}s | TTFB: %{time_starttransfer}s | Total: %{time_total}s\n" -o /dev/null -s <url>


## Interview-Ready Answers

### nginx vs Traefik
nginx uses static config files + reload. Traefik watches k8s Ingress/IngressRoute resources + auto-updates. Imperative vs declarative.

### HTTP 502
Proxy/gateway received invalid or no response from upstream. Real scenarios:
1. k8s ingress → CrashLoopBackOff pod
2. nginx → crashed Python backend

### DNS timing
/etc/hosts = local file read = instant. DNS = network round trips + multiple queries = slower. Hence time_namelookup differs by orders of magnitude.

### Ports + k3s decision
- Privileged: 0-1023
- Registered: 1024-49151
- Ephemeral: 49152-65535
- Traefik owns 0.0.0.0:80 → nginx moved to 8080
- Kept both: "walking around a working service without breaking it" = production mindset
