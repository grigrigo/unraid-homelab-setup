# 리포지토리 구조

이 문서는 Unraid 홈랩 설정 리포지토리의 구조와 내용을 설명합니다.

## 디렉토리 개요

```
unraid-homelab-setup/
├── docs/                      # 문서 파일
│   ├── 01_hardware_checklist.md
│   ├── 02_installation_guide.md
│   ├── 03_security_setup.md
│   ├── 04_docker_apps.md
│   ├── 05_backup_strategy.md
│   └── Unraid_NAS_Complete_Guide_2025_4HDD.md
│
├── scripts/                   # 자동화를 위한 셸 스크립트
│   ├── backup/               # 백업 스크립트
│   │   ├── usb_backup.sh
│   │   └── cloud_backup.sh
│   ├── monitoring/           # 모니터링 스크립트
│   ├── automation/           # 자동화 스크립트
│   ├── maintenance/          # 유지보수 스크립트
│   └── setup/                # 설정 스크립트
│       └── initial_setup.sh
│
├── docker/                    # Docker 구성
│   ├── media-stack/          # 미디어 서버 스택
│   │   ├── docker-compose.yml
│   │   └── .env.example
│   ├── backup-stack/         # 백업 서비스
│   │   └── docker-compose.yml
│   ├── monitoring-stack/     # 모니터링 서비스
│   │   └── docker-compose.yml
│   ├── management-stack/     # 관리 도구
│   └── services/             # 개별 서비스
│
├── config/                    # 구성 템플릿
│   ├── unraid/               # Unraid 설정
│   ├── docker/               # Docker 설정
│   ├── nginx/                # Nginx 설정
│   ├── wireguard/            # VPN 설정
│   └── samba/                # SMB 설정
│
├── monitoring/                # 모니터링 구성
│   ├── grafana/              # Grafana 대시보드
│   ├── prometheus/           # Prometheus 설정
│   │   ├── prometheus.yml
│   │   └── alerts.yml
│   └── alerts/               # 알림 규칙
│
├── vm/                        # VM 구성
│   ├── templates/            # VM 템플릿
│   └── configs/              # VM 설정
│
├── tests/                     # 테스트 스크립트
├── logs/                      # 로그 파일 (gitignored)
│
├── .github/                   # GitHub Actions
│   └── workflows/
│       └── validate.yml      # CI/CD 파이프라인
│
├── .gitignore                 # Git ignore 파일
├── LICENSE                    # 라이선스 파일
├── README.md                  # 프로젝트 개요
└── STRUCTURE.md              # 이 파일
```

## 파일 카테고리

### 문서 (`docs/`)
- 설정 및 구성을 위한 단계별 가이드
- 하드웨어 요구사항 및 체크리스트
- 보안 모범 사례
- 완전한 참조 가이드

### 스크립트 (`scripts/`)
- **backup/**: USB와 클라우드로의 자동 백업
- **monitoring/**: 헬스 체크 및 모니터링 스크립트
- **automation/**: 작업 자동화 스크립트
- **maintenance/**: 시스템 유지보수 스크립트
- **setup/**: 초기 설정 및 구성

### Docker 스택 (`docker/`)
- **media-stack**: Plex/Jellyfin, Sonarr, Radarr 등
- **backup-stack**: Duplicati, Restic, Rclone, Kopia
- **monitoring-stack**: Prometheus, Grafana, Netdata
- **management-stack**: Portainer, Nginx Proxy Manager

### 구성 템플릿 (`config/`)
- 즉시 사용 가능한 구성 파일
- 환경 변수 템플릿
- 네트워크 및 보안 설정

### 모니터링 (`monitoring/`)
- Prometheus 구성 및 알림 규칙
- Grafana 대시보드 정의
- 커스텀 메트릭 및 익스포터

## 사용 워크플로우

1. **계획 단계**
   - `docs/01_hardware_checklist.md` 검토
   - 시스템 요구사항 확인

2. **설치 단계**
   - `docs/02_installation_guide.md` 따라하기
   - `scripts/setup/initial_setup.sh` 실행

3. **구성 단계**
   - `config/`에서 구성 적용
   - `docs/03_security_setup.md`를 사용하여 보안 설정

4. **서비스 배포**
   - `docker/`에서 Docker 스택 배포

5. **모니터링 설정**
   - Prometheus/Grafana 구성
   - 알림 및 대시보드 설정

6. **백업 구현**
   - 백업 스크립트 구성
   - 자동화된 스케줄 설정

## 기여하기

새 콘텐츠 추가 시:

1. **스크립트**: `scripts/`의 적절한 하위 디렉토리에 추가
2. **설정**: `.example` 접미사를 붙여 `config/`에 템플릿 배치
3. **Docker**: `docker/`에 새 스택 생성 또는 기존 스택에 추가
4. **문서**: `docs/`의 관련 문서 업데이트

## 보안 참고사항

- 민감한 데이터(비밀번호, 키, 토큰)는 절대 커밋하지 마세요
- 템플릿에는 `.example` 파일 사용
- 시크릿은 `.env` 파일에 저장 (gitignored)
- 커밋 전 `.gitignore` 검토

## 유지보수

정기적으로 업데이트 필요:
- Docker 이미지 버전
- 보안 패치
- 문서 업데이트
- 스크립트 개선

## 지원

문제나 질문이 있을 경우:
- 기존 문서 확인
- GitHub에서 종료된 이슈 검토
- 상세 내용과 함께 새 이슈 생성