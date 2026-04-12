#!/usr/bin/env bash

if ! command -v toilet &> /dev/null; then
    echo "[ERROR] toilet is not installed. Please install toilet to use this script."
    exit 1
fi

if ! command -v boxes &> /dev/null; then
    echo "[ERROR] boxes is not installed. Please install boxes to use this script."
    exit 1
fi

remote_file_exists() 
{
    if [[ -z "$REMOTE_SSH_HOST" ]]; 
    then
        echo "[ERROR] REMOTE_SSH_HOST variable is not set."
        exit 1
    fi

    local FILE_PATH="$1"

    echo "$(ssh "$REMOTE_SSH_HOST" "test -f '$FILE_PATH'" && echo "0" || echo "1")"
}

usage()
{
    printf "Usage: $0 [-r REMOTE_SSH_HOST]\n
    -r - Provide the SSH host for the remote server to check the backup status report file\n"
    exit 1
}

IS_REMOTE="false"
while getopts "r:" arg;
do
    case $arg in
        r) REMOTE_SSH_HOST=$OPTARG 
           IS_REMOTE="true"
           ;;
        *) usage
    esac
done


BACKUP_LOG_DIR="$HOME/backup_logs"
REPORT_FILE="$BACKUP_LOG_DIR/backup_status_report_$(date +%Y_%m_%d).txt"

# Check if the backup status report file exists, if not check for yesterday's report file
if [[ "$IS_REMOTE" == "false" ]]; 
then
    if [[ ! -f "$REPORT_FILE" ]]; 
    then
        REPORT_FILE="$BACKUP_LOG_DIR/backup_status_report_$(date -d "yesterday" +%Y_%m_%d).txt"
    fi

    if [[ ! -f "$REPORT_FILE" ]]; 
    then
        echo "[ERROR] Backup status report file not found!"
        exit 1
    fi
else
    if [[ "$(remote_file_exists "$REPORT_FILE")" == "1" ]]; 
    then
        REPORT_FILE="$BACKUP_LOG_DIR/backup_status_report_$(date -d "yesterday" +%Y_%m_%d).txt"
    fi

    if [[ "$(remote_file_exists "$REPORT_FILE")" == "1" ]]; 
    then
        echo "[ERROR] Remote backup status report file not found!"
        exit 1
    fi
fi

if [[ "$IS_REMOTE" == "false" ]]; then
    REPORT_TEXT=$(cat "$REPORT_FILE")
else
    REPORT_TEXT=$(ssh "$REMOTE_SSH_HOST" "cat '$REPORT_FILE'")
fi

RED='\033[0;31m'
GREEN='\033[0;32m'
NC='\033[0m' # No Color

COLOR=$GREEN
STATUS="Success"

if [[ "$REPORT_TEXT" != *"Success"* ]]; then
    STATUS="Failed"
    COLOR=$RED
fi

DATE=$(basename "$REPORT_FILE" | cut -d'_' -f4- | cut -d'.' -f1 | awk -F'_' '{print $3"."$2"."$1}')

MESSAGE=$(echo "$STATUS" | toilet -f smmono12)
MESSAGE+=$'\n'"$(echo "Date: $DATE")"
MESSAGE+=$'\n'"$(echo "$REPORT_TEXT" | tail -n +3)"

echo -e "${COLOR}"
toilet -f wideterm "======= Nightly Backup Status ======="
echo "$MESSAGE" | boxes -d ansi-double -s 75
echo -e "${NC}"