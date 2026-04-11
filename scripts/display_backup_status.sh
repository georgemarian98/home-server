#!/usr/bin/env bash

if ! command -v toilet &> /dev/null; then
    echo "[ERROR] toilet is not installed. Please install toilet to use this script."
    exit 1
fi

if ! command -v boxes &> /dev/null; then
    echo "[ERROR] boxes is not installed. Please install boxes to use this script."
    exit 1
fi

RED='\033[0;31m'
GREEN='\033[0;32m'
NC='\033[0m' # No Color

BACKUP_LOG_DIR="$HOME/backup_logs"
REPORT_FILE="$BACKUP_LOG_DIR/backup_status_report_$(date +%Y_%m_%d).txt"

if [[ ! -f "$REPORT_FILE" ]]; then
    REPORT_FILE="$BACKUP_LOG_DIR/backup_status_report_$(date -d "yesterday" +%Y_%m_%d).txt"
fi

if [[ ! -f "$REPORT_FILE" ]]; then
    echo "[ERROR] Backup status report file not found!"
    exit 1
fi

REPORT_TEXT=$(cat "$REPORT_FILE")

COLOR=$GREEN
STATUS="Success"

if [[ "$REPORT_TEXT" != *"Success"* ]]; then
    STATUS="Failed"
    COLOR=$RED
fi

MESSAGE=$(echo "$STATUS" | toilet -f smmono12)
MESSAGE+=$'\n'"$(echo "$REPORT_TEXT" | tail -n +3)"

echo -e "${COLOR}"
toilet -f wideterm "======= Nightly Backup Status ======="
echo "$MESSAGE" | boxes -d ansi-double -s 75
echo -e "${NC}"