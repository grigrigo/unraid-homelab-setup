#!/bin/bash
#
# USB Backup Script for Unraid NAS
# Description: Automated backup to external USB drive
# Author: Unraid Homelab
# Version: 1.0.0
# Date: 2025-01-13
#

# Configuration
BACKUP_SOURCE="/mnt/user"
BACKUP_DEST="/mnt/disks/External_Backup"
LOG_FILE="/mnt/user/logs/usb_backup_$(date +%Y%m%d_%H%M%S).log"
NOTIFY_SCRIPT="/usr/local/emhttp/webGui/scripts/notify"

# Folders to backup
BACKUP_FOLDERS=(
    "Photos"
    "Documents"
    "Backups"
    "appdata"
)

# Folders to exclude
EXCLUDE_PATTERNS=(
    "*.tmp"
    "*.temp"
    ".Recycle.Bin/*"
    "downloads/incomplete/*"
)

# Functions
log_message() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1" | tee -a "$LOG_FILE"
}

send_notification() {
    local subject="$1"
    local message="$2"
    $NOTIFY_SCRIPT -s "$subject" -d "$message"
}

check_destination() {
    if [ ! -d "$BACKUP_DEST" ]; then
        log_message "ERROR: Backup destination not found: $BACKUP_DEST"
        send_notification "Backup Failed" "USB drive not mounted"
        exit 1
    fi
}

perform_backup() {
    local folder="$1"
    log_message "Starting backup of $folder"

    # Build exclude parameters
    local exclude_args=""
    for pattern in "${EXCLUDE_PATTERNS[@]}"; do
        exclude_args="$exclude_args --exclude='$pattern'"
    done

    # Run rsync
    eval rsync -avh --progress --delete \
        $exclude_args \
        "$BACKUP_SOURCE/$folder" \
        "$BACKUP_DEST/" \
        >> "$LOG_FILE" 2>&1

    if [ $? -eq 0 ]; then
        log_message "Successfully backed up $folder"
    else
        log_message "ERROR: Failed to backup $folder"
        return 1
    fi
}

# Main script
main() {
    log_message "=== USB Backup Started ==="
    send_notification "Backup Started" "USB backup process initiated"

    # Check if destination exists
    check_destination

    # Perform backups
    local errors=0
    for folder in "${BACKUP_FOLDERS[@]}"; do
        if [ -d "$BACKUP_SOURCE/$folder" ]; then
            perform_backup "$folder"
            if [ $? -ne 0 ]; then
                ((errors++))
            fi
        else
            log_message "WARNING: Folder not found: $folder"
        fi
    done

    # Final status
    if [ $errors -eq 0 ]; then
        log_message "=== USB Backup Completed Successfully ==="
        send_notification "Backup Complete" "All folders backed up successfully"
    else
        log_message "=== USB Backup Completed with $errors errors ==="
        send_notification "Backup Completed with Errors" "$errors folders failed to backup"
    fi

    # Disk usage report
    df -h "$BACKUP_DEST" >> "$LOG_FILE"
}

# Run main function
main