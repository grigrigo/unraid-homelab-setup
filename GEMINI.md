# Unraid 홈랩 설정 - 프로젝트 컨텍스트

## 프로젝트 개요
이 프로젝트는 **Unraid OS**를 사용하여 고성능 저전력(35-65W) 개인용 NAS를 구축하기 위한 포괄적인 설정 및 문서 저장소입니다. 콘텐츠는 주로 **한국어**로 작성되었습니다.

**타겟 하드웨어:**
- **CPU:** Intel Core i3-14100T (Quick Sync 지원)
- **RAM:** 64GB DDR5
- **스토리지:** 3TB HDD x3 (어레이), 500GB SSD + 1TB NVMe (캐시)

**핵심 기능:**
- **미디어 서버:** 하드웨어 트랜스코딩이 지원되는 Plex/Jellyfin.
- **데이터 보호:** 3-2-1 백업 전략 (로컬 + USB + Backblaze B2).
- **모니터링:** Prometheus, Grafana, Netdata.
- **보안:** VPN (WireGuard/Tailscale), SSL, 2FA.

## 아키텍처
시스템은 모듈식 3계층 Docker 아키텍처를 갖춘 Unraid OS를 기반으로 구축되었습니다:

1.  **미디어 스택:** Plex/Jellyfin, *arr 제품군 (Sonarr, Radarr 등), qBittorrent.
2.  **백업 스택:** Duplicati, Restic, Rclone.
3.  **모니터링 스택:** Prometheus, Grafana, AlertManager.

**스토리지 정책:**
- `Array`: 장기 보관용 스토리지 (미디어, 사진, 백업).
- `NVMe Cache`: Appdata (Docker 설정), 빠른 액세스.
- `SSD Cache`: 다운로드, 임시 파일.

## 운영 명령어

### 검증 및 테스트
변경 사항을 커밋하기 전에 다음 검증 명령어를 실행하세요:
```bash
# 쉘 스크립트 린트
shellcheck scripts/**/*.sh

# Docker Compose 파일 검증
docker-compose -f docker/media-stack/docker-compose.yml config
# (다른 스택에 대해서도 반복)

# YAML 파일 린트
yamllint .
```

### 배포
**Docker 스택:**
```bash
cd docker/[stack_name]
docker-compose up -d
```

**스크립트:**
스크립트는 Unraid 호스트의 `/mnt/user/scripts/`에 위치합니다.
```bash
# 초기 설정 실행 (Unraid 전용)
bash scripts/setup/initial_setup.sh

# 백업 실행
bash scripts/backup/usb_backup.sh
```

## 개발 컨벤션

### 쉘 스크립트 (`scripts/`)
- **반드시** `shellcheck`를 통과해야 합니다.
- **반드시** 표준 헤더(설명, 작성자, 버전)를 사용해야 합니다.
- **반드시** 오류 처리(`set -e`) 및 로깅 함수(`print_status` 등)를 포함해야 합니다.
- **반드시** 실행 가능해야 합니다 (`chmod +x`).

### Docker 설정 (`docker/`)
- `.env` 파일은 **절대** 커밋하지 말고 `.env.example`을 사용하세요.
- **표준 ID:** 모든 컨테이너에 대해 `PUID=99`, `PGID=100` 사용.
- **타임존:** `Asia/Seoul`.
- **이미지 선호도:** 가능한 경우 LinuxServer.io 이미지를 사용하세요.

### 문서 (`docs/`)
- **언어:** 한국어.
- **구조:** 디렉토리 계층 구조(00-07)를 따르세요.
- **메타데이터:** 표준 YAML 프론트매터(title, category, difficulty)를 사용하세요.

## 주요 디렉토리 구조
- `docs/`: 단계별 가이드 (하드웨어 -> 설치 -> 운영).
- `docker/`: 기능별로 분리된 Docker Compose 정의.
- `scripts/`: 자동화 스크립트 (백업, 설정, 모니터링).
- `config/`: Unraid, Nginx 등을 위한 설정 템플릿.
- `tests/`: 검증을 위한 테스트 스크립트.

## CI/CD
이 리포지토리는 GitHub Actions (`.github/workflows/validate.yml`)를 사용하여 다음을 강제합니다:
- 스크립트 린트 (`shellcheck`)
- Docker 설정 검증
- YAML 구문 검사
- 보안 스캔 (`trivy`)