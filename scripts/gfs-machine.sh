#!/bin/bash
echo "templatefile:"
read templatefile
echo "resourcegroup:" 
read resourcegroup
echo "deployment name"
read deploymentname
az group deployment create \
     --name $deploymentname \
     --resource-group $resourcegroup \
     --template-file  gfs-machine.json \
     --parameters @$templatefile 
#     --mode Complete
