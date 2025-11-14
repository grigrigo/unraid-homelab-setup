# Unraid 홈랩 NAS 구축 프로젝트

## 프로젝트 개요
개인용 NAS 서버를 Unraid OS를 이용해 구축하는 프로젝트입니다. 엔터프라이즈급 기능을 가정에서 구현하며, 데이터 안정성과 확장성을 모두 갖춘 시스템을 목표로 합니다.

## 시스템 사양
- **CPU**: Intel Core i3-14100T (4코어/8스레드, TDP 35W)
- **RAM**: 64GB DDR5-5600 (Team Group 32GB × 2)
- **메인보드**: ASRock B760M Pro-A (LGA1700, M.2 슬롯 2개)
- **스토리지**:
  - TOSHIBA DT01ACA300 3TB × 3개 (Array)
  - SanDisk 500GB SATA SSD (앱/캐시)
  - XPG GAMMIX S11 Pro 1TB NVMe (고속 캐시)
- **GPU**: Intel UHD Graphics 730 (Quick Sync 지원)
- **전력 소비**: 35-65W (실측 기준)

## 주요 기능
### 스토리지 옵션
- 패리티 보호: 6TB 가용 공간 (1개 디스크 실패 보호)
- 패리티 없음: 9TB 가용 공간 (보호 없음)
- 추후 HDD 추가 시 패리티 구성 가능

### 미디어 서버
- Plex/Jellyfin 미디어 스트리밍
- Intel Quick Sync 하드웨어 트랜스코딩 (4-6개 1080p 동시 스트림)
- 4K 콘텐츠 지원 (다이렉트 플레이)

### 데이터 보호
- 3-2-1 백업 전략 구현
- 로컬 백업 (외장 HDD)
- 클라우드 백업 (Backblaze B2)
- BTRFS 스냅샷

### 보안
- SSL/TLS 암호화
- 2단계 인증 (2FA)
- VPN 접속 (Tailscale/WireGuard)
- 방화벽 및 침입 탐지

## 📚 문서 구조
```
docs/
├── 00-getting-started/          # 시작 가이드
│   ├── prerequisites.md        # 사전 요구사항
│   └── hardware-requirements.md # 하드웨어 사양
├── 01-planning/                 # 계획 단계
│   ├── hardware-checklist.md   # 하드웨어 체크리스트
│   └── hardware-testing.md     # 하드웨어 테스트
├── 02-setup-guides/             # 설치 가이드
│   ├── 01-bios-configuration.md # BIOS 설정
│   ├── 03-initial-installation.md # 초기 설치
│   ├── 04-array-configuration.md  # 어레이 구성
│   └── 07-security-hardening.md   # 보안 강화
├── 03-application-guides/       # 애플리케이션
├── 04-operations/               # 운영 가이드
├── 05-troubleshooting/          # 문제 해결
├── 06-disaster-recovery/        # 재해 복구
└── 07-reference/               # 참조 문서
```

## 구축 일정

### 1주차: 기초 구축
- [ ] 하드웨어 준비 및 BIOS 설정
- [ ] Unraid OS 설치
- [ ] Array 구성 및 패리티 동기화
- [ ] 기본 공유 폴더 생성

### 2주차: 서비스 구축
- [ ] 보안 설정 (비밀번호, 방화벽)
- [ ] Docker 환경 구성
- [ ] 미디어 서버 설치 (Plex/Jellyfin)

### 3주차: 고급 기능
- [ ] 백업 시스템 구축
- [ ] GPU 설정 (하드웨어 트랜스코딩)
- [ ] 성능 최적화

### 4주차: 마무리
- [ ] 모니터링 시스템 구축
- [ ] 테스트 및 검증
- [ ] 문서화 완성

## 예상 비용

### 초기 투자
- Unraid Starter 라이선스: 60,000원
- USB 부팅 드라이브: 10,000원
- 외장 HDD 12TB (백업용): 400,000원 (선택)
- **총 필수 비용**: 70,000원

### 월간 운영 비용
- 전기료 (65W 평균): 11,700원
- 클라우드 백업 (선택): 36,000원
- Starter 라이선스 연장: 3,750원/월
- **총 월간 비용**: 약 15,000-50,000원

## 달성 가능한 성능
- ✅ 9TB (싱글) 또는 6TB (듀얼) 보호된 스토리지
- ✅ 1.5TB 고속 캐시 (SSD + NVMe)
- ✅ 5-8개 동시 미디어 트랜스코딩
- ✅ 50+ Docker 컨테이너 운영 가능
- ✅ 다중 VM 호스팅 (64GB RAM)
- ✅ 월 전기료 12,000원 이하
- ✅ 엔터프라이즈급 보안

## 시작하기
1. `docs/01_hardware_checklist.md`로 하드웨어 확인
2. `docs/02_installation_guide.md`를 따라 Unraid 설치
3. 각 문서를 순서대로 진행하며 시스템 구축

## 지원 및 참고자료
- [Unraid 공식 포럼](https://forums.unraid.net)
- [Unraid 공식 문서](https://docs.unraid.net)
- [SpaceInvaderOne YouTube](https://www.youtube.com/channel/UCZDfnUn74N0WeAPvMqTOrtA)

## 라이선스
이 프로젝트 문서는 개인 사용 목적으로 작성되었습니다.

---
*마지막 업데이트: 2025년 1월*