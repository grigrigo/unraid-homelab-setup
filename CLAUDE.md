# CLAUDE.md

이 파일은 Claude Code(claude.ai/code)가 이 저장소에서 작업할 때 필요한 가이드를 제공합니다.

## 프로젝트 개요

**Unraid 홈랩 NAS 구축 프로젝트** - Intel i3-14100T 하드웨어를 사용하여 Unraid OS로 개인용 NAS 서버를 구축하기 위한 한국어 문서 및 설정 저장소입니다. 35-65W 저전력 홈 서버를 위한 운영 스크립트 및 Docker 설정이 포함된 문서화 프로젝트입니다.

**언어**: 모든 문서는 한국어로 작성됨

**대상 하드웨어**:
- CPU: Intel Core i3-14100T (4코어/8스레드, TDP 35W)
- RAM: 64GB DDR5-5600
- 스토리지: 3TB HDD x 3개 + 500GB SSD + 1TB NVMe
- GPU: Intel UHD Graphics 730 (트랜스코딩용 Quick Sync 지원)

## 아키텍처

### 3계층 Docker 아키텍처

프로젝트는 모듈식 Docker Compose 스택 설계를 사용합니다:

1. **미디어 스택** (`docker/media-stack/`) - 주요 서비스 스택
   - Plex (주, 포트 32400) 또는 Jellyfin (대체) - GPU 트랜스코딩 포함
   - 자동화: Sonarr (8989), Radarr (7878), Prowlarr (9696)
   - 다운로드: qBittorrent (8080, 6881)
   - 관리: Overseerr (5055), Tautulli (8181)
   - `/dev/dri` 디바이스 패스스루를 통한 Intel Quick Sync 사용

2. **백업 스택** (`docker/backup-stack/`) - 3-2-1 백업 전략
   - 다중 도구: Duplicati, Restic, Rclone, Kopia
   - 데이터 보호를 위한 읽기 전용 소스 마운트
   - USB 및 클라우드 백업 지원 (Backblaze B2)

3. **모니터링 스택** (`docker/monitoring-stack/`) - 관찰성 계층
   - 메트릭: Prometheus (9090) + Grafana (3000)
   - 실시간: Netdata (19999), Glances (61208)
   - 디스크 상태: Scrutiny (SMART 모니터링)
   - 알림: AlertManager (9093), Uptime Kuma (3001)

**핵심 설계 패턴**:
- 모든 컨테이너는 PUID=99, PGID=100 사용 (Unraid 표준 사용자/그룹)
- 타임존: Asia/Seoul
- 설정 파일 위치: `/mnt/nvme/appdata/` (고속 SSD 캐시)
- 미디어 위치: `/mnt/user/Media/` (어레이 스토리지)
- 일관성을 위해 LinuxServer.io 이미지 사용

### 스토리지 아키텍처

**Unraid 스토리지 계층**:
- `/mnt/user/` - 어레이 + 캐시를 아우르는 통합 네임스페이스
- `/mnt/nvme/` - NVMe 캐시 직접 접근 (Docker appdata)
- `/mnt/user/Media/` - 어레이의 메인 미디어 라이브러리
- `/mnt/user/downloads/` - 다운로드 준비 영역

**공유 설정 철학**:
- Cache-prefer: appdata/domains (성능 우선)
- Array-only: Media/Photos (보호 우선)
- Read-only 마운트: 백업 컨테이너 (안전성)

### 스크립트 아키텍처

Shell 스크립트는 공통 패턴을 따릅니다:
- 색상 코드 출력: 녹색 (✓), 빨강 (✗), 노랑 (!)
- 오류 처리: `set -e`로 즉시 실패
- 타임스탬프가 있는 로깅
- Unraid 내장 알림 시스템 지원
- 함수: `print_status()`, `print_error()`, `print_warning()`, `print_header()`

## 공통 명령어

### 검증 및 테스트
```bash
# 로컬에서 CI 검증 실행
shellcheck scripts/**/*.sh                    # 모든 shell 스크립트 린트
docker-compose -f docker/media-stack/docker-compose.yml config  # compose 검증
yamllint .                                    # YAML 파일 린트
```

### Docker 스택 관리
```bash
# 스택 배포
cd docker/media-stack && docker-compose up -d
cd docker/backup-stack && docker-compose up -d
cd docker/monitoring-stack && docker-compose up -d

# 로그 보기
docker-compose logs -f [service_name]

# 특정 서비스 재시작
docker-compose restart [service_name]

# 업데이트 및 재생성
docker-compose pull && docker-compose up -d
```

### 초기 설정
```bash
# Unraid 초기 설정 실행 (Unraid OS에서만 실행 가능)
bash /mnt/user/scripts/setup/initial_setup.sh
```

### 백업 작업
```bash
# 수동 USB 백업
bash /mnt/user/scripts/backup/usb_backup.sh

# 수동 클라우드 백업
bash /mnt/user/scripts/backup/cloud_backup.sh
```

