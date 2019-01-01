#!/bin/sh

cd my-cluster
ceph-deploy install --release=luminous admin-node
ceph-deploy install --release=luminous admin-node

ceph-deploy admin admin-node

sudo ceph osd pool create rbd 25
sudo rbd pool init rbd
sudo rbd create foo --size 4096 --image-feature layering
sudo rbd map foo --name client.admin
sudo mkfs.ext4 -m0 /dev/rbd/rbd/foo
sudo mkdir /mnt/ceph-block-device
sudo mount /dev/rbd/rbd/foo /mnt/ceph-block-device
ls /mnt/ceph-block-device/
