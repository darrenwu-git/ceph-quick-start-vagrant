# Quick Setup ceph cluster in VirtualBox by vagrant
Installing ceph on VMs for testing environment is the readily way for trial, debugging, development.
This vagrantfile helps to quick install virtualbox on Ubuntu 18.04 host machine. Install centos 7 guest VMs with ceph nodes.
It follows [Ceph Installation(ceph-deploy)][ceph-deploy-install] instruction to setup 3 nodes VMs(node1 - node3), and with one admin-node VM for ceph-deploy and ceph-client. Once the admin-node VM be created, the provisioning would auto setup to nodes VMs by [admin-node-preflight.sh][preflight script].

### Requirements
- Host machine: Ubuntu 18.04
    - Runs 4 VMs on centos 7
- Each guest VM(requires 4 VMs):
    - CPU: 1 core
    - RAM: 1GB
    - Disk:
        - 40GB for system
        - 10GB for ceph

### Install vagrant and virtualbox on Ubuntu 18.04
```
$ sudo apt install -y virtualbox
$ sudo apt install -y vagrant
```

### Clone the vagrantfile
```
$ mkdir vagrant
$ cd vagrant
$ git clone https://github.com/musicguitar/ceph-quick-start-vagrant.git
```

### Setup VMs
```
$ cd ceph-quick-start-vagrant/vagrant_space/
$ vagrant up
```
After few minutes to setup VMs. The node1-node3 would be ready for ceph OSDs. The admin-node for client and admin testing.

### Client testing
Login to admin-node for the client testing.
```
$ vagrant ssh admin-node
```
Setup pool and mount ceph storage for trial. The steps are included in the [admin-node-client.sh][client script].

```
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
```


###### tags: `ceph` `vagrant`
[ceph-deploy-install]:http://docs.ceph.com/docs/mimic/start/
[preflight script]:https://github.com/musicguitar/ceph-quick-start-vagrant/blob/master/vagrant_space/admin-node-preflight.sh
[client script]:https://github.com/musicguitar/ceph-quick-start-vagrant/blob/master/vagrant_space/admin-node-client.sh
