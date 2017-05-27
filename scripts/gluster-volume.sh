#!/bin/bash

# Creating the create gluster  cluster command
# this generate the distributed cluster, you can also have replicated or distributed and replicated..have a look at:
# https://blogs.msdn.microsoft.com/azurecat/2017/03/31/implementing-glusterfs-on-azure-hpc-scalable-parallel-file-system/
# command will look something like:
# gluster vol create dist-vol glusterdemo-chris-1VM:/mnt/brick1/dist-vol glusterdemo-chris-2VM:/mnt/brick2/dist-vol 
#

mkdir -p /mnt/gluster
hostname=`hostname`
nr=$(echo $hostname | sed 's/^.*[-]//' | sed 's/VM//')

# creating the gluster cluster, only on 1st machine needed
if [[ $nr == "1" ]]
then
  # prep
  for host in $(cat /tmp/tmp_hosts | sort -n | grep VM | sed 's/^.*[\ ]//')
  do
    gluster peer probe $host
    nr=$(echo $host | sed 's/^.*[-]//' | sed 's/VM//')
    command+=" "$host:/mnt/brick$nr/dist-vol
  done
  echo "command to be executed: gluster vol create dist-vol $command"

  gluster vol create dist-vol $command
  gluster volume start dist-vol
fi


# Mounting the gluster volume
mount -t glusterfs $hostname:/dist-vol /mnt/gluster