### 상태 점검
```bash
# 어레이 상태 확인
cat /proc/mdstat

# 디스크 온도 확인
smartctl -A /dev/sda | grep Temperature

# Docker 상태 확인
docker ps -a

# 로그 확인
tail -f /mnt/user/logs/*.log
```

## 문서 구조

**단계적 학습 경로** (00 → 07):
- `00-getting-started/` - 사전 요구사항 및 하드웨어 사양
- `01-planning/` - 하드웨어 테스트 및 체크리스트
- `02-setup-guides/` - BIOS, 설치, 어레이, 보안
- `03-application-guides/` - Docker 앱 및 백업 전략
- `04-operations/` - 지속적인 유지보수 (디스크 교체)
- `05-troubleshooting/` - 일반적인 문제 및 해결책
- `06-disaster-recovery/` - 복구 절차
- `07-reference/` - 완전한 빌드 가이드

**문서 메타데이터 형식**:
```yaml
---
title: 문서 제목
category: 카테고리명
difficulty: 초급|중급|고급
estimated_time: 예상 소요 시간
prerequisites: [선행 요구사항]
---
```

각 가이드는 다음 순서를 따릅니다: 개요 → 사전 요구사항 → 단계 → 검증 → 문제 해결 → 다음 단계

## 개발 워크플로우

### 변경 사항 작성

**Shell 스크립트의 경우**:
1. `scripts/`의 스크립트는 실행 가능해야 함 (`chmod +x`)
2. shellcheck 검증을 통과해야 함
3. 표준 함수 템플릿 사용 (`initial_setup.sh` 참조)
4. 헤더 주석 포함: Description, Author, Version, Date

**Docker 설정의 경우**:
1. `.env.example` 파일 사용 (`.env`는 절대 커밋하지 않음)
2. 커밋 전 `docker-compose config`로 검증
3. 가능한 경우 LinuxServer.io 이미지 규칙 따르기
4. 주석으로 새로운 환경 변수 문서화

**문서의 경우**:
1. 모든 문서는 한국어로 작성
2. 표준 YAML 프론트매터 사용
3. 설정 가이드에 검증 단계 포함
4. 상대 경로로 관련 문서 교차 참조

### CI/CD 파이프라인

GitHub Actions (`.github/workflows/validate.yml`)가 push/PR 시 실행:
- **shellcheck**: 모든 `.sh` 파일의 구문 및 모범 사례 검증
- **script permissions**: 실행 비트 설정 확인
- **docker-compose validate**: compose 파일 구문 검사
- **yamllint**: YAML 구문 검증
- **trivy security scan**: 보안 문제 스캔 (SARIF → Security 탭)

### 보안 관행

**절대 커밋하지 말 것**:
- 자격 증명: `*.key`, `*.pem`, `*.env`, `secrets/`, `credentials/`
- 미디어 파일: `*.mkv`, `*.mp4`, `*.iso`
- VM 이미지: `*.qcow2`, `*.vmdk`
- 데이터베이스 파일: `*.db`, `*.sqlite`
- Docker 오버라이드: `docker-compose.override.yml`

**템플릿 사용**:
- 민감한 데이터가 있는 설정은 `.example` 파일 생성
- 필요한 환경 변수 문서화
- 제외 패턴은 `.gitignore` 참조

## 배포 프로세스

10단계 체크리스트 (0-9주)는 `DEPLOYMENT.md` 참조:
1. 0주차: 하드웨어 준비 및 테스트
2. 1주차: 기본 Unraid 설치 및 어레이 설정
3. 2주차: 보안 구성 (2FA, SSL, VPN)
4. 3주차: Docker 서비스 배포
5. 4주차: 백업 시스템 구현
6. 5주차: 모니터링 및 알림 설정
7. 6주차: 자동화 및 예약 작업
8. 7주차: 성능 튜닝
9. 8주차: 종합 테스트 (장애 시나리오 포함)
10. 9주차+: 문서화 및 운영 인수인계

**중요 경로 항목**:
- 프로덕션 사용 전 패리티 동기화 완료 필수
- 백업을 신뢰하기 전에 백업 복원 테스트 필수
- 실제 미디어 파일로 GPU 트랜스코딩 검증
- 운영 전 디스크 장애 시뮬레이션 실행

## 핵심 개념

### Unraid 특화 지식

**어레이 관리**:
- 패리티 디스크가 단일 디스크 장애로부터 보호
- 디스크 추가 시: 어레이 중지 → 할당 → 포맷 → 시작
- 패리티 체크는 월간 실행 (예약됨)
- Mover는 야간 실행 (캐시 → 어레이)

**사용자/그룹 ID**:
- PUID=99 (nobody), PGID=100 (users)는 Unraid 표준
- Docker 컨테이너가 공유 폴더에 접근 가능하도록 보장
- 모든 Docker 서비스가 이 ID 사용

**공유 폴더 타입**:
- Cache-prefer: 캐시에 쓰기, 야간에 어레이로 이동
- Cache-only: 캐시에만 유지 (appdata, system)
- Array-only: 캐시 사용 안 함 (media, backups)

### 성능 고려사항

