# azure-glusterfs-demo

This shows you how you can easily setup a gluster cluster on Azure, using Ansible in combination with the Azure ARM templates.

Gluster is an open source solution that provides you network storage freedom. Some cool gluster features:
- Use all kinds of storage (like the Azure Data disks in this demo) and access them through the gluster FS filetype
- Access the gluster volume as one NFS disk from several hosts
- Replicate files over several disks
- Save your large files striped over several storage bricks
- Easily add or shrink your storage by adding or removing bricks to your gluster volume
- Tune your IO behaviour with several tuning settings

Technology used: Ubuntu/ Gluster/ Docker/ Azure ARM templates/ AZ CLI 2.0/ Ansible
