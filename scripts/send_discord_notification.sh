#!/usr/bin/env bash

usage()
{
    printf "Usage: $0 [-t WEBHOOK_TOKEN] [-b]\n
    -t - Provide the webhook token for the discord notification\n
    -b - Send a notification to the discord channel with the provided message\n
    -s - Send a simple message to the discord channel\n"
    exit 1
}

backup_report()
{
    local CURRENT_DATE=$(date +"%Y_%m_%d")
    local BACKUP_LOG_DIR="${HOME}/backup_logs"
    local RED_COLOR="15075593"
    local GREEN_COLOR="5763719"

    local BACKUP_STATUS="Success"
    local EMBED_COLOR=$GREEN_COLOR
    local PAYLOAD_FIELDS=()

    local REPORT_FILE="$BACKUP_LOG_DIR/backup_status_report_${CURRENT_DATE}.txt"
    if [[ ! -f "$REPORT_FILE" ]]; then
        REPORT_FILE="$BACKUP_LOG_DIR/backup_status_report_$(date -d "yesterday" +%Y_%m_%d).txt"
    fi

    if [[ -f "$REPORT_FILE" ]];
    then
        local STATS=$(tail -n +3 "$REPORT_FILE")
        PAYLOAD_FIELDS=('{"name": "Stats", "value": "'$(echo "$STATS" | awk '{printf "%s\\n", $0}')'"}')
    fi

    local BACKUP_FILE="${BACKUP_LOG_DIR}/backup_log_${CURRENT_DATE}.txt"
    local CURL_FILE_ARGS=(-F "file1=@${BACKUP_FILE}")
    if [[ ! -f "$BACKUP_FILE" ]];
    then
        BACKUP_STATUS="Failed"
        EMBED_COLOR=$RED_COLOR
        CURL_FILE_ARGS=()
        PAYLOAD_FIELDS+=('{"name": "Error", "value": "Backup log file not found. The backup process might have failed before it could create the log file and/or the ansible log."}')
    fi

    local ANSIBLE_FILE="${BACKUP_LOG_DIR}/ansible_log_${CURRENT_DATE}.txt"
    if [[ -f "$ANSIBLE_FILE" ]];
    then
        BACKUP_STATUS="Failed"
        EMBED_COLOR=$RED_COLOR
        CURL_FILE_ARGS+=(-F "file2=@${ANSIBLE_FILE}")
    fi

    local PAYLOAD_JSON=$(cat <<EOF
{
  "username": "Autobackup",
  "embeds": [
    {
      "title": "Nightly backup status",
      "description": "Status: **${BACKUP_STATUS}**",
      "color": ${EMBED_COLOR},
      "fields": [ ${PAYLOAD_FIELDS[@]} ]
    }
  ]
}
EOF
)

    DISCORD_CURL_ARGS=(
        -F "payload_json=$PAYLOAD_JSON"
        "${CURL_FILE_ARGS[@]}"
    )
}

DISCORD_CURL_ARGS=()
DISCORD_WEBHOOOK_TOKEN=""

while getopts "t:bs:" arg;
do
    case $arg in
        b) backup_report ;;
        t) DISCORD_WEBHOOOK_TOKEN=$OPTARG ;;
        s) DISCORD_CURL_ARGS+=(-F "payload_json={\"content\": \"$OPTARG\"}") ;;
        *) usage
    esac
done

if [[ -z "${DISCORD_CURL_ARGS[@]}" || -z "$DISCORD_WEBHOOOK_TOKEN" ]];
then
    echo "[ERROR] No message or webhook token provided for the discord notification. Exiting..."
    exit 1
fi

curl -X POST "https://discord.com/api/webhooks/$DISCORD_WEBHOOOK_TOKEN" "${DISCORD_CURL_ARGS[@]}"