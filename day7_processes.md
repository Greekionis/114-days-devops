# Day 7: Process Management, strace, lsof

## ps Variations
- `ps aux` — BSD syntax, all processes
- `ps -ef` — UNIX syntax, all processes
- `ps auxf` — tree view
- `ps auxww` — full command line

## Signals
| Signal | Number | Use |
|--------|--------|-----|
| SIGTERM | 15 | Graceful stop (try first) |
| SIGKILL | 9 | Immediate kill (last resort) |
| SIGHUP | 1 | Reload config |
| SIGINT | 2 | Ctrl+C |
| SIGSTOP | 19 | Pause (uncatchable) |
| SIGCONT | 18 | Resume |

## lsof
- `lsof -i :80` — who's using port 80
- `lsof -p <PID>` — files opened by process
- `lsof +D /path` — who's using files in this directory
- `lsof | grep deleted` — deleted files still held open (disk space leak)

## strace
- `strace <cmd>` — trace a command
- `strace -e trace=file <cmd>` — only file operations
- `strace -e trace=network <cmd>` — only network
- `strace -p <PID>` — attach to running process
- `strace -f -o file.txt <cmd>` — follow forks, output to file
- Errno names: ENOENT (file not found), ECONNREFUSED (connection refused), EACCES (permission denied)

## k8s Connection
- Containers use PID namespaces
- `ps` inside container = container-only view
- `ps` on host = all processes
- `crictl ps`, `crictl logs` — container runtime view
