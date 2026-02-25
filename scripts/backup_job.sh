#!/usr/bin/env bash

# .env.backup file should contain the following variables:
# PI_RESTIC_REPO=<user@host:path> # Restic repository for the Raspberry Pi backup
# HDD_RESTIC_REPO=<user@host:path> # Restic repository for the extra HDD backup
# PROXMOX_MAC_ADDRESS=<MAC_ADDRESS> # MAC address of the Proxmox server for wake-on-LAN
# PROXMOX_IP=<IP_ADDRESS> # IP address of the Proxmox server for SSH access
# GONDOLIN_IP=<IP_ADDRESS> # IP address of the Debian server for SSH access
# DOCKER_SERVICE_CONFIG_NAS_PATH=<path> # Path to the docker_volumes folder on the NAS
source ".env.backup"

# wakeup proxmox server if it's powered off
if ! ping -c 1 "$PROXMOX_IP" &> /dev/null; then
    echo "Proxmox server is offline. Sending wake-on-LAN packet..."
    wakeonlan "$PROXMOX_MAC_ADDRESS"
    echo "Waiting for Proxmox server to wake up..."
    while ! ping -c 1 "$PROXMOX_IP" &> /dev/null; do
        sleep 5
    done
    echo "Proxmox server is online."
fi

# Stop all docker containers
docker stop $(docker ps -a --format="{{.Names}}")

# rsync .docker_service_config folder to NAS
echo "Syncing .docker_service_config to NAS..."
rsync -aAXv --delete "$HOME/.docker_service_config/" "$DOCKER_SERVICE_CONFIG_NAS_PATH"

# Start the docker conainers again
docker start $(docker ps -a --format="{{.Names}}")

# rsync .docker_service_config from the debian server to the NAS
ssh "$GONDOLIN_IP" "docker stop $(docker ps -a --format=\"{{.Names}}\")"
ssh "$GONDOLIN_IP" "sudo rsync -aAXv --delete  --exclude="jellyfin/" $HOME/.docker_service_config/ $DOCKER_SERVICE_CONFIG_NAS_PATH"
ssh "$GONDOLIN_IP" "docker start $(docker ps -a --format=\"{{.Names}}\")"

TIMESTAMP=$(date +%Y%m%d-%H%M%S)
BACKUP_PI_LOG="$home/backup_log_$TIMESTAMP.txt"

# run backup_folder.sh script on the debian server to backup the needed data back to pi
ssh "$GONDOLIN_IP" "bash -s" < $HOME/home-server/scripts/backup_folder.sh "$PI_RESTIC_REPO" >> "$BACKUP_PI_LOG" 2>&1

# run backup_folder.sh script on the debian server to backup again the needed data to the extra HDD
#TODO

# shutdown the proxmox server after the backup is done
ssh "$PROXMOX_IP" "sudo shutdown -p now"

# Example cron job to run the backup script every day at 4am
# 0 4 * * * /home/george/home-server/scripts/backup_job.sh