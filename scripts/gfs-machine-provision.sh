#!/bin/bash
sshKey=$1
apt-get -y update
apt-get -y install glusterfs-server
ssh-keygen -t rsa -f  ~/.ssh/id_rsa -P ""
echo "$sshKey">~/.ssh/authorized_keys
chmod 600 ~/.ssh/authorized_keys


