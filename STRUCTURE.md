# 📂 프로젝트 구조 (Project Structure)

이 문서는 **Unraid 홈랩 NAS 구축 프로젝트**의 디렉토리 구조와 각 구성 요소의 역할을 상세히 설명합니다.

## 🗺️ 디렉토리 트리

```bash
unraid-homelab-setup/
├── 📄 CLAUDE.md               # Claude AI 에이전트 가이드
├── 📄 DEPLOYMENT.md           # 배포 체크리스트 및 로드맵
├── 📄 GEMINI.md               # Gemini AI 에이전트 가이드
├── 📄 LICENSE                 # 프로젝트 라이선스
├── 📄 README.md               # 프로젝트 메인 소개
├── 📄 STRUCTURE.md            # 이 파일 (구조 설명)
│
├── 📂 .github/                # GitHub 설정
│   └── 📂 workflows/          # CI/CD 자동화 (Linting, Validation)
│
├── 📂 config/                 # 설정 파일 템플릿
│   ├── 📂 docker/             # Docker 데몬 설정
│   ├── 📂 nginx/              # 리버스 프록시 설정
│   ├── 📂 samba/              # SMB 파일 공유 설정
│   ├── 📂 unraid/             # Unraid OS 설정
│   └── 📂 wireguard/          # VPN 설정
│
├── 📂 docker/                 # Docker Compose 스택
│   ├── 📂 backup-stack/       # 백업 도구 (Duplicati, Rclone 등)
│   ├── 📂 management-stack/   # 관리 도구 (Portainer 등)
│   ├── 📂 media-stack/        # 미디어 서버 (Plex, *arr, Downloaders)
│   ├── 📂 monitoring-stack/   # 모니터링 (Prometheus, Grafana)
│   └── 📂 services/           # 개별 독립 서비스
│
├── 📂 docs/                   # 프로젝트 문서 (단계별 가이드)
│   ├── 📂 00-getting-started/ # 시작하기 (하드웨어, 전제조건)
│   ├── 📂 01-planning/        # 계획 및 테스트
│   ├── 📂 02-setup-guides/    # 설치 및 설정 (BIOS, OS, 보안)
│   ├── 📂 03-application-guides/ # 애플리케이션 가이드
│   ├── 📂 04-operations/      # 운영 및 유지보수
│   ├── 📂 05-troubleshooting/ # 문제 해결
│   ├── 📂 06-disaster-recovery/ # 재해 복구
│   ├── 📂 07-reference/       # 참조 자료
│   └── 📂 08-advanced-topics/ # 고급 주제
│
├── 📂 monitoring/             # 모니터링 설정 세부
│   ├── 📂 alerts/             # 알림 규칙 정의
│   ├── 📂 grafana/            # 대시보드 JSON
│   └── 📂 prometheus/         # 수집기 설정
│
├── 📂 scripts/                # 자동화 및 유틸리티 스크립트
│   ├── 📂 automation/         # 일반 자동화 작업
│   ├── 📂 backup/             # 백업 실행 스크립트 (USB/Cloud)
│   ├── 📂 maintenance/        # 유지보수 스크립트
│   ├── 📂 monitoring/         # 헬스 체크 스크립트
│   └── 📂 setup/              # 초기 설정 스크립트
│
├── 📂 tests/                  # 테스트 코드 및 검증 스크립트
└── 📂 vm/                     # 가상머신(VM) 관련 설정
    ├── 📂 configs/            # VM 설정 파일
    └── 📂 templates/          # VM XML 템플릿
```

## 🏗️ 주요 구성 요소 상세

### 1. 문서 (`docs/`)
사용자가 순서대로 따라갈 수 있도록 넘버링된 구조를 가집니다.
- **00~02**: 시스템 구축 초기 단계 (하드웨어 ~ OS 설치).
- **03**: Docker 서비스 및 애플리케이션 활용.
- **04~06**: 실제 운영 중 발생하는 유지보수, 장애 대응, 복구.

### 2. Docker 스택 (`docker/`)
기능 단위로 모듈화된 `docker-compose.yml` 파일들을 관리합니다.
- **media-stack**: 가장 핵심적인 미디어 서버 기능 (GPU 사용 포함).
- **monitoring-stack**: 시스템 상태를 시각화하고 감시.
- **backup-stack**: 데이터의 안전한 보관을 위한 도구 모음.
- *모든 컨테이너는 `PUID=99`, `PGID=100` 권한과 `/mnt/user/appdata` 경로 규칙을 따릅니다.*

### 3. 스크립트 (`scripts/`)
Unraid 호스트 시스템에서 직접 실행되는 Bash 스크립트입니다.
- `setup/initial_setup.sh`: 초기 디렉토리 생성 및 기본 설정 자동화.
- `backup/*.sh`: 주기적인 데이터 백업(User Scripts 플러그인 연동).
- *모든 스크립트는 `shellcheck` 검증을 준수합니다.*

### 4. 설정 (`config/`)
사용자가 환경에 맞춰 수정하여 사용할 수 있는 설정 템플릿(`*.example`)을 제공합니다.
- 실제 배포 시 `.example` 확장자를 제거하고 내용을 수정하여 적용합니다.

### 5. 모니터링 (`monitoring/`)
Prometheus와 Grafana를 위한 설정 파일들입니다.
- `prometheus.yml`: 메트릭 수집 대상 정의.
- `alerts.yml`: 이상 징후 발생 시 알림 규칙.

## 🔄 작업 워크플로우

1.  **탐색**: `README.md`를 통해 프로젝트 개요 파악.
2.  **학습**: `docs/00-getting-started`부터 순차적으로 가이드 진행.
3.  **설치**: `scripts/setup/`을 이용해 기본 환경 구성.
4.  **배포**: `docker/` 내의 스택을 `docker-compose up -d`로 실행.
5.  **운영**: `DEPLOYMENT.md`의 체크리스트를 따라 검증 및 운영.

## 🛡️ 보안 및 기여 가이드

- **민감 정보 보호**: 비밀번호, API 키 등은 절대 git에 커밋하지 않습니다.
- **코드 스타일**: Shell 스크립트는 Google Shell Style Guide를, 문서는 Markdown 표준을 따릅니다.
- **검증**: 변경 사항은 `.github/workflows/validate.yml`을 통해 자동 검증됩니다.