**하드웨어 트랜스코딩**:
- Intel Quick Sync는 `/dev/dri` 디바이스 접근 필요
- 동시 1080p 트랜스코딩 4-6개 지원
- 4K는 다이렉트 플레이만 가능 (트랜스코딩 불가)

**캐시 전략**:
- Docker appdata는 NVMe에 (낮은 지연시간)
- 다운로드는 SSD에 (쓰기 내구성)
- 미디어는 어레이에 (용량 + 보호)

**네트워크 성능**:
- 네트워크가 지원하면 점보 프레임 고려 (9000 MTU)
- 본딩/티밍을 위한 SMB 멀티채널
- 디렉토리 리스팅 캐시 (dynamix.cache.dirs 플러그인)

## 모니터링 및 알림

**Prometheus 스크레이프 대상**:
- Node Exporter: 호스트 메트릭 (CPU, RAM, disk)
- Docker metrics: 컨테이너 통계
- Scrutiny: SMART 디스크 상태 데이터

**알림 규칙** (`monitoring/prometheus/alerts.yml`):
- 디스크 온도 > 50°C
- 어레이 미시작
- 패리티 오류 감지
- 백업 작업 실패
- 디스크 SMART 실패

**알림 채널**:
- Unraid 내장: `/usr/local/emhttp/webGui/scripts/notify`
- AlertManager: Email, Discord, Slack
- Uptime Kuma: 상태 페이지 + 알림

## 백업 전략 (3-2-1 규칙)

**3개의 복사본**:
1. 주 데이터 (어레이)
2. 로컬 USB 백업
3. 클라우드 백업 (Backblaze B2)

**2가지 다른 미디어 타입**:
- HDD 어레이 (회전 디스크)
- USB 외장 드라이브 (백업 시에만 온라인)

**1개의 오프사이트**:
- Backblaze B2 클라우드 스토리지
- 저장 및 전송 시 암호화

**백업 도구**:
- **Duplicati**: GUI 기반, 초보자에게 적합
- **Restic**: CLI, 중복 제거, 빠름
- **Rclone**: 클라우드 동기화, 다중 제공자
- **Kopia**: 최신, 압축, 암호화

## 저장소 패턴

### 파일 읽기 시
- 문서 소스: `docs/**/*.md` (17개 파일)
- 설정 예제: `.example` 접미사 확인
- Docker 스택: `docker/*/docker-compose.yml` (3개 파일)
- 스크립트: `scripts/**/*.sh` (3개 스크립트)

### 편집 시
- **문서**: 같은 섹션의 관련 문서 업데이트
- **Docker 변경**: 변수 추가 시 `.env.example` 업데이트
- **스크립트 변경**: 배포에 영향을 주면 DEPLOYMENT.md 업데이트
- **주요 변경**: README.md 및 영향받는 가이드 업데이트

### 교차 참조
- 상대 경로 사용: `[disk-replacement](../04-operations/disk-replacement.md)`
- 특정 섹션 참조: `[BIOS설정](02-setup-guides/01-bios-configuration.md#cpu-설정)`
- 배포 링크: DEPLOYMENT.md의 특정 주차/단계 참조

## 문제 해결 가이드

**일반적인 문제**:
1. **Docker 시작 안 됨**: `/mnt/nvme`가 마운트되고 공간이 있는지 확인
2. **Plex GPU 없음**: `/dev/dri` 권한 확인, `ls -la /dev/dri`로 체크
3. **느린 전송**: SMB 설정 확인, 멀티채널 활성화
4. **백업 실패**: 디스크 공간 확인, USB 마운트 지점 검증
5. **높은 온도**: BIOS의 팬 커브 확인, 공기 흐름 검증

**디버그 명령어**:
```bash
# 마운트 확인
df -h | grep /mnt

# Docker 네트워크 확인
docker network ls
docker network inspect media-net

# GPU 접근 확인
ls -la /dev/dri
docker exec plex ls -la /dev/dri

# Unraid 로그 확인
tail -f /var/log/syslog

# Docker 로그 확인
docker logs [container_name] --tail 100
```

## 프로젝트 세부사항

**비용 모델**:
- 초기: ~1,060,000원 (하드웨어 + 라이선스)
- 월간: 15,000-50,000원 (전력 + 클라우드 스토리지)
- 전력: 35-65W 실측 소비량

**용량 계획**:
- 싱글 패리티: 6TB 가용 공간 (1개 디스크 보호)
- 패리티 없음: 9TB 가용 공간 (보호 없음)
- 캐시: 총 1.5TB (500GB SSD + 1TB NVMe)

**성능 목표**:
- 동시 1080p 트랜스코딩 4-6개
- 50개 이상 Docker 컨테이너
- 다중 VM 호스팅 (64GB RAM 여유)
- 월 전기료 12,000원 미만

## 브랜치 전략

- **main**: 안정, 프로덕션 준비 완료 설정
- **dev**: 현재 개발 브랜치 (활성)
- **feature branches**: 주요 변경/추가 사항

현재 상태: `dev` 브랜치의 클린 워킹 트리
