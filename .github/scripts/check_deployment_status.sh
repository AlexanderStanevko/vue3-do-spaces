#!/bin/bash

digital_ocean_app_id="${DIGITAL_OCEAN_APP_ID}"
digital_ocean_api_token="${DIGITAL_OCEAN_API_TOKEN}"
telegram_bot_token="${TELEGRAM_BOT_TOKEN}"
telegram_chat_id="${TELEGRAM_CHAT_ID}"
digital_ocean_url="https://cloud.digitalocean.com/apps/${digital_ocean_app_id}"

check_deployment_status() {
  curl -s -X GET "https://api.digitalocean.com/v2/apps/${digital_ocean_app_id}/deployments" \
    -H "Authorization: Bearer ${digital_ocean_api_token}" \
    -H "Content-Type: application/json" | jq -r '.deployments[0].progress'
}

deployment_status=$(check_deployment_status)
while [[ $deployment_status != "ACTIVE" ]]; do
  if [[ $deployment_status == "ERROR" ]]; then
    curl -s -X POST "https://api.telegram.org/bot${telegram_bot_token}/sendMessage" \
         -d chat_id="${telegram_chat_id}" \
         -d text="Deployment failed. Check details: ${digital_ocean_url}"
    exit 1
  fi
  sleep 30
  deployment_status=$(check_deployment_status)
done

curl -s -X POST "https://api.telegram.org/bot${telegram_bot_token}/sendMessage" \
     -d chat_id="${telegram_chat_id}" \
     -d text="Deployment successful. Check details: ${digital_ocean_url}"
