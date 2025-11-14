# 🖥️ 하드웨어 요구사항

Unraid NAS 구축을 위한 하드웨어 사양 가이드

---

## 📊 권장 사양 vs 실제 구축 사양

### 최소 요구사항
| 구성요소 | 최소 사양 | 권장 사양 | **실제 구축** |
|---------|----------|----------|------------|
| CPU | 64-bit CPU | Intel i3/AMD Ryzen 3 이상 | **Intel Core i3-14100T** |
| RAM | 4GB | 16GB+ ECC | **64GB DDR5-5600** |
| 디스크 | 1개 | 3개 이상 (패리티+데이터) | **HDD 3개 + SSD + NVMe** |
| USB | 1GB | 8-32GB USB 2.0/3.0 | 준비 필요 |
| 네트워크 | 100Mbps | Gigabit Ethernet | **Gigabit (온보드)** |

## 🔧 실제 구축 하드웨어 상세

### CPU: Intel Core i3-14100T
```yaml
모델: Intel Core i3-14100T (14세대 Raptor Lake)
코어/스레드: 4코어 / 8스레드
기본 클럭: 2.7 GHz
부스트 클럭: 4.4 GHz
TDP: 35W (저전력)
내장 그래픽: Intel UHD Graphics 730
특징:
  - Quick Sync Video (하드웨어 트랜스코딩)
  - AES-NI (암호화 가속)
  - VT-x, VT-d (가상화 지원)
  - 저전력으로 24/7 운영 최적
```

### 메인보드: ASRock B760M Pro-A 7.03
```yaml
모델: ASRock B760M Pro-A
칩셋: Intel B760
소켓: LGA1700
폼팩터: Micro-ATX
메모리:
  - DDR5 지원 (최대 192GB)
  - 4 DIMM 슬롯
  - 최대 7200MHz+ OC
스토리지:
  - SATA3: 4개 포트
  - M.2: 2개 슬롯 (PCIe 4.0 x4)
확장 슬롯:
  - PCIe 4.0 x16: 1개
  - PCIe 3.0 x1: 2개
네트워크:
  - Realtek RTL8111H Gigabit LAN
  - Wake-On-LAN 지원
```

### 메모리: Team Group 64GB DDR5
```yaml
모델: Team Group DDR5-5600
구성: 32GB × 2개 (총 64GB)
속도: 5600MHz
타이밍: CL46
전압: 1.1V
특징:
  - 대용량으로 Docker/VM 운영 유리
  - 캐시 및 트랜스코딩 성능 향상
  - ZFS 사용 시 ARC 캐시 활용 가능
```

### 스토리지 구성

#### HDD: TOSHIBA DT01ACA300 (3TB × 3)
```yaml
모델: TOSHIBA DT01ACA300
용량: 3TB × 3개
인터페이스: SATA 6Gb/s
RPM: 7200
캐시: 64MB
용도: 데이터 어레이
구성 옵션:
  - 옵션 1: 2개 데이터 + 1개 패리티 = 6TB 보호 용량
  - 옵션 2: 3개 데이터 (패리티 없음) = 9TB 비보호 용량
  - 옵션 3: 추후 HDD 추가 시 패리티 구성
```

#### SSD: SanDisk 500GB SATA
```yaml
모델: SanDisk SATA SSD
용량: 500GB
인터페이스: SATA 6Gb/s
용도: 캐시 드라이브
기능:
  - Docker 앱 데이터 (appdata)
  - 시스템 파일
  - 다운로드 임시 저장
  - 데이터베이스
```

#### NVMe: XPG GAMMIX S11 Pro 1TB
```yaml
모델: XPG GAMMIX S11 Pro
용량: 1TB
인터페이스: PCIe 3.0 x4
읽기 속도: 최대 3500MB/s
쓰기 속도: 최대 3000MB/s
용도 옵션:
  - VM 스토리지 (고속 필요)
  - 고성능 캐시 풀
  - 미디어 트랜스코딩 임시 공간
  - 중요 데이터 빠른 접근
```

## 💰 비용 분석

### 하드웨어 비용 (2025년 1월 기준)
| 구성요소 | 예상 가격 | 실제 가격 |
|---------|-----------|----------|
| Intel i3-14100T | 180,000원 | _____원 |
| ASRock B760M Pro-A | 150,000원 | _____원 |
| DDR5 32GB × 2 | 300,000원 | _____원 |
| TOSHIBA 3TB × 3 | 270,000원 | _____원 |
| SanDisk SSD 500GB | 60,000원 | _____원 |
| XPG NVMe 1TB | 100,000원 | _____원 |
| **합계** | **약 1,060,000원** | _____원 |

### 운영 비용
```yaml
전력 소비:
  - 유휴: 약 35W
  - 평균: 약 45W
  - 최대: 약 65W

월간 전기료:
  - 45W × 24시간 × 30일 = 32.4kWh
  - 32.4kWh × 300원 = 약 9,720원/월
  - 연간: 약 116,640원

Unraid 라이선스:
  - Basic (6 드라이브): $59 (약 75,000원)
  - Plus (12 드라이브): $89 (약 115,000원) ← 추천
  - Pro (무제한): $129 (약 167,000원)
```

