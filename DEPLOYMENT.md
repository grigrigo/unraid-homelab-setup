# Unraid NAS Deployment Checklist

## Pre-Deployment (Week 0)

### Hardware Preparation
- [ ] Verify all hardware components
- [ ] Update motherboard BIOS to latest version
- [ ] Test RAM with memtest86+
- [ ] Check all HDDs with manufacturer tools
- [ ] Prepare USB boot drive (4-32GB, not SanDisk)

### Planning
- [ ] Document network topology
- [ ] Plan IP addressing scheme
- [ ] Decide on storage configuration (single/dual parity)
- [ ] Choose domain name (if applicable)
- [ ] Plan backup strategy

## Phase 1: Base Installation (Day 1)

### Unraid Installation
- [ ] Create Unraid USB boot drive
- [ ] Configure BIOS settings (AHCI, VT-d, etc.)
- [ ] Boot from USB and access WebUI
- [ ] Set timezone and basic settings
- [ ] Activate trial license (30 days)

### Storage Configuration
- [ ] Assign disks (parity, data, cache)
- [ ] Choose filesystem (XFS for array, BTRFS for cache)
- [ ] Start array and format disks
- [ ] Begin parity sync (6-24 hours)
- [ ] Create basic shares

**Script to run:**
```bash
/mnt/user/scripts/setup/initial_setup.sh
```

## Phase 2: Security (Day 2)

### Access Control
- [ ] Set strong root password
- [ ] Create user accounts
- [ ] Configure share permissions
- [ ] Enable SSH with key authentication

### Network Security
- [ ] Configure firewall rules
- [ ] Set up SSL certificate
- [ ] Enable 2FA authentication
- [ ] Configure VPN access (Tailscale/WireGuard)

**Reference:** `docs/03_security_setup.md`

## Phase 3: Docker Services (Days 3-4)

### Core Services
- [ ] Install Community Applications plugin
- [ ] Deploy media stack (Plex/Jellyfin)
- [ ] Deploy backup stack (Duplicati)
- [ ] Deploy monitoring stack (Prometheus/Grafana)

**Docker Compose:**
```bash
cd /mnt/user/docker/media-stack
docker-compose up -d
```

### GPU Configuration (if applicable)
- [ ] Install Nvidia drivers plugin
- [ ] Configure GPU passthrough
- [ ] Enable hardware transcoding
- [ ] Apply 2-stream patch (GTX 1050)

## Phase 4: Backup Implementation (Day 5)

### Local Backup
- [ ] Connect external USB drive
- [ ] Install Unassigned Devices plugin
- [ ] Configure USB backup script
- [ ] Test backup and restore

### Cloud Backup
- [ ] Create Backblaze B2 account
- [ ] Configure Duplicati/Rclone
- [ ] Set up backup schedules
- [ ] Test cloud restore

**Scripts:**
- `/mnt/user/scripts/backup/usb_backup.sh`
- `/mnt/user/scripts/backup/cloud_backup.sh`

## Phase 5: Monitoring (Day 6)

### Metrics Collection
- [ ] Deploy Prometheus
- [ ] Configure node exporters
- [ ] Set up Grafana dashboards
- [ ] Configure alert rules

### Alerting
- [ ] Set up notification channels (email/Discord)
- [ ] Configure alert thresholds
- [ ] Test alert delivery
- [ ] Document escalation procedures

**Reference:** `monitoring/prometheus/alerts.yml`

## Phase 6: Automation (Day 7)

### Scheduled Tasks
- [ ] Configure parity checks (monthly)
- [ ] Set up backup schedules
- [ ] Configure Docker updates (Watchtower)
- [ ] Set up log rotation

## Phase 7: Performance Tuning (Week 2)

### Storage Optimization
- [ ] Configure cache settings
- [ ] Set up mover schedule
- [ ] Enable SSD TRIM
- [ ] Optimize share split levels

### Network Optimization
- [ ] Enable jumbo frames (if supported)
- [ ] Configure SMB settings
- [ ] Optimize Docker networks
- [ ] Test transfer speeds

## Phase 8: Testing (Week 2)

### Functionality Tests
- [ ] Test all Docker containers
- [ ] Verify media streaming
- [ ] Test backup/restore procedures
- [ ] Verify remote access

### Failure Scenarios
- [ ] Test disk failure simulation
- [ ] Test power failure recovery
- [ ] Test backup restoration
- [ ] Document recovery procedures

## Phase 9: Documentation (Week 2)

### System Documentation
- [ ] Document network configuration
- [ ] Create service inventory
- [ ] Document backup procedures
- [ ] Create user guides

### Credentials Management
- [ ] Store passwords securely
- [ ] Document API keys
- [ ] Create recovery procedures
- [ ] Set up password manager

## Phase 10: Go-Live (Week 3)

### Final Checks
- [ ] Review all security settings
- [ ] Verify all backups working
- [ ] Check monitoring alerts
- [ ] Review resource utilization

### Migration
- [ ] Migrate data from old system
- [ ] Update DNS records
- [ ] Configure port forwarding
- [ ] Notify users of new system

### Post-Deployment
- [ ] Purchase Unraid license
- [ ] Schedule maintenance windows
- [ ] Plan capacity monitoring
- [ ] Document lessons learned

## Maintenance Schedule

### Daily
- [ ] Check dashboard for errors
- [ ] Review system notifications

### Weekly
- [ ] Check backup completion
- [ ] Review disk usage
- [ ] Check for updates

### Monthly
- [ ] Run parity check
- [ ] Test backup restore
- [ ] Review security logs
- [ ] Update documentation

### Quarterly
- [ ] Review and update Docker containers
- [ ] Audit user access
- [ ] Test disaster recovery

## Rollback Plan

If issues occur:

1. **Minor Issues:**
   - Restore from BTRFS snapshots
   - Rollback Docker containers
   - Restore configuration from backup

2. **Major Issues:**
   - Boot from backup USB
   - Restore array configuration
   - Rebuild from cloud backups

3. **Complete Failure:**
   - Fresh Unraid installation
   - Import configuration backup
   - Restore data from cloud

## Support Resources

- **Unraid Forums:** https://forums.unraid.net
- **Reddit:** r/unraid
- **Discord:** Unraid Community
- **Documentation:** This repository

## Sign-off

- [ ] System Administrator: ___________
- [ ] Backup Verified: ___________
- [ ] Security Reviewed: ___________
- [ ] Documentation Complete: ___________
- [ ] Go-Live Approved: ___________

**Deployment Date:** ___________
**Completed By:** ___________