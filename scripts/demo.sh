#!/bin/bash

echo "name of your solution: (should be unique as it will be used in DNS)"
read resourcegroup

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
  --location "westeurope"


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
   sed -in 's/X_DNSNAME_X/'$dnsname'/' ./output/gfs-machine-parameters$i.json
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
