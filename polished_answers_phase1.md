# Polished Answers — Phase 1 (Days 1-4)

## Day 1: Linux Basics

**What is the difference between `apt update` and `apt upgrade`?**
`apt update` refreshes the package index — it checks what versions are available. `apt upgrade` actually downloads and installs the newer versions. You run `update` before `upgrade` to ensure you're installing the latest available packages.

**What does the pipe (`|`) operator do?**
It connects the output of one command directly to the input of another command. Example: `ps aux | grep ssh` — `ps aux` lists all processes, and `grep ssh` filters for lines containing "ssh."

**How do you check the last 10 lines of a log file in real-time?**
`tail -n 10 -f /var/log/auth.log`. The `-n 10` flag shows the last 10 lines. The `-f` flag means "follow" — it keeps the file open and streams new lines as they're written. `Ctrl+C` stops it.

---

## Day 2: Permissions & SSH

**Why did `mkdir -p /backup` fail for the `devops` user, but `mkdir -p ~/backups` succeed?**
`/backup` is at the root of the filesystem, owned by `root` with permissions 755. The `devops` user has only read+execute on `/`, so `mkdir /backup` fails with Permission denied. `~/backups` is inside `/home/devops`, owned by `devops`. Since `devops` owns the parent directory, they have write permission and can create subdirectories. **Lesson: write permission on the parent directory is what matters, not on the new file.**

**What is the principle of least privilege, and how did you apply it today?**
The principle of least privilege means giving users and services only the minimum permissions they need to do their job — nothing more. I applied it by: creating a non-root user (`devops`) instead of using root, disabling SSH password authentication in favor of key-based auth, and keeping the backup script in a user-writable directory (`$HOME/backups`) instead of `/backup` which requires root.

**What happens if you disable password authentication in SSH and lose your private key?**
You are locked out of remote SSH access. Recovery requires console access (physical or out-of-band management like iDRAC/iLO) to log in locally with a password, re-enable PasswordAuthentication, generate a new key, and fix it. Best practice: always keep a second SSH key or a "break glass" user with password auth enabled on a non-standard port.

---

## Day 3: Networking & tcpdump

**What does `tcpdump -i any port 80 -A -n` do?**
Captures all port 80 traffic on all interfaces (`-i any`), prints the payload as readable ASCII text (`-A`), and skips DNS resolution for speed (`-n`). Useful for reading raw HTTP requests and responses in plaintext.

**Why can you read HTTP but not HTTPS in tcpdump?**
HTTP sends data in plaintext — anyone sniffing the wire sees headers, body, cookies, everything. HTTPS wraps HTTP inside TLS (Transport Layer Security) — the data is encrypted before it leaves the machine. `tcpdump` captures the encrypted bytes, which appear as garbage.

**What's the difference between `-w` and `-r` in tcpdump?**
`-w file.pcap` **writes** captured packets to a file (capture now, analyze later). `-r file.pcap` **reads** packets from an existing file (playback). You cannot use both in the same command — `-w` is for live capture, `-r` is for offline analysis.

**What are the three steps of the TCP handshake?**
1. **SYN** — client sends "I want to connect"
2. **SYN-ACK** — server responds "I hear you, I want to connect too"
3. **ACK** — client confirms "Great, let's talk"

**What do tcpdump flags mean?**
| Symbol | Flag | Meaning |
|--------|------|---------|
| [S] | SYN | Connection request |
| [S.] | SYN-ACK | Connection accepted |
| [.] | ACK | Acknowledgment |
| [F] | FIN | Connection close |
| [R] | RST | Connection reset |
| [P] | PSH | Push data to app |

**What is the difference between a port scan and a DDoS?**
- **Port scan:** 1 source IP → many ports on 1 target. Reconnaissance — looking for open doors. Detected by many SYNs to many ports from one IP.
- **DDoS:** many source IPs → 1 port on 1 target. Overwhelming — flooding the target. Detected by many SYNs to one port from many different IPs.
- **SYN flood:** 1 source IP with spoofed addresses → 1 port. Exhausts the connection table. Defended by SYN cookies.

