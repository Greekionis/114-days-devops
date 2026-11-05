# 🚀 DevOps Engineering Portfolio

Hi, I'm Denis (Greekionis). This repository documents my intensive 114-day journey mastering DevOps and Cloud Infrastructure. 

## 🎯 My Goal
Seeking a mid-level US Remote DevOps Engineer role. I have production experience with Ceph, MinIO, vCenter, and SAN storage, and I am actively building cloud-native infrastructure.

## 🛠️ Tech Stack & Tools
- **Containers & Orchestration:** Docker, Kubernetes (Vanilla & K3s), Helm
- **CI/CD & GitOps:** GitHub Actions, ArgoCD
- **Infrastructure as Code:** Terraform
- **Observability:** Prometheus, Grafana
- **Storage:** Ceph, MinIO (S3), LVM, vCenter
- **OS & Networking:** Linux (Debian/Ubuntu), TCP/IP, Calico, iptables

## 🏆 Capstone Project: End-to-End GitOps Pipeline
I built a fully automated pipeline:
1. **Code Push:** Developer pushes code to GitHub.
2. **CI (GitHub Actions):** Builds a Docker image, tags it with the Git commit SHA, and pushes it to GHCR.
3. **Manifest Update:** The pipeline updates the Kubernetes YAML with the new image tag and commits it.
4. **CD (ArgoCD):** ArgoCD detects the Git change and deploys it to a 3-node Kubernetes cluster.
5. **Monitoring:** Prometheus and Grafana monitor the cluster health.

*[Link to Capstone Folder](./capstone)*

## 📚 Key Modules Completed
- [Day 3: Networking & tcpdump](./day3_tcpdump.md)
- [Day 6: Storage & PersistentVolumes](./day6_storage_k8s.md)
- [Day 15: Health Checks & Probes](./day15_probes.md)
- [Day 18: Multi-node & Calico Networking](./day18_multinode.md)
- [Day 19: Terraform & IaC](./day19_terraform.md)
- [Day 22: GitOps with ArgoCD](./day22-argocd-app)
