# Day 6: Storage + k8s PersistentVolumes

## LVM Resizing
- ext4: grow online, shrink offline (e2fsck first)
- XFS: grow online, CANNOT shrink
- `lvextend -L +1G` then `resize2fs` for ext4

## fstab Advanced Options
- `noatime` — don't update access time
- `nofail` — don't block boot if disk missing
- `_netdev` — wait for network
- Use UUID, not /dev/sdX (device names can change)

## Kubernetes Storage
| Concept | Purpose |
|---------|---------|
| PV | A piece of storage |
| PVC | A request for storage |
| StorageClass | Template for dynamic provisioning |

## Static vs Dynamic Provisioning
- Static: admin creates PV, developer creates PVC that binds
- Dynamic: developer creates PVC, provisioner auto-creates PV

## Access Modes
- RWO: one node, read-write (databases)
- ROX: many nodes, read-only
- RWX: many nodes, read-write (NFS, CephFS)

## Reclaim Policies
- Retain: keep PV after PVC deletion
- Delete: remove PV and storage
