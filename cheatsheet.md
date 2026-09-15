# DevOps Cheat Sheet — Running Notes

## Diagnostics Flow (service not responding)
1. `systemctl status <svc>` — running?
2. `journalctl -u <svc> -n 50` — logs
3. `ss -tulpen | grep <port>` — port open?
4. `curl -v localhost:<port>` — responds?
5. `strace -p <pid>` — where is it stuck?
6. `lsof -p <pid>` — files/sockets held?
7. Check DNS, firewall, upstream

## Key Commands by Layer

### Linux
- `ps aux` — processes
- `top`, `htop` — real-time
- `kill -TERM <pid>` — graceful stop
- `kill -9 <pid>` — force kill (last resort)

### Files
- `lsof -i :<port>` — who owns port
- `lsof -p <pid>` — files of a process
- `lsof +D <dir>` — who's using this dir
- `lsof | grep deleted` — deleted files still held

### Syscalls
- `strace <cmd>` — trace everything
- `strace -e trace=file <cmd>` — file ops only
- `strace -e trace=network <cmd>` — network only
- `strace -y <cmd>` — annotate FDs with paths
- `strace -f -o file.txt <cmd>` — follow forks, output to file
- `strace -p <pid>` — attach to running process

### Network
- `ss -tulpen` — listening ports
- `tcpdump -i any port <n> -A -n` — capture
- `ping`, `traceroute`, `dig`, `curl -v`

### systemd
- `systemctl status/start/stop/enable/disable`
- `journalctl -u <svc>` — logs
- `journalctl -p err` — errors only
- `systemctl list-timers` — scheduled jobs

### Kubernetes
- `kubectl get pods,svc,pvc,pv -A`
- `kubectl describe <resource>`
- `kubectl logs <pod>` / `-f` / `--previous`
- `kubectl exec -it <pod> -- sh`
- `kubectl apply -f <yaml>`
