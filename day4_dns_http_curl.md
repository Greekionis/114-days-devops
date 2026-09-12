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
