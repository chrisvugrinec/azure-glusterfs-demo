#!/bin/bash
echo "which resourcegroup"
read resourcegroup
echo "which template"
read template
azure group deployment create $resourcegroup --template-file $template
