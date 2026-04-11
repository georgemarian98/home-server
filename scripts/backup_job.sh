#!/usr/bin/env bash

CURRENT_DIRECTORY="$(dirname $(readlink -f "$0"))"

# .env.backup file should contain the following variables:
# PROXMOX_MAC_ADDRESS=<MAC_ADDRESS> - MAC address of the Proxmox server for wake-on-LAN
# PROXMOX_IP=<IP_ADDRESS> - IP address of the Proxmox server for SSH access
# PROXMOX_SSH_USER=<SSH_USER> - SSH user for the Proxmox server
# DEBIAN_IP=<IP_ADDRESS> - IP address of the Debian server for SSH access
# DISCORD_WEBHOOK_TOKEN=<TOKEN> - Webhook token for sending notifications to Discord
source "$CURRENT_DIRECTORY/.env.backup"

backup_server()
{
    # Wake up proxmox server if it's powered off
    if ! ping -c 1 "$PROXMOX_IP" &> /dev/null; then
        echo "[INFO] Proxmox server is offline. Sending wake-on-LAN packet..."
        wakeonlan "$PROXMOX_MAC_ADDRESS"
        
        COUNT=0
        echo "[INFO] Waiting for Proxmox server to wake up..."
        while ! ping -c 1 "$PROXMOX_IP" &> /dev/null && ! ping -c 1 "$DEBIAN_IP" &> /dev/null; do
            sleep 5
            ((COUNT++))
            if [[ $COUNT -ge 60 ]]; then
                echo "[ERROR] Timeout waiting for servers."
                exit 1
            fi
        done
        echo "[INFO] Proxmox server is online."
    fi

    while docker node ls 2>&1 | grep "Error response from daemon" > /dev/null; do
        echo "[INFO] Waiting for Gondolin server to fully boot up and the docker containers to start..."
        sleep 60
    done
 
    BACKUP_LOG_DIR="$HOME/backup_logs"
    ANSIBLE_LOG_FILE="$BACKUP_LOG_DIR/ansible_log_$(date +%Y_%m_%d).txt"

    mkdir -p "$BACKUP_LOG_DIR"

    # Keep the ansible log file only on failure
    echo "[INFO] Starting backup process..."
    cd "$CURRENT_DIRECTORY/../ansible"
    if ansible-playbook backup.yaml > "$ANSIBLE_LOG_FILE" 2>&1; then
        rm "$ANSIBLE_LOG_FILE"
        echo "[INFO] Backup completed successfully."
    fi

    # Shutdown the proxmox server after the backup is done
    echo "[INFO] Shutting down Proxmox server..."
    ssh "$PROXMOX_SSH_USER@$PROXMOX_IP" "shutdown -P now"
}

main()
{
    BEFORE_AVAILABLE_SPACE=$(du -sb "$HOME/usb_share/backup" | awk '{print $1}')

    backup_server
    
    AFTER_AVAILABLE_SPACE=$(du -sb  "$HOME/usb_share/backup" | awk '{print $1}')

    # Generate stats file
    STATS_FILE="${BACKUP_LOG_DIR}/STATS_$(date +%Y_%m_%d).txt"
    DURATION="$((($(date +%s) - $(date -d "today 04:00:00" +%s))/60))min"
    DATA_ADDED=$(echo $(( $AFTER_AVAILABLE_SPACE - $BEFORE_AVAILABLE_SPACE )) | numfmt --to=iec --suffix=B)
    AVAILABLE_SPACE="$(df -h "$HOME/usb_share" | tail -1 | awk '{print $4}')B"
    printf "Backup duration: ${DURATION}\nData added: ${DATA_ADDED}\nCurrent available space: ${AVAILABLE_SPACE}\n" > "${STATS_FILE}"
    
    # Send discord notification with the backup report
    echo "[INFO] Sending backup report to Discord..."
    $CURRENT_DIRECTORY/send_discord_notification.sh -t "${DISCORD_WEBHOOK_TOKEN}" -b

    # Delete old backup logs
    find "$BACKUP_LOG_DIR" -type f -name "backup_log_*.txt" -mtime +7 -delete
    rm "$STATS_FILE"
}

main