## 🎯 용도별 성능 예측

### 미디어 서버
```yaml
Plex/Jellyfin 트랜스코딩:
  - Quick Sync 활용: 4-6개 동시 1080p
  - CPU 트랜스코딩: 2-3개 동시 1080p
  - 다이렉트 플레이: 10+ 스트림

4K 지원:
  - 다이렉트 플레이: 지원
  - 트랜스코딩: 1-2개 스트림 (Quick Sync)
```

### Docker 컨테이너
```yaml
예상 운영 가능:
  - 경량 컨테이너: 50-70개
  - 중간 컨테이너: 30-40개
  - 무거운 컨테이너: 15-20개

메모리 할당 예시:
  - 시스템: 4GB
  - Docker: 40GB
  - VM: 15GB (필요시)
  - 캐시/버퍼: 5GB
```

### 파일 서버
```yaml
SMB 성능:
  - 읽기: 110-115 MB/s (Gigabit 한계)
  - 쓰기: 100-110 MB/s
  - NVMe 캐시 활용 시: 더 빠른 초기 속도

용량:
  - 패리티 구성: 6TB 보호
  - 패리티 없음: 9TB 비보호
  - 혼합 구성 가능
```

## ⚙️ BIOS 최적화 설정 (ASRock B760M Pro-A)

### 필수 설정
```bash
Advanced Mode (F6)
├─ Advanced
│   ├─ Storage Configuration
│   │   └─ SATA Mode Selection: [AHCI] ← 중요!
│   ├─ CPU Configuration
│   │   ├─ Intel VT-x: [Enabled]
│   │   ├─ Intel VT-d: [Enabled]
│   │   └─ C-States: [Enabled]
│   └─ ACPI Configuration
│       └─ Restore on AC Power Loss: [Power On]
├─ Boot
│   ├─ Boot Mode: [UEFI]
│   ├─ Fast Boot: [Disabled]
│   └─ Boot Priority: [USB First]
└─ Security
    └─ Secure Boot: [Disabled]
```

## 🔄 업그레이드 경로

### 단기 (3-6개월)
- [ ] HDD 1개 추가 → 패리티 구성
- [ ] UPS 추가 (정전 보호)
- [ ] 10Gb 네트워크 카드 (선택)

### 중기 (6-12개월)
- [ ] HDD를 대용량으로 교체 (3TB → 8-12TB)
- [ ] 2.5Gb/10Gb 네트워크 업그레이드
- [ ] 외장 백업 디스크 추가

### 장기 (1년 이상)
- [ ] 듀얼 패리티 구성 (디스크 6개 이상)
- [ ] ECC 메모리 시스템으로 전환
- [ ] 별도 백업 NAS 구축

## ✅ 하드웨어 준비 체크리스트

### 보유 확인
- [x] CPU: Intel i3-14100T
- [x] 메인보드: ASRock B760M Pro-A
- [x] RAM: 64GB DDR5
- [x] HDD: 3TB × 3
- [x] SSD: 500GB
- [x] NVMe: 1TB

### 추가 필요
- [ ] USB 드라이브 (8-32GB)
- [ ] SATA 케이블 (여분)
- [ ] 케이스 (미정)
- [ ] 파워서플라이 (미정)
- [ ] CPU 쿨러 (박스 쿨러 또는 별도)

### 선택 사항
- [ ] UPS (정전 보호)
- [ ] 추가 HDD (패리티용)
- [ ] 케이스 팬
- [ ] 네트워크 카드 업그레이드

## 🌡️ 발열 및 전력 관리

### 예상 온도
```yaml
CPU (i3-14100T):
  - 유휴: 35-40°C
  - 부하: 55-65°C
  - 최대: 70°C (안전)

HDD:
  - 정상: 30-40°C
  - 주의: 45°C 이상
  - 위험: 50°C 이상

SSD/NVMe:
  - 정상: 40-60°C
  - 주의: 70°C 이상
```

### 냉각 권장사항
- CPU: 기본 쿨러로 충분 (35W TDP)
- 케이스: 전면 흡기 1개, 후면 배기 1개
- HDD: 직접 공기 흐름 확보

## 🚀 다음 단계

하드웨어가 준비되었다면:

1. **[하드웨어 테스트](../01-planning/hardware-testing.md)** - 사전 검증
2. **[BIOS 설정](../02-setup-guides/01-bios-configuration.md)** - ASRock 최적화
3. **[USB 생성](../02-setup-guides/02-usb-boot-drive.md)** - Unraid 설치 준비

---

💡 **팁**: i3-14100T는 저전력 고효율 CPU로 24/7 NAS 운영에 이상적입니다. Quick Sync 지원으로 미디어 서버 용도로도 훌륭합니다.

⚡ **성능**: 64GB RAM은 과할 수 있지만, Docker 컨테이너를 많이 운영하거나 VM을 사용한다면 충분히 활용 가능합니다.