# Day 5: systemd + journald

## First systemd Service
- `/etc/systemd/system/backup.service`
- Type=oneshot, User=devops, ExecStart=/home/devops/backup.sh
- Logs go to journald

## systemd Timer
- `/etc/systemd/system/backup.timer`
- OnCalendar=*-*-* 02:00:00
- Persistent=true
- Replaces cron

## journalctl
- `journalctl -u <service>` — per-unit logs
- `journalctl -p err` — only errors
- `journalctl --since "1 hour ago"` — time filter
- Persisted logs: `/var/log/journal/`

## logrotate
- `/etc/logrotate.d/backup` — rotate daily, keep 7, compress

## systemd vs k3s
| systemd | k3s |
|---------|-----|
| unit file | deployment yaml |
| systemctl start | kubectl apply |
| journalctl -u | kubectl logs |
| enable | always-on controller |
| no scaling | replicas |
| one machine | cluster |
