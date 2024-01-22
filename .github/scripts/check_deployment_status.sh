# #!/bin/bash

# digital_ocean_app_id="${DIGITAL_OCEAN_APP_ID}"
# digital_ocean_api_token="${DIGITAL_OCEAN_API_TOKEN}"
# telegram_bot_token="${TELEGRAM_BOT_TOKEN}"
# telegram_chat_id="${TELEGRAM_CHAT_ID}"
# digital_ocean_url="https://cloud.digitalocean.com/apps/${digital_ocean_app_id}"

# check_deployment_status() {
#   curl -s -X GET "https://api.digitalocean.com/v2/apps/${digital_ocean_app_id}/deployments" \
#     -H "Authorization: Bearer ${digital_ocean_api_token}" \
#     -H "Content-Type: application/json" | jq -r '.deployments[0].progress'
# }

# deployment_status=$(check_deployment_status)
# while [[ $deployment_status != "ACTIVE" ]]; do
#   if [[ $deployment_status == "ERROR" ]]; then
#     curl -s -X POST "https://api.telegram.org/bot${telegram_bot_token}/sendMessage" \
#          -d chat_id="${telegram_chat_id}" \
#          -d text="Deployment failed. Check details: ${digital_ocean_url}"
#     exit 1
#   fi
#   sleep 15
#   deployment_status=$(check_deployment_status)
# done

# curl -s -X POST "https://api.telegram.org/bot${telegram_bot_token}/sendMessage" \
#      -d chat_id="${telegram_chat_id}" \
#      -d text="Deployment successful. Check details: ${digital_ocean_url}"


# #!/bin/bash

# digital_ocean_app_id="${DIGITAL_OCEAN_APP_ID}"
# digital_ocean_api_token="${DIGITAL_OCEAN_API_TOKEN}"
# telegram_bot_token="${TELEGRAM_BOT_TOKEN}"
# telegram_chat_id="${TELEGRAM_CHAT_ID}"
# digital_ocean_url="https://cloud.digitalocean.com/apps/${digital_ocean_app_id}"

# check_deployment_status() {
#   curl -s -X GET "https://api.digitalocean.com/v2/apps/${digital_ocean_app_id}/deployments" \
#     -H "Authorization: Bearer ${digital_ocean_api_token}" \
#     -H "Content-Type: application/json" | jq -r '.deployments[0].phase'
# }

# deployment_phase=$(check_deployment_status)
# while [[ "$deployment_phase" != "ACTIVE" ]]; do
#   if [[ "$deployment_phase" == "ERROR" ]]; then
#     curl -s -X POST "https://api.telegram.org/bot${telegram_bot_token}/sendMessage" \
#          -d chat_id="${telegram_chat_id}" \
#          -d text="Deployment failed. Check details: ${digital_ocean_url}"
#     exit 1
#   elif [[ "$deployment_phase" == "SUPERSEDED" || "$deployment_phase" == "CANCELED" ]]; then
#     curl -s -X POST "https://api.telegram.org/bot${telegram_bot_token}/sendMessage" \
#          -d chat_id="${telegram_chat_id}" \
#          -d text="Deployment was superseded or canceled. Check details: ${digital_ocean_url}"
#     exit 1
#   fi
#   sleep 10
#   deployment_phase=$(check_deployment_status)
# done

# curl -s -X POST "https://api.telegram.org/bot${telegram_bot_token}/sendMessage" \
#      -d chat_id="${telegram_chat_id}" \
#      -d text="Deployment successful. Check details: ${digital_ocean_url}"


#!/bin/bash

digital_ocean_app_id="${DIGITAL_OCEAN_APP_ID}"
digital_ocean_api_token="${DIGITAL_OCEAN_API_TOKEN}"
telegram_bot_token="${TELEGRAM_BOT_TOKEN}"
telegram_chat_id="${TELEGRAM_CHAT_ID}"
digital_ocean_url="https://cloud.digitalocean.com/apps/${digital_ocean_app_id}"

echo "Checking the deployment status..."

check_deployment_status() {
  response=$(curl -s -X GET "https://api.digitalocean.com/v2/apps/${digital_ocean_app_id}/deployments" \
    -H "Authorization: Bearer ${digital_ocean_api_token}" \
    -H "Content-Type: application/json")
  echo "$response" | jq .
  echo "$response" | jq -r '.deployments[0].phase'
}

deployment_phase=$(check_deployment_status)
while [[ "$deployment_phase" != "ACTIVE" ]]; do
  echo "Current deployment phase: $deployment_phase"
  if [[ "$deployment_phase" == "ERROR" ]]; then
    message="Deployment failed. Check details: ${digital_ocean_url}"
    echo "$message"
    curl -s -X POST "https://api.telegram.org/bot${telegram_bot_token}/sendMessage" \
         -d chat_id="${telegram_chat_id}" \
         -d text="$message"
    exit 1
  elif [[ "$deployment_phase" == "SUPERSEDED" || "$deployment_phase" == "CANCELED" ]]; then
    message="Deployment was superseded or canceled. Check details: ${digital_ocean_url}"
    echo "$message"
    curl -s -X POST "https://api.telegram.org/bot${telegram_bot_token}/sendMessage" \
         -d chat_id="${telegram_chat_id}" \
         -d text="$message"
    exit 1
  fi
  sleep 10
  deployment_phase=$(check_deployment_status)
done

message="Deployment successful. Check details: ${digital_ocean_url}"
echo "$message"
curl -s -X POST "https://api.telegram.org/bot${telegram_bot_token}/sendMessage" \
     -d chat_id="${telegram_chat_id}" \
     -d text="$message"
