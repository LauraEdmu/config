#!/usr/bin/env bash

set -euo pipefail

export DEBIAN_FRONTEND=noninteractive

sudo install -d -o laura -g laura /world
sudo install -d -o laura -g laura /logs
sudo install -d -o laura -g laura /world-root

FSTAB_ENTRY="
/dev/disk/by-id/scsi-0Linode_Volume_Terraria  /world  btrfs  subvol=@world,noatime,nofail,compress=zstd:3  0  0
/dev/disk/by-id/scsi-0Linode_Volume_Terraria  /logs  btrfs  subvol=@logs,noatime,nofail,compress=zstd:3  0  0
/dev/disk/by-id/scsi-0Linode_Volume_Terraria  /world-root  btrfs  subvolid=5,noatime,nofail  0  0
"
echo "$FSTAB_ENTRY" | sudo tee -a /etc/fstab > /dev/null
sudo mount -a

echo "World files mounted at /world and /world-root"
