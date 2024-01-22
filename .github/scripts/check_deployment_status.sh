#!/bin/bash

digital_ocean_app_id="${DIGITAL_OCEAN_APP_ID}"
digital_ocean_api_token="${DIGITAL_OCEAN_API_TOKEN}"
telegram_bot_token="${TELEGRAM_BOT_TOKEN}"
telegram_chat_id="${TELEGRAM_CHAT_ID}"
digital_ocean_url="https://cloud.digitalocean.com/apps/${digital_ocean_app_id}"
deployment_id="${DEPLOYMENT_ID}"

# Функция отправки сообщения в Telegram
send_telegram_message() {
    local message=$1
    curl -s -X POST "https://api.telegram.org/bot${telegram_bot_token}/sendMessage" \
         -d chat_id="${telegram_chat_id}" \
         -d text="$message"
}

check_deployment_status() {
  curl -s -X GET "https://api.digitalocean.com/v2/apps/${digital_ocean_app_id}/deployments/${deployment_id}" \
    -H "Authorization: Bearer ${digital_ocean_api_token}" \
    -H "Content-Type: application/json" | jq -r '.deployment.phase'
}

deployment_phase=$(check_deployment_status)

while [[ "$deployment_phase" != "ACTIVE" ]]; do
  echo "Current deployment phase: $deployment_phase"
  if [[ "$deployment_phase" == "ERROR" ]]; then
    send_telegram_message "Deployment failed. Check details: ${digital_ocean_url}"
    exit 1
  elif [[ "$deployment_phase" == "SUPERSEDED" || "$deployment_phase" == "CANCELED" ]]; then
    send_telegram_message "Deployment was superseded or canceled. Check details: ${digital_ocean_url}"
    exit 1
  fi
  sleep 10
  deployment_phase=$(check_deployment_status)
done

send_telegram_message "Deployment (ID: ${deployment_id}) successful. Check details: ${digital_ocean_url}"