**In a single-node k3s cluster, which interface carries what traffic?**
| Traffic | Interface | Port |
|---------|-----------|------|
| kubectl → API server | lo | 6443 |
| Pod ↔ Pod (same node) | cni0 / veth | any |
| Pod ↔ Pod (cross-node) | flannel.1 | 8472/udp |
| External → NodePort | eth0 | 30000-32767 |
| API server ↔ kubelet | lo / eth0 | 10250 |

---

## Day 4: DNS, HTTP, curl

**What's the difference between `/etc/hosts` and DNS?**
`/etc/hosts` is a local, static file — only affects the local machine, checked first, instant lookup, manual updates. DNS is a global, distributed, dynamic system — affects the entire internet, TTL-driven, requires network round trips, centralized management. `/etc/hosts` is used for local dev, overrides, and blocking. DNS is used for everything else in production.

**What does HTTP 502 Bad Gateway mean?**
A proxy or gateway (nginx, Traefik, HAProxy, ALB) received an invalid or no response from an upstream server (backend application, pod, another service). Real scenarios: (1) Kubernetes ingress → pod in CrashLoopBackOff, (2) nginx → crashed Python backend, (3) AWS ALB → all targets unhealthy. Compare: 500 = server bug, 502 = upstream broken, 503 = overloaded, 504 = upstream too slow.

**What does `curl -w "%{time_namelookup}"` measure?**
It measures the time spent resolving the hostname to an IP address — i.e., DNS lookup time. Not total response time. Full breakdown: `time_namelookup` (DNS) → `time_connect` (TCP handshake) → `time_appconnect` (TLS handshake) → `time_starttransfer` (TTFB) → `time_total` (full request). This is how you debug "the website is slow" — each layer has different causes.

**Why did Traefik return 404 for `day4.local` but nginx returned 200?**
Traefik is a Kubernetes ingress controller. It routes based on `Ingress` and `IngressRoute` resources in the cluster. No resource for `day4.local` → no route → 404. nginx uses static config files. A `server` block listening on 8080 exists → 200. **Lesson: static config (imperative) vs dynamic cluster resources (declarative).**

**What's the difference between a static-config web server (nginx) and a dynamic-resource-based router (Traefik)?**
nginx reads static config files and requires a reload to apply changes. Traefik watches Kubernetes Ingress/IngressRoute resources and automatically updates its routing table — no reload needed. nginx = imperative, single-server scope. Traefik = declarative, cluster-wide scope.

**What did you learn about ports and why didn't you remove k3s?**
- Two services cannot bind to the same port on the same interface. Traefik owns `0.0.0.0:80`; nginx moved to `8080`.
- Port ranges: 0-1023 privileged, 1024-49151 registered, 49152-65535 ephemeral.
- Didn't remove k3s because removing working infrastructure to avoid a conflict is running from a problem, not solving it. Real skill: understand who owns what, resolve the conflict, document the decision. "Walk around a working service without breaking it" is the production mindset.


## Day 5: systemd + journald

**What does `systemctl enable` do?**
Creates a symlink in the target's `.wants` directory (e.g., `multi-user.target.wants`) so systemd automatically starts the service at boot. `start` runs the service now; `enable` makes it run on every boot.

**What's the difference between a .service and a .timer?**
The `.service` unit defines **what** to run. The `.timer` unit defines **when** to run it. The timer activates the service at the scheduled time. You need both: the timer points to the service, and the service contains the command.

**Why is journalctl better than reading log files directly?**
- Centralized: all services log to one place
- Structured: supports filtering by unit, priority, time
- Binary format: faster, less disk space
- Rotated automatically: no manual logrotate for systemd logs
- Persistent option: survives reboots when configured

