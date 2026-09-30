#!/bin/bash

# CCM101 Enterprise Cloud
# Automated MySQL Database Backup

set -u

PROJECT_DIR="$HOME/enterprise-cloud"
BACKUP_DIR="$PROJECT_DIR/backups"
ENV_FILE="$PROJECT_DIR/.env"

TIMESTAMP=$(date +"%Y-%m-%d_%H-%M-%S")
BACKUP_FILE="$BACKUP_DIR/wordpress_db_$TIMESTAMP.sql"
TEMP_FILE="$BACKUP_FILE.tmp"

mkdir -p "$BACKUP_DIR"

if [ ! -f "$ENV_FILE" ]; then
    echo "[$(date)] ERROR: .env file not found."
    exit 1
fi

source "$ENV_FILE"

if ! docker ps --format '{{.Names}}' | grep -q "^enterprise-mysql$"; then
    echo "[$(date)] Database backup FAILED: enterprise-mysql is not running."
    exit 1
fi

MYSQL_PWD="$MYSQL_ROOT_PASSWORD" docker exec \
    -e MYSQL_PWD="$MYSQL_ROOT_PASSWORD" \
    enterprise-mysql \
    mysqldump \
    -u root \
    "$MYSQL_DATABASE" \
    > "$TEMP_FILE"

if [ $? -eq 0 ] && [ -s "$TEMP_FILE" ]; then
    mv "$TEMP_FILE" "$BACKUP_FILE"
    echo "[$(date)] Database backup successful: $BACKUP_FILE"
else
    rm -f "$TEMP_FILE"
    echo "[$(date)] Database backup FAILED."
    exit 1
fi

# Keep only the 7 most recent backups
ls -1t "$BACKUP_DIR"/wordpress_db_*.sql 2>/dev/null |
    tail -n +8 |
    xargs -r rm --

echo "[$(date)] Backup maintenance completed."
