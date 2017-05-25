#!/bin/bash

echo "which resourcegroup"
read resourcegroup

# Create network
echo "creating network:"
#azure group deployment create $resourcegroup --template-file vnet.json

echo "how many machines would you like to create:"
read nrofmachines

echo "username:"
read username

echo "password:"
read password

dnsname=gluster

vnetname="vnet-"$resourcegroup
snetname="subnet-"$resourcegroup

if [ ! -d output ] 
then
  mkdir output
fi

for (( i=1; i <= $nrofmachines; i++ ))
do
 echo $i
   cat gfs-machine-parameters.json | sed 's/X_USERNAME_X/$username/' > ./output/gfs-machine-parameters$i.json
   #"vmSize":   { "value": "Standard_D1" },
    #"username": { "value": "X_USERNAME_X" },
    #"password": { "value": "X_PASSWORD_X" },
    #"dnsNameForPublicIP": { "value": "X_DNSNAME_X"  },
    #"existingVirtualNetworkName": { "value": "X_VNET_X" },
    #"existingSubnetName": { "value": "X_SUBNET_X" },
    #"existingVirtualNetworkResourceGroup": { "value": "X_RESOURCEGROUP_X" }
done




