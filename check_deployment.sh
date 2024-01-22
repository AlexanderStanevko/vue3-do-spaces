#!/bin/bash

# check_deployment.sh
deployment_status=""
app_id=$1
api_token=$2

while [ "$deployment_status" != "ACTIVE" ]; do
  response=$(curl -X GET "https://api.digitalocean.com/v2/apps/$app_id/deployments" \
    -H "Authorization: Bearer $api_token" \
    -H "Content-Type: application/json")
  deployment_status=$(echo $response | jq -r '.deployments[0].progress')
  echo "Deployment status: $deployment_status"
  if [ "$deployment_status" == "ERROR" ]; then
    echo "Deployment failed"
    exit 1
  fi
  sleep 15
done

echo $deployment_status
