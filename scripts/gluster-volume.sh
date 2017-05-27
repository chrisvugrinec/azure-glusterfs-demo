#!/bin/bash
for host in $(cat /tmp/tmp_hosts | grep VM | sed 's/^.*[\ ]//')
do
  gluster peer probe $host
  nr=$(echo $host | sed 's/^.*[-]//' | sed 's/VM//')
  command+=" "$host:/mnt/brick$nr/dist-vol
done
gluster vol create dist-vol $command
gluster volume start dist-vol
