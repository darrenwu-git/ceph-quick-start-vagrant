#!/bin/sh

sudo yum install -y https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm

cat << EOM > /tmp/ceph.repo
[ceph-noarch]
name=Ceph noarch packages
baseurl=https://download.ceph.com/rpm-luminous/el7/noarch
enabled=1
gpgcheck=1
type=rpm-md
gpgkey=https://download.ceph.com/keys/release.asc
EOM

sudo mv /tmp/ceph.repo /etc/yum.repos.d/

sudo yum update
sudo yum install -y ceph-deploy

sudo yum install -y ntp ntpdate ntp-doc

cat << EOM > ~/.ssh/config
Host node1
   Hostname node1
   User vagrant
   StrictHostKeyChecking no
   UserKnownHostsFile=/dev/null
Host node2
   Hostname node2
   User vagrant
   StrictHostKeyChecking no
   UserKnownHostsFile=/dev/null
Host node3
   Hostname node3
   User vagrant
   StrictHostKeyChecking no
   UserKnownHostsFile=/dev/null
EOM
sudo chmod 600 ~/.ssh/config

# disable selinux
sudo sed -i "s/SELINUX=enforcing/SELINUX=disabled/" /etc/selinux/config

sudo yum install -y yum-plugin-priorities

sudo yum install -y python-setuptools




### storage setup
DIR=~/my-cluster
mkdir $DIR
cd $DIR
ceph-deploy new node1

# FIXME: depends on public network
echo "public network = 192.168.1.0/24" >> ceph.conf

ceph-deploy install --release=luminous node1 node2 node3

ceph-deploy mon create-initial

ceph-deploy admin node1 node2 node3

ceph-deploy mgr create node1

ceph-deploy osd create --data /dev/sdb node1
ceph-deploy osd create --data /dev/sdb node2
ceph-deploy osd create --data /dev/sdb node3


ceph-deploy mds create node1

ceph-deploy mon add node2
ceph-deploy mon add node3


ceph-deploy mgr create node2 node3


ceph-deploy rgw create node1
