#!/bin/bash

telegram_bot_token="${TELEGRAM_BOT_TOKEN}"
telegram_chat_id="${TELEGRAM_CHAT_ID}"
message="${MESSAGE}"

reply_markup=$(cat <<EOF
{
  "inline_keyboard": [
    [{"text": "Deploy", "callback_data": "do_deploy"}]
  ]
}
EOF
)

curl -s -X POST "https://api.telegram.org/bot${telegram_bot_token}/sendMessage" \
     -d chat_id="${telegram_chat_id}" \
     -d text="$message" \
     -d "reply_markup=${reply_markup}"
