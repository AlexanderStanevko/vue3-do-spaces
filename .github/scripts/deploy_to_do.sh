#!/bin/bash

# Аутентификация
TOKEN="${DIGITAL_OCEAN_API_TOKEN}"
APP_ID="${DIGITAL_OCEAN_APP_ID}"

# URL для деплоя на DigitalOcean
DEPLOY_URL="https://api.digitalocean.com/v2/apps/${APP_ID}/deployments"

# Создание нового деплоя
response=$(curl -X POST "$DEPLOY_URL" \
     -H "Authorization: Bearer $TOKEN" \
     -H "Content-Type: application/json")

echo "Response from DigitalOcean: $response"
