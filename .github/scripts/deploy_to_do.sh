# #!/bin/bash

# # Аутентификация
# TOKEN="${DIGITAL_OCEAN_API_TOKEN}"
# APP_ID="${DIGITAL_OCEAN_APP_ID}"

# # URL для деплоя на DigitalOcean
# DEPLOY_URL="https://api.digitalocean.com/v2/apps/${APP_ID}/deployments"

# # Создание нового деплоя
# response=$(curl -X POST "$DEPLOY_URL" \
#      -H "Authorization: Bearer $TOKEN" \
#      -H "Content-Type: application/json")

# echo "Response from DigitalOcean: $response"

#!/bin/bash

TOKEN="${DIGITAL_OCEAN_API_TOKEN}"
APP_ID="${DIGITAL_OCEAN_APP_ID}"

DEPLOY_URL="https://api.digitalocean.com/v2/apps/${APP_ID}/deployments"

response=$(curl -X POST "$DEPLOY_URL" \
     -H "Authorization: Bearer $TOKEN" \
     -H "Content-Type: application/json")

echo "Response from DigitalOcean: $response"

# Извлечение и сохранение ID деплоя
deployment_id=$(echo $response | jq -r '.deployment.id')
echo "Deployment ID: $deployment_id"

# Сохранение ID деплоя для использования в последующих шагах
echo "DEPLOYMENT_ID=$deployment_id" >> $GITHUB_ENV