**How is `kubectl apply` similar to `systemctl start`?**
Both are declarative "make it so" commands. `systemctl start nginx` asks systemd to bring nginx to a running state. `kubectl apply -f deployment.yaml` asks Kubernetes to reconcile the cluster to match the desired state in the YAML. In both cases, the controller (systemd or k8s) figures out the steps to achieve the goal.



## Day 5: systemd + journald

**What does `systemctl enable` do?**
Creates a symlink in the target's `.wants` directory (e.g., `multi-user.target.wants`) so systemd automatically starts the service at boot. `start` runs the service now; `enable` makes it run on every boot.

**What's the difference between `Type=oneshot` and `Type=simple`?**
- `Type=simple`: systemd starts the process and assumes it's running immediately. The process stays alive (a daemon like nginx).
- `Type=oneshot`: systemd runs the process to completion and waits for it to exit. The service is "done" after the script finishes. Used for scripts, backups, migrations.

**What's the difference between a .service and a .timer?**
The `.service` unit defines **what** to run. The `.timer` unit defines **when** to run it. The timer activates the service at the scheduled time. You need both.

**Are systemd timers really a cron replacement?**
Yes. systemd timers provide automatic logging (journald), missed-run recovery (`Persistent=true`), dependency management (`After=`, `Requires=`), second-level precision (`OnCalendar`), event-based triggering (`OnBootSec`), and easy monitoring (`systemctl list-timers`). Cron is still useful for quick scripts but production systems increasingly use systemd timers.

**Why is journalctl better than reading log files directly?**
- Centralized: all services log to one place
- Structured: filter by unit, priority, time
- Binary format: faster, less disk space
- Automatic rotation
- Persistent option: survives reboots when `/var/log/journal/` exists

**How is `kubectl apply` similar to `systemctl start`?**
Both are declarative "make it so" commands. You declare desired state; the controller (systemd or Kubernetes) reconciles reality to match. `systemctl start nginx` and `kubectl apply -f nginx.yaml` both say "make nginx run."

**Why did logrotate fail with "insecure permissions"?**
logrotate runs as root and refuses to rotate logs in directories owned by non-root users (protection against symlink attacks). Fix: add `su <user> <group>` directive to the config, telling logrotate which user owns the log.


## Day 5: systemd + journald

**What does `systemctl enable` do?**
Creates a symlink in the target's `.wants` directory (e.g., `multi-user.target.wants`) so systemd automatically starts the service at boot. `start` runs the service now; `enable` makes it run on every boot.

**What's the difference between `Type=oneshot` and `Type=simple`?**
- `Type=simple`: systemd starts the process and assumes it's running immediately. The process stays alive (a daemon like nginx).
- `Type=oneshot`: systemd runs the process to completion and waits for it to exit. The service is "done" after the script finishes. Correct choice for scripts, backups, migrations.

**What's the difference between a .service and a .timer?**
The `.service` unit defines **what** to run. The `.timer` unit defines **when** to run it. The timer activates the service at the scheduled time. You need both.

**Are systemd timers really a cron replacement?**
Yes. systemd timers provide automatic logging (journald), missed-run recovery (`Persistent=true`), dependency management (`After=`, `Requires=`), second-level precision (`OnCalendar`), event-based triggering (`OnBootSec`), and easy monitoring (`systemctl list-timers`). Cron is still useful for quick scripts, but production systems increasingly use systemd timers.

**Why is journalctl better than reading log files directly?**
Centralized, structured, filterable by unit/priority/time, binary format (faster, less disk), automatic rotation, persists across reboots when `/var/log/journal/` exists.

**How is `kubectl apply` similar to `systemctl start`?**
Both are declarative "make it so" commands. You declare desired state; the controller (systemd or Kubernetes) reconciles reality to match.

**Why did logrotate fail with "insecure permissions"?**
logrotate runs as root and refuses to rotate logs in directories owned by non-root users (protection against symlink attacks). Fix: add `su <user> <group>` directive to the config.
