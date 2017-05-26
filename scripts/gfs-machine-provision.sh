#!/bin/bash
sshKey="$1 $2 $3"
apt-get -y update
apt-get -y install glusterfs-server
#ssh-keygen -t rsa -f  ~/.ssh/id_rsa -P ""
mkdir ~/.ssh
echo "$sshKey">~/.ssh/authorized_keys
chmod 600 ~/.ssh/authorized_keys


