#!/bin/bash

echo "which resourcegroup"
read resourcegroup

# Create network
echo "creating network:"
azure group deployment create $resourcegroup --template-file vnet.json


