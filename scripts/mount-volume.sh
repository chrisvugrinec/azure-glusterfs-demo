#!/bin/bash

hostname=`hostname`
# Mounting the gluster volume
mount -t glusterfs $hostname:/dist-vol /mnt/gluster
