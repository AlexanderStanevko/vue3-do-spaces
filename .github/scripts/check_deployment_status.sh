#!/bin/bash

digital_ocean_app_id="${DIGITAL_OCEAN_APP_ID}"
digital_ocean_api_token="${DIGITAL_OCEAN_API_TOKEN}"
telegram_bot_token="${TELEGRAM_BOT_TOKEN}"
telegram_chat_id="${TELEGRAM_CHAT_ID}"
digital_ocean_url="https://cloud.digitalocean.com/apps/${digital_ocean_app_id}"
deployment_id="${DEPLOYMENT_ID}"

check_deployment_status() {
  curl -s -X GET "https://api.digitalocean.com/v2/apps/${digital_ocean_app_id}/deployments/${deployment_id}" \
    -H "Authorization: Bearer ${digital_ocean_api_token}" \
    -H "Content-Type: application/json" | jq -r '.deployment.phase'
}

deployment_phase=$(check_deployment_status)

while [[ "$deployment_phase" != "ACTIVE" ]]; do
  echo "Current deployment phase: $deployment_phase"
  if [[ "$deployment_phase" == "ERROR" ]]; then
    curl -s -X POST "https://api.telegram.org/bot${telegram_bot_token}/sendMessage" \
         -d chat_id="${telegram_chat_id}" \
         -d text="Deployment failed. Check details: ${digital_ocean_url}"
    exit 1
  elif [[ "$deployment_phase" == "SUPERSEDED" || "$deployment_phase" == "CANCELED" ]]; then
    curl -s -X POST "https://api.telegram.org/bot${telegram_bot_token}/sendMessage" \
         -d chat_id="${telegram_chat_id}" \
         -d text="Deployment was superseded or canceled. Check details: ${digital_ocean_url}"
    exit 1
  fi
  sleep 10
  deployment_phase=$(check_deployment_status)
  echo "Current deployment phase222222222: $deployment_phase"
done

curl -s -X POST "https://api.telegram.org/bot${telegram_bot_token}/sendMessage" \
     -d chat_id="${telegram_chat_id}" \
     -d text="Deployment successful. Check details: ${digital_ocean_url}"