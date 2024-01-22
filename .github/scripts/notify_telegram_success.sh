# #!/bin/bash

# telegram_bot_token="${TELEGRAM_BOT_TOKEN}"
# telegram_chat_id="${TELEGRAM_CHAT_ID}"
# message="${MESSAGE}"

# reply_markup=$(cat <<EOF
# {
#   "inline_keyboard": [
#     [{"text": "Deploy", "callback_data": "do_deploy"}]
#   ]
# }
# EOF
# )

# curl -s -X POST "https://api.telegram.org/bot${telegram_bot_token}/sendMessage" \
#      -d chat_id="${telegram_chat_id}" \
#      -d text="$message" \
#      -d "reply_markup=${reply_markup}"

#!/bin/bash

telegram_bot_token="${TELEGRAM_BOT_TOKEN}"
telegram_chat_id="${TELEGRAM_CHAT_ID}"
message="${MESSAGE}"
github_ref="${GITHUB_REF}"

# Функция для отправки сообщения в Telegram
send_telegram_message() {
    # Проверка на наличие reply_markup и формирование соответствующего параметра
    local reply_markup_param=""
    if [[ -n "$reply_markup" ]]; then
        reply_markup_param="-d reply_markup=${reply_markup}"
    fi

    curl -s -X POST "https://api.telegram.org/bot${telegram_bot_token}/sendMessage" \
         -d chat_id="${telegram_chat_id}" \
         -d text="${message}" \
         ${reply_markup_param}
}

# Определение, является ли ветка DEV
if [[ "$github_ref" == "refs/heads/DEV" ]]; then
    # Если ветка DEV, отправить сообщение без кнопки
    send_telegram_message
else
    # Для других веток, отправить сообщение с кнопкой
    reply_markup=$(cat <<EOF
    {
      "inline_keyboard": [
        [{"text": "Deploy", "callback_data": "do_deploy"}]
      ]
    }
EOF
    )
    send_telegram_message
fi
