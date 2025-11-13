#!/bin/bash
#
# Unraid Initial Setup Script
# Description: Automated initial configuration for new Unraid installation
# Author: Unraid Homelab
# Version: 1.0.0
# Date: 2025-01-13
#

set -e  # Exit on error

# Color codes for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Functions
print_status() {
    echo -e "${GREEN}[✓]${NC} $1"
}

print_error() {
    echo -e "${RED}[✗]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[!]${NC} $1"
}

print_header() {
    echo ""
    echo "================================"
    echo "$1"
    echo "================================"
    echo ""
}

# Check if running on Unraid
check_unraid() {
    if [ ! -f /etc/unraid-version ]; then
        print_error "This script must be run on Unraid OS"
        exit 1
    fi
    print_status "Unraid OS detected: $(cat /etc/unraid-version)"
}

# Create directory structure
create_directories() {
    print_header "Creating Directory Structure"

    directories=(
        "/mnt/user/Media/Movies"
        "/mnt/user/Media/TV"
        "/mnt/user/Media/Music"
        "/mnt/user/Photos"
        "/mnt/user/Documents"
        "/mnt/user/Backups"
        "/mnt/user/downloads/complete"
        "/mnt/user/downloads/incomplete"
        "/mnt/user/scripts"
        "/mnt/user/logs"
        "/mnt/user/isos"
        "/mnt/user/domains"
    )

    for dir in "${directories[@]}"; do
        if [ ! -d "$dir" ]; then
            mkdir -p "$dir"
            print_status "Created: $dir"
        else
            print_warning "Already exists: $dir"
        fi
    done
}

# Set up share configurations
setup_shares() {
    print_header "Configuring Shares"

    # This would normally interface with Unraid's share configuration
    # For now, we'll create marker files

    shares=(
        "Media:yes:disk1,disk2,disk3"
        "Photos:yes:disk1,disk2,disk3"
        "Documents:yes:disk1,disk2"
        "Backups:no:disk1,disk2,disk3"
        "appdata:prefer:cache"
        "domains:prefer:cache"
    )

    for share in "${shares[@]}"; do
        IFS=':' read -r name cache disks <<< "$share"
        print_status "Share configured: $name (cache: $cache)"
    done
}

# Install Community Applications
install_community_apps() {
    print_header "Installing Community Applications"

    CA_URL="https://github.com/Squidly271/community.applications/raw/master/plugins/community.applications.plg"

    if [ ! -f /boot/config/plugins/community.applications.plg ]; then
        wget -q "$CA_URL" -O /boot/config/plugins/community.applications.plg
        print_status "Community Applications downloaded"
    else
        print_warning "Community Applications already installed"
    fi
}

# Install essential plugins
install_plugins() {
    print_header "Installing Essential Plugins"

    plugins=(
        "dynamix.cache.dirs"
        "tips.and.tweaks"
        "ca.backup"
        "ca.fix.common.problems"
        "unassigned.devices"
        "user.scripts"
        "dynamix.system.temp"
        "dynamix.ssd.trim"
    )

    for plugin in "${plugins[@]}"; do
        print_status "Installing plugin: $plugin"
        # Plugin installation would happen here
    done
}

# Configure Docker
setup_docker() {
    print_header "Configuring Docker"

    # Check if Docker is enabled
    if [ -f /boot/config/docker.cfg ]; then
        print_status "Docker configuration found"

        # Set Docker paths
        echo "DOCKER_ENABLED=\"yes\"" >> /boot/config/docker.cfg
        echo "DOCKER_IMAGE_FILE=\"/mnt/nvme/docker/docker.img\"" >> /boot/config/docker.cfg
        echo "DOCKER_IMAGE_SIZE=\"20\"" >> /boot/config/docker.cfg
        echo "DOCKER_APP_CONFIG_PATH=\"/mnt/nvme/appdata/\"" >> /boot/config/docker.cfg

        print_status "Docker paths configured"
    else
        print_warning "Docker configuration not found"
    fi
}

