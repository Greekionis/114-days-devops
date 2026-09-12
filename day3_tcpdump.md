# Day 3: tcpdump + k3s Networking

## TCP Three-Way Handshake
1. SYN (client → server)
2. SYN-ACK (server → client)
3. ACK (client → server)

## tcpdump Flags
| Symbol | Flag | Meaning |
|--------|------|---------|
| [S] | SYN | Connection request |
| [S.] | SYN-ACK | Connection accepted |
| [.] | ACK | Acknowledgment |
| [F] | FIN | Connection close |
| [R] | RST | Connection reset |

## Interface Map (k3s single-node)
| Traffic | Interface |
|---------|-----------|
| kubectl → API | lo:6443 |
| Pod ↔ Pod same node | cni0 |
| Pod ↔ Pod cross-node | flannel.1 |
| External → NodePort | eth0 |

## Attack Signatures
- Port scan: many SYNs → many ports, 1 IP
- SYN flood: many SYNs → 1 port, fake IPs
- DDoS: many SYNs → 1 port, many real IPs

## Commands
```bash
sudo tcpdump -i any port 6443 -n -w ~/kubectl.pcap
sudo tcpdump -r ~/kubectl.pcap -n -A
sudo tcpdump 'tcp[tcpflags] & tcp-syn != 0' -n
