#!/bin/bash

telegram_bot_token="${TELEGRAM_BOT_TOKEN}"
telegram_chat_id="${TELEGRAM_CHAT_ID}"

message="❌ Build Failed: ${MESSAGE}%0ACheck details: ${GITHUB_SERVER_URL}/${GITHUB_REPOSITORY}/actions"

curl -s -X POST "https://api.telegram.org/bot${telegram_bot_token}/sendMessage" \
     -d chat_id="${telegram_chat_id}" \
     -d text="$message"