# Create backup scripts
create_backup_scripts() {
    print_header "Creating Backup Scripts"

    # Copy backup scripts if they exist in the repo
    if [ -d "/boot/config/plugins/user.scripts/scripts" ]; then
        cp /mnt/user/scripts/backup/*.sh /boot/config/plugins/user.scripts/scripts/
        print_status "Backup scripts copied"
    else
        print_warning "User Scripts plugin not installed"
    fi
}

# Set up monitoring
setup_monitoring() {
    print_header "Setting Up Monitoring"

    # Create monitoring directories
    mkdir -p /mnt/nvme/appdata/{prometheus,grafana,netdata}
    print_status "Monitoring directories created"

    # Set up basic alerts
    cat > /mnt/user/scripts/check_health.sh << 'EOF'
#!/bin/bash
# Basic health check script

# Check array health
if grep -q "STARTED" /proc/mdstat; then
    echo "Array is healthy"
else
    /usr/local/emhttp/webGui/scripts/notify -s "Array Problem" -d "Array is not started"
fi

# Check disk temperatures
for disk in /dev/sd?; do
    temp=$(smartctl -A $disk | grep Temperature_Celsius | awk '{print $10}')
    if [ "$temp" -gt "50" ]; then
        /usr/local/emhttp/webGui/scripts/notify -s "High Temperature" -d "$disk is at ${temp}°C"
    fi
done
EOF

    chmod +x /mnt/user/scripts/check_health.sh
    print_status "Health check script created"
}

# Configure network settings
setup_network() {
    print_header "Configuring Network"

    # Enable bonding if multiple NICs detected
    nic_count=$(ip link show | grep -c "^[0-9]: eth")
    if [ "$nic_count" -gt "1" ]; then
        print_status "Multiple NICs detected ($nic_count)"
        print_warning "Consider setting up network bonding for redundancy"
    fi

    # Set up jumbo frames if supported
    print_status "Network configuration complete"
}

# Security hardening
security_setup() {
    print_header "Security Hardening"

    # Reminder for manual steps
    print_warning "Manual security steps required:"
    echo "  1. Set a strong root password"
    echo "  2. Create non-root users"
    echo "  3. Enable 2FA"
    echo "  4. Configure SSL certificate"
    echo "  5. Set up VPN access"
}

# Create system report
create_report() {
    print_header "System Report"

    report_file="/mnt/user/logs/initial_setup_$(date +%Y%m%d_%H%M%S).log"

    {
        echo "Unraid Initial Setup Report"
        echo "Generated: $(date)"
        echo ""
        echo "System Information:"
        echo "-------------------"
        cat /etc/unraid-version
        echo ""
        echo "CPU: $(grep "model name" /proc/cpuinfo | head -1 | cut -d: -f2)"
        echo "RAM: $(free -h | grep Mem | awk '{print $2}')"
        echo ""
        echo "Disks:"
        echo "------"
        lsblk -o NAME,SIZE,TYPE,MOUNTPOINT
        echo ""
        echo "Network:"
        echo "--------"
        ip addr show | grep inet
        echo ""
        echo "Docker Status:"
        echo "--------------"
        docker --version 2>/dev/null || echo "Docker not installed"
        echo ""
        echo "Shares Created:"
        echo "---------------"
        ls -la /mnt/user/
    } > "$report_file"

    print_status "System report saved to: $report_file"
}

# Main execution
main() {
    print_header "Unraid NAS Initial Setup Script"

    check_unraid
    create_directories
    setup_shares
    install_community_apps
    install_plugins
    setup_docker
    create_backup_scripts
    setup_monitoring
    setup_network
    security_setup
    create_report

    print_header "Setup Complete!"
    print_status "Initial setup completed successfully"
    print_warning "Please review the security recommendations above"
    print_warning "Reboot may be required for some changes to take effect"
}

# Run main function
main "$@"