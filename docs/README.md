# 📚 Unraid NAS 문서 센터

> Unraid 홈랩 NAS 구축을 위한 종합 문서입니다.

## 🚀 빠른 시작

처음 시작하는 분들을 위한 추천 경로:

1. **[시작하기](00-getting-started/)** - 프로젝트 개요 및 사전 요구사항
2. **[계획하기](01-planning/)** - 하드웨어 선택 및 구성 계획
3. **[설치하기](02-setup-guides/)** - 단계별 설치 가이드
4. **[애플리케이션](03-application-guides/)** - Docker 앱 설치
5. **[운영하기](04-operations/)** - 일상 운영 및 유지보수

## 📂 문서 구조

### [00-getting-started/](00-getting-started/) - 시작 가이드
- 프로젝트 개요
- 사전 요구사항
- 하드웨어 요구사항
- 의사결정 트리

### [01-planning/](01-planning/) - 계획 단계
- [하드웨어 체크리스트](01-planning/hardware-checklist.md)
- 하드웨어 테스트 절차 🆕
- 네트워크 설계
- 스토리지 아키텍처
- 비용 분석

### [02-setup-guides/](02-setup-guides/) - 설치 가이드
- BIOS 구성 🆕
- [USB 부팅 드라이브](02-setup-guides/02-usb-boot-drive.md) 🆕
- [초기 설치](02-setup-guides/03-initial-installation.md)
- [어레이 구성](02-setup-guides/04-array-configuration.md) 🆕
- [보안 강화](02-setup-guides/07-security-hardening.md)
- 검증 체크리스트 🆕

### [03-application-guides/](03-application-guides/) - 애플리케이션 가이드
- **[미디어 서버](03-application-guides/media-server/)**
  - Plex 설정
  - Jellyfin 설정
  - Sonarr/Radarr
- **[백업 솔루션](03-application-guides/backup-solutions/)**
  - 로컬 백업
  - 클라우드 백업
  - BTRFS 스냅샷
- **[사진 관리](03-application-guides/photo-management/)**
  - Immich 설정
- **[클라우드 스토리지](03-application-guides/cloud-storage/)**
  - Nextcloud
  - Syncthing
- **[모니터링](03-application-guides/monitoring/)**
  - Netdata
  - Grafana/Prometheus
- **[관리 도구](03-application-guides/management-tools/)**
  - Portainer
  - Nginx Proxy Manager

### [04-operations/](04-operations/) - 운영 가이드
- 일일/주간 작업 🆕
- 월간 유지보수
- 패리티 체크
- 디스크 교체 절차 🆕
- 백업 검증

### [05-troubleshooting/](05-troubleshooting/) - 문제 해결
- 일반 문제 🆕
- 부팅 실패 🆕
- 어레이 문제
- 디스크 오류
- Docker 이슈
- 네트워크 문제 🆕
- 성능 튜닝

### [06-disaster-recovery/](06-disaster-recovery/) - 재해 복구 🆕
- 복구 절차
- 복구 테스트
- 비상 연락처

### [07-reference/](07-reference/) - 참조 문서
- 명령어 참조
- 포트 목록
- 구성 템플릿
- 외부 리소스

### [08-advanced-topics/](08-advanced-topics/) - 고급 주제
- GPU 패스스루
- VLAN 구성
- 원격 접속
- 성능 최적화

## 🔍 문서 찾기

### 목적별 가이드

#### 🏗️ **구축하려는 경우**
1. [하드웨어 체크리스트](01-planning/hardware-checklist.md)
2. [초기 설치 가이드](02-setup-guides/03-initial-installation.md)
3. [보안 설정](02-setup-guides/07-security-hardening.md)

#### 🔧 **문제 해결이 필요한 경우**
- [문제 해결 가이드](05-troubleshooting/)
- [일반적인 문제](05-troubleshooting/common-issues.md)

#### 📊 **모니터링 설정**
- [모니터링 앱](03-application-guides/monitoring/)
- [성능 모니터링](04-operations/performance-monitoring.md)

#### 💾 **백업 구현**
- [백업 전략](03-application-guides/backup-solutions/)
- [복구 테스트](06-disaster-recovery/recovery-testing.md)

## 📝 문서 표준

모든 문서는 다음 형식을 따릅니다:

```markdown
---
title: 문서 제목
category: 카테고리
difficulty: 초급|중급|고급
estimated_time: 예상 소요 시간
prerequisites: [필요한 사전 지식]
---

# 제목

## 목차

## 개요

## 사전 요구사항

## 단계별 가이드

## 검증

## 문제 해결

## 다음 단계
```

## 🆕 최근 추가/업데이트

- ✅ 하드웨어 테스트 절차 추가
- ✅ 재해 복구 섹션 신설
- ✅ 문제 해결 가이드 확장
- ✅ BIOS 상세 구성 가이드
- ✅ 디스크 교체 절차

## 🤝 기여하기

문서 개선에 기여하려면:

1. 이슈를 생성하여 제안사항 공유
2. Pull Request로 직접 수정 제출
3. 문서 표준을 준수해주세요

## 📞 도움말

- **Unraid 포럼**: https://forums.unraid.net
- **Reddit**: r/unraid
- **Discord**: Unraid Community

---

*마지막 업데이트: 2025년 1월*