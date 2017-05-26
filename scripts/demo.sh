#!/bin/bash

echo "name of your solution: (should be unique as it will be used in DNS)"
read resourcegroup

region="westeurope"

echo "how many machines would you like to create:"
read nrofmachines

echo "username:"
read username

echo "password:"
read password

dnsname=$resourcegroup

vnetname="vnet-"$resourcegroup
snetname="subnet-"$resourcegroup

az login
az account list --output table 
echo "please select subscription:"
read subscription
az account set --subscription $subscription

# Create resourcegroup
echo "creating resource group:"
az group create \
  --name $resourcegroup \
  --location $region


# Create network
echo "creating network:"
az group deployment create \
  --name "vnet-"$resourcegroup \
  --resource-group $resourcegroup \
  --template-file vnet.json


tmpkey=`echo $(cat ~/.ssh/id_rsa.pub)`
sshKey=$(echo "$tmpkey" | sed 's/\//\\\//g')
echo "Creating machines with key: "$sshKey


if [ ! -d output ] 
then
  echo "creating output directory"
  mkdir output
fi

for (( i=1; i <= $nrofmachines; i++ ))
do
   echo "creating arm template for machine: ./output/gfs-machine-parameters"$i
   cat gfs-machine-parameters.json | sed 's/X_USERNAME_X/'$username'/' > ./output/gfs-machine-parameters$i.json
   sed -in 's/X_PASSWORD_X/'$password'/' ./output/gfs-machine-parameters$i.json
   sed -in 's/X_DNSNAME_X/'$dnsname'-'$i'/' ./output/gfs-machine-parameters$i.json
   sed -in 's/X_VNET_X/vnet-'$resourcegroup'/' ./output/gfs-machine-parameters$i.json
   sed -in 's/X_SUBNET_X/subnet-'$resourcegroup'-1/' ./output/gfs-machine-parameters$i.json
   sed -in 's/X_RESOURCEGROUP_X/'$resourcegroup'/' ./output/gfs-machine-parameters$i.json
   sed -in "s/X_SSH_X/\"$sshKey\"/g" ./output/gfs-machine-parameters$i.json
done

for (( i=1; i <= $nrofmachines; i++ ))
do
   echo "creating azure machine:: ./output/gfs-machine-parameters"$i
   az group deployment create \
     --name $resourcegroup \
     --resource-group $resourcegroup \
     --template-file gfs-machine.json \
     --parameters @./output/gfs-machine-parameters$i.json 
done

echo "distributing keys:"
for (( i=1; i <= $nrofmachines; i++ ))
do

  echo "adding host: "$dnsname-$i".$region.cloudapp.azure.com to knownhosts file"
  ssh-keyscan -H $dnsname-$i.$region.cloudapp.azure.com >>~/.ssh/known_hosts
  echo "copying the key"
  sshpass -p "$password" ssh-copy-id -f $username@$dnsname-$i.$region.cloudapp.azure.com
done

# Ansible config

if [ ! -d /etc/ansible ]
then
  mkdir /etc/ansible
fi

echo "[glusterfs-cluster]">/etc/ansible/hosts

echo "config ansible:"
for (( i=1; i <= $nrofmachines; i++ ))
do
  echo "adding host: "$dnsname-$i".$region.cloudapp.azure.com to ansible hostfile"
  echo "$dnsname-$i.$region.cloudapp.azure.com">>/etc/ansible/hosts
done

# Hosts file

echo "" >tmp_hosts

for (( i=1; i <= $nrofmachines; i++ ))
do
  echo "adding hosts line:"
  ip=$(ssh $username@$dnsname-$i.$region.cloudapp.azure.com 'hostname --ip-address')
  echo "ip: "$ip
  host=$(ssh $username@$dnsname-$i.$region.cloudapp.azure.com 'hostname')
  echo "host: "$host
  echo $ip"   "$host>>tmp_hosts
done

echo "now configuring with ansible"
ansible-playbook config.yaml
