#!/usr/bin/env bash

if [ "$#" -ne 1 ]; then
    echo "Usage: $0 user@host:path"
    exit 1
fi

DATA="/nfs/homelab_share/intern"
PASSWORD_FILE="$(dirname "$0")/.env.restic"

if [ ! -f "${PASSWORD_FILE}" ]; then
  echo "Error: Restic password file not found at ${PASSWORD_FILE}"
  exit 1
fi

export RESTIC_REPOSITORY="sftp:$1"
export RESTIC_PASSWORD_FILE="${PASSWORD_FILE}"

echo "Get SQL dump from immich container and save it to the backup folder"
SQL_DUMP_PATH="${DATA}/immich/immich-db-backup-$(date +%Y%m%d-%H%M%S)-v2.5.6-pg14.19_db_dump.sql.gz"
docker exec immich_postgres pg_dump -U postgres immich | gzip > ${SQL_DUMP_PATH}

echo "Start backup of ${DATA} to ${RESTIC_REPOSITORY}"
restic backup ${DATA} --exclude="entertainment" --exclude="immich/postgres" --tag auto_backup
restic forget --prune --keep-daily 7 --keep-weekly 4 --keep-monthly 6

rm ${SQL_DUMP_PATH}


# To restore backups
# restic restore latest --target ./restore_backup