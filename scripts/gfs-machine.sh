#!/bin/bash
echo "templatefile:"
read templatefile
echo "resourcegroup:" 
read resourcegroup
az group deployment create \
     --name gfs-machine \
     --resource-group $resourcegroup \
     --template-file  gfs-machine.json \
     --parameters @$templatefile
