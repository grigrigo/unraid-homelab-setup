# Unraid 홈랩 NAS 구축 프로젝트

## 프로젝트 개요
개인용 NAS 서버를 Unraid OS를 이용해 구축하는 프로젝트입니다. 엔터프라이즈급 기능을 가정에서 구현하며, 데이터 안정성과 확장성을 모두 갖춘 시스템을 목표로 합니다.

## 시스템 사양
- **CPU**: Intel 저전력 CPU (Celeron/Pentium/i3)
- **RAM**: 64GB DDR4
- **메인보드**: ASRock (M.2 슬롯 포함)
- **스토리지**:
  - 3TB HDD × 4개 (Array)
  - 500GB SATA SSD (Cache)
  - 1TB NVMe SSD (고성능 풀, 옵션)
- **GPU**: GTX 1050 2GB (하드웨어 트랜스코딩)
- **전력 소비**: 45-80W

## 주요 기능
### 스토리지
- 싱글 패리티: 9TB 가용 공간
- 듀얼 패리티: 6TB 가용 공간 (선택)
- 1개(또는 2개) 디스크 실패 시 데이터 보호

### 미디어 서버
- Plex/Jellyfin 미디어 스트리밍
- 하드웨어 트랜스코딩 (5-8개 동시 스트림)
- 4K 콘텐츠 지원

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

## 문서 구조
```
docs/
├── 01_hardware_checklist.md    # 하드웨어 체크리스트
├── 02_installation_guide.md    # 설치 가이드
├── 03_security_setup.md        # 보안 설정
├── 04_docker_apps.md          # Docker 앱 설치
├── 05_backup_strategy.md      # 백업 전략
└── Unraid_NAS_Complete_Guide_2025_4HDD.md  # 전체 가이드
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