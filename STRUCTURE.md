# Repository Structure

This document describes the structure and contents of the Unraid Homelab Setup repository.

## Directory Overview

```
unraid-homelab-setup/
├── docs/                      # Documentation files
│   ├── 01_hardware_checklist.md
│   ├── 02_installation_guide.md
│   ├── 03_security_setup.md
│   ├── 04_docker_apps.md
│   ├── 05_backup_strategy.md
│   └── Unraid_NAS_Complete_Guide_2025_4HDD.md
│
├── scripts/                   # Shell scripts for automation
│   ├── backup/               # Backup scripts
│   │   ├── usb_backup.sh
│   │   └── cloud_backup.sh
│   ├── monitoring/           # Monitoring scripts
│   ├── automation/           # Automation scripts
│   ├── maintenance/          # Maintenance scripts
│   └── setup/                # Setup scripts
│       └── initial_setup.sh
│
├── docker/                    # Docker configurations
│   ├── media-stack/          # Media server stack
│   │   ├── docker-compose.yml
│   │   └── .env.example
│   ├── backup-stack/         # Backup services
│   │   └── docker-compose.yml
│   ├── monitoring-stack/     # Monitoring services
│   │   └── docker-compose.yml
│   ├── management-stack/     # Management tools
│   └── services/             # Individual services
│
├── config/                    # Configuration templates
│   ├── unraid/               # Unraid configs
│   ├── docker/               # Docker configs
│   ├── nginx/                # Nginx configs
│   ├── wireguard/            # VPN configs
│   └── samba/                # SMB configs
│
├── monitoring/                # Monitoring configurations
│   ├── grafana/              # Grafana dashboards
│   ├── prometheus/           # Prometheus configs
│   │   ├── prometheus.yml
│   │   └── alerts.yml
│   └── alerts/               # Alert rules
│
├── vm/                        # VM configurations
│   ├── templates/            # VM templates
│   └── configs/              # VM configs
│
├── tests/                     # Test scripts
├── logs/                      # Log files (gitignored)
│
├── .github/                   # GitHub Actions
│   └── workflows/
│       └── validate.yml      # CI/CD pipeline
│
├── .gitignore                 # Git ignore file
├── LICENSE                    # License file
├── README.md                  # Project overview
└── STRUCTURE.md              # This file
```

## File Categories

### Documentation (`docs/`)
- Step-by-step guides for setup and configuration
- Hardware requirements and checklists
- Security best practices
- Complete reference guide

### Scripts (`scripts/`)
- **backup/**: Automated backup to USB and cloud
- **monitoring/**: Health checks and monitoring scripts
- **automation/**: Task automation scripts
- **maintenance/**: System maintenance scripts
- **setup/**: Initial setup and configuration

### Docker Stacks (`docker/`)
- **media-stack**: Plex/Jellyfin, Sonarr, Radarr, etc.
- **backup-stack**: Duplicati, Restic, Rclone, Kopia
- **monitoring-stack**: Prometheus, Grafana, Netdata
- **management-stack**: Portainer, Nginx Proxy Manager

### Configuration Templates (`config/`)
- Ready-to-use configuration files
- Environment variable templates
- Network and security configs

### Monitoring (`monitoring/`)
- Prometheus configuration and alert rules
- Grafana dashboard definitions
- Custom metrics and exporters

## Usage Workflow

1. **Planning Phase**
   - Review `docs/01_hardware_checklist.md`
   - Check system requirements

2. **Installation Phase**
   - Follow `docs/02_installation_guide.md`
   - Run `scripts/setup/initial_setup.sh`

3. **Configuration Phase**
   - Apply configurations from `config/`
   - Set up security using `docs/03_security_setup.md`

4. **Service Deployment**
   - Deploy Docker stacks from `docker/`

5. **Monitoring Setup**
   - Configure Prometheus/Grafana
   - Set up alerts and dashboards

6. **Backup Implementation**
   - Configure backup scripts
   - Set up automated schedules

## Contributing

When adding new content:

1. **Scripts**: Add to appropriate subdirectory in `scripts/`
2. **Configs**: Place templates in `config/` with `.example` suffix
3. **Docker**: Create new stack or add to existing in `docker/`
4. **Docs**: Update relevant documentation in `docs/`

## Security Notes

- Never commit sensitive data (passwords, keys, tokens)
- Use `.example` files for templates
- Store secrets in `.env` files (gitignored)
- Review `.gitignore` before committing

## Maintenance

Regular updates needed for:
- Docker image versions
- Security patches
- Documentation updates
- Script improvements

## Support

For issues or questions:
- Check existing documentation
- Review closed issues on GitHub
- Create new issue with details