#!/bin/bash
# Backup script with logging and error handling

BACKUP_DIR="$HOME/backups"
SOURCE_DIR="/home/devops"
TIMESTAMP=$(date +%Y-%m-%d_%H-%M-%S)
BACKUP_FILE="$BACKUP_DIR/home_backup_$TIMESTAMP.tar.gz"
LOG_FILE="$BACKUP_DIR/backup.log"

# Create backup directory if it doesn't exist
mkdir -p "$BACKUP_DIR"

# Perform the backup
echo "Starting backup at $TIMESTAMP" >> "$LOG_FILE"
tar -czf "$BACKUP_FILE" --exclude="$BACKUP_DIR" "$SOURCE_DIR"

# Check if backup succeeded
if [ $? -eq 0 ]; then
    echo "Backup successful: $BACKUP_FILE" >> "$LOG_FILE"
else
    echo "BACKUP FAILED at $TIMESTAMP" >> "$LOG_FILE"
    exit 1
fi

# Delete backups older than 7 days
find "$BACKUP_DIR" -name "*.tar.gz" -mtime +7 -delete

echo "Backup completed successfully"
