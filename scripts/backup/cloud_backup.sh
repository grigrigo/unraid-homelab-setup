#!/bin/bash
#
# Cloud Backup Script for Unraid NAS
# Description: Automated backup to cloud storage (Backblaze B2)
# Author: Unraid Homelab
# Version: 1.0.0
# Date: 2025-01-13
#

# Load environment variables
if [ -f /mnt/user/scripts/.env ]; then
    source /mnt/user/scripts/.env
fi

# Configuration
RCLONE_CONFIG="/mnt/nvme/appdata/rclone/rclone.conf"
BACKUP_SOURCE="/mnt/user"
CLOUD_DEST="b2:unraid-backup"
LOG_DIR="/mnt/user/logs/cloud_backup"
LOG_FILE="$LOG_DIR/backup_$(date +%Y%m%d_%H%M%S).log"
NOTIFY_SCRIPT="/usr/local/emhttp/webGui/scripts/notify"

# Priority folders (backup these first)
PRIORITY_FOLDERS=(
    "Photos"
    "Documents"
    "Backups/critical"
)

# Regular folders
REGULAR_FOLDERS=(
    "appdata"
    "Projects"
)

# Exclude patterns
EXCLUDE_PATTERNS=(
    "*.tmp"
    "*.temp"
    ".Recycle.Bin/**"
    "downloads/**"
    "*.log"
    "cache/**"
)

# Retention policy (days)
RETENTION_DAYS=30

# Functions
setup_logging() {
    mkdir -p "$LOG_DIR"
    exec 1> >(tee -a "$LOG_FILE")
    exec 2>&1
}

log_message() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1"
}

send_notification() {
    local subject="$1"
    local message="$2"
    if [ -x "$NOTIFY_SCRIPT" ]; then
        $NOTIFY_SCRIPT -s "$subject" -d "$message"
    fi
}

check_dependencies() {
    if ! command -v rclone &> /dev/null; then
        log_message "ERROR: rclone not found"
        send_notification "Backup Failed" "rclone is not installed"
        exit 1
    fi

    if [ ! -f "$RCLONE_CONFIG" ]; then
        log_message "ERROR: rclone config not found"
        send_notification "Backup Failed" "rclone configuration missing"
        exit 1
    fi
}

check_cloud_connection() {
    log_message "Checking cloud connection..."
    if rclone --config="$RCLONE_CONFIG" lsd "$CLOUD_DEST" &> /dev/null; then
        log_message "Cloud connection successful"
        return 0
    else
        log_message "ERROR: Cannot connect to cloud storage"
        send_notification "Backup Failed" "Cannot connect to Backblaze B2"
        exit 1
    fi
}

get_folder_size() {
    local folder="$1"
    du -sh "$BACKUP_SOURCE/$folder" 2>/dev/null | cut -f1
}

backup_folder() {
    local folder="$1"
    local priority="$2"

    if [ ! -d "$BACKUP_SOURCE/$folder" ]; then
        log_message "WARNING: Folder not found: $folder"
        return 1
    fi

    local size=$(get_folder_size "$folder")
    log_message "Backing up $folder ($size) - Priority: $priority"

    # Build exclude parameters
    local exclude_args=""
    for pattern in "${EXCLUDE_PATTERNS[@]}"; do
        exclude_args="$exclude_args --exclude '$pattern'"
    done

    # Perform backup with rclone
    eval rclone sync \
        --config="$RCLONE_CONFIG" \
        --progress \
        --stats 1m \
        --transfers 4 \
        --checkers 8 \
        --contimeout 60s \
        --timeout 300s \
        --retries 3 \
        --low-level-retries 10 \
        --fast-list \
        $exclude_args \
        "$BACKUP_SOURCE/$folder" \
        "$CLOUD_DEST/$folder"

    local result=$?
    if [ $result -eq 0 ]; then
        log_message "Successfully backed up $folder"
        return 0
    else
        log_message "ERROR: Failed to backup $folder (exit code: $result)"
        return 1
    fi
}

cleanup_old_backups() {
    log_message "Cleaning up old backups (older than $RETENTION_DAYS days)..."

    rclone --config="$RCLONE_CONFIG" \
        delete \
        --min-age "${RETENTION_DAYS}d" \
        "$CLOUD_DEST/daily/"

    log_message "Cleanup completed"
}

generate_report() {
    local total_errors="$1"
    local backup_size=$(rclone --config="$RCLONE_CONFIG" size "$CLOUD_DEST" --json | jq -r '.bytes' | numfmt --to=iec)
    local backup_count=$(rclone --config="$RCLONE_CONFIG" size "$CLOUD_DEST" --json | jq -r '.count')

    cat << EOF

========================================
Cloud Backup Report
========================================
Date: $(date)
Destination: $CLOUD_DEST
Total Size: $backup_size
Total Files: $backup_count
Errors: $total_errors
Log File: $LOG_FILE

Folders Backed Up:
EOF

    for folder in "${PRIORITY_FOLDERS[@]}" "${REGULAR_FOLDERS[@]}"; do
        if [ -d "$BACKUP_SOURCE/$folder" ]; then
            local size=$(get_folder_size "$folder")
            echo "  - $folder ($size)"
        fi
    done

    echo "========================================"
}

# Main execution
main() {
    setup_logging

    log_message "=== Cloud Backup Started ==="
    send_notification "Cloud Backup Started" "Backing up to Backblaze B2"

    # Pre-flight checks
    check_dependencies
    check_cloud_connection

    # Track errors
    local total_errors=0

    # Backup priority folders first
    log_message "Starting priority backups..."
    for folder in "${PRIORITY_FOLDERS[@]}"; do
        backup_folder "$folder" "HIGH"
        if [ $? -ne 0 ]; then
            ((total_errors++))
        fi
    done

    # Backup regular folders
    log_message "Starting regular backups..."
    for folder in "${REGULAR_FOLDERS[@]}"; do
        backup_folder "$folder" "NORMAL"
        if [ $? -ne 0 ]; then
            ((total_errors++))
        fi
    done

    # Cleanup old backups
    cleanup_old_backups

    # Generate and display report
    generate_report "$total_errors"

    # Send final notification
    if [ $total_errors -eq 0 ]; then
        log_message "=== Cloud Backup Completed Successfully ==="
        send_notification "Cloud Backup Complete" "All folders backed up successfully to B2"
    else
        log_message "=== Cloud Backup Completed with $total_errors errors ==="
        send_notification "Cloud Backup Completed with Errors" "$total_errors folders failed to backup"
    fi

    # Save metrics for monitoring
    echo "backup_last_success_timestamp $(date +%s)" > /mnt/user/logs/backup_metrics.prom
    echo "backup_errors_total $total_errors" >> /mnt/user/logs/backup_metrics.prom
}

# Run main function
main "$@"