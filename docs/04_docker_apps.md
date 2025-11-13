# Docker 컨테이너 설치 가이드

## 사전 준비

### Community Applications 설치
```
1. Apps 탭 클릭
2. "Install Community Applications" 클릭
3. 설치 완료 후 Apps 탭에서 검색 가능
```

## 1. 미디어 서버

### 1.1 Plex Media Server
```yaml
설치: Apps → "plex" 검색
설정:
  Port: 32400
  /config: /mnt/nvme/appdata/plex
  /media: /mnt/user/Media
  GPU Device: /dev/dri (하드웨어 트랜스코딩용)
```

### 1.2 Jellyfin (오픈소스 대안)
```yaml
설치: Apps → "jellyfin" 검색
설정:
  Port: 8096
  /config: /mnt/nvme/appdata/jellyfin
  /media: /mnt/user/Media
  Extra Parameters: --runtime=nvidia
```

## 2. 미디어 관리 자동화

### 2.1 Sonarr (TV 프로그램)
```yaml
Port: 8989
/config: /mnt/nvme/appdata/sonarr
/tv: /mnt/user/Media/TV
/downloads: /mnt/user/downloads
```

### 2.2 Radarr (영화)
```yaml
Port: 7878
/config: /mnt/nvme/appdata/radarr
/movies: /mnt/user/Media/Movies
/downloads: /mnt/user/downloads
```

### 2.3 Prowlarr (인덱서 관리)
```yaml
Port: 9696
/config: /mnt/nvme/appdata/prowlarr
```

### 2.4 qBittorrent
```yaml
Port: 8080
/config: /mnt/nvme/appdata/qbittorrent
/downloads: /mnt/user/downloads
VPN: 권장 (별도 설정)
```

## 3. 사진 관리

### 3.1 Immich (Google Photos 대체)
```yaml
Port: 2283
/config: /mnt/nvme/appdata/immich
/photos: /mnt/user/Photos
/external: /mnt/user/Photos/import
Database: PostgreSQL (자동 설치)
```

특징:
- 모바일 자동 백업
- AI 얼굴 인식
- 지도 기반 탐색
- 공유 앨범

## 4. 클라우드 스토리지

### 4.1 Nextcloud
```yaml
Port: 443
/config: /mnt/nvme/appdata/nextcloud
/data: /mnt/user/nextcloud
Database: MariaDB 필요
```

### 4.2 Syncthing
```yaml
Port: 8384
/config: /mnt/nvme/appdata/syncthing
/sync: /mnt/user/Sync
```

## 5. 백업 솔루션

### 5.1 Duplicati
```yaml
Port: 8200
/config: /mnt/nvme/appdata/duplicati
/source: /mnt/user
/backups: /mnt/user/Backups
```

지원 클라우드:
- Backblaze B2
- Google Drive
- OneDrive
- Amazon S3

## 6. 시스템 관리

### 6.1 Portainer (Docker 관리 UI)
```yaml
Port: 9000
/var/run/docker.sock: /var/run/docker.sock
/data: /mnt/nvme/appdata/portainer
```

### 6.2 Nginx Proxy Manager
```yaml
Port: 81 (관리 UI)
Port: 80, 443 (프록시)
/config: /mnt/nvme/appdata/nginx-proxy-manager
```

### 6.3 Watchtower (자동 업데이트)
```yaml
Schedule: 0 3 * * * (매일 새벽 3시)
Cleanup: Yes
Monitor Only: No (자동 업데이트)
```

## 7. 모니터링

### 7.1 Netdata
```yaml
Port: 19999
실시간 시스템 모니터링
CPU, RAM, 디스크, 네트워크
```

### 7.2 Grafana + Prometheus
```yaml
Grafana Port: 3000
Prometheus Port: 9090
시각화 대시보드
장기 데이터 보관
```

## 설치 순서 권장

### Week 1 (필수)
1. [ ] Portainer
2. [ ] Plex 또는 Jellyfin
3. [ ] Duplicati

### Week 2 (미디어)
4. [ ] Sonarr + Radarr
5. [ ] Prowlarr
6. [ ] qBittorrent

### Week 3 (확장)
7. [ ] Immich
8. [ ] Nextcloud
9. [ ] Nginx Proxy Manager

### Week 4 (모니터링)
10. [ ] Netdata
11. [ ] Grafana
12. [ ] Watchtower

## GPU 가속 설정 (GTX 1050)

### Nvidia Driver 플러그인
```bash
1. Apps → "Nvidia-Driver" 설치
2. Settings → Nvidia Driver
3. Driver Version: Latest
4. 재부팅
```

### Plex 하드웨어 트랜스코딩
```
Plex 설정 → Transcoder
- Use hardware acceleration: NVIDIA NVENC
- Hardware encoding: Enabled
```

### 2-Stream 제한 해제
```bash
cd /tmp
git clone https://github.com/keylase/nvidia-patch.git
cd nvidia-patch
bash ./patch.sh
```