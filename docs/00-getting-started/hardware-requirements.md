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
| GPU | 없음 (선택) | iGPU 또는 전용 GPU | **Intel UHD 730 + GTX 1050** |
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

#### SSD: Samsung 830 Series 128GB SATA
```yaml
모델: Samsung 830 Series
용량: 128GB
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

### 그래픽카드: NVIDIA GeForce GTX 1050
```yaml
모델: NVIDIA GeForce GTX 1050
아키텍처: Pascal (GP107)
CUDA 코어: 640개
메모리: 2GB GDDR5
메모리 버스: 128-bit
TDP: 75W
인터페이스: PCIe 3.0 x16
비디오 출력:
  - DisplayPort 1.4
  - HDMI 2.0b
  - DVI-D
인코더: NVENC (1세대)
특징:
  - 하드웨어 비디오 인코딩/디코딩
  - Plex/Jellyfin 트랜스코딩 가속
  - 동시 트랜스코딩 제한: 2개 (드라이버 제한)
  - Nvidia Unlocked Patch로 제한 해제 가능
용도:
  - 미디어 서버 하드웨어 트랜스코딩
  - VM GPU 패스스루 (선택)
  - Docker 컨테이너 GPU 가속
주의사항:
  - 2개 스트림 제한 (GTX 1000 시리즈)
  - Patch 적용 시 무제한 트랜스코딩 가능
  - Intel Quick Sync와 병행 사용 권장
```

## 💰 비용 분석

### 하드웨어 비용 (2025년 1월 기준)
| 구성요소 | 예상 가격 | 실제 가격 |
|---------|-----------|----------|
| Intel i3-14100T | 180,000원 | _____원 |
| ASRock B760M Pro-A | 150,000원 | _____원 |
| DDR5 32GB × 2 | 300,000원 | _____원 |
| TOSHIBA 3TB × 3 | 270,000원 | _____원 |
| Samsung 830 SSD 128GB | 30,000원 | _____원 |
| XPG NVMe 1TB | 100,000원 | _____원 |
| NVIDIA GTX 1050 2GB | 80,000원 | _____원 |
| **합계** | **약 1,110,000원** | _____원 |

### 운영 비용
```yaml
전력 소비:
  - 유휴: 약 45W (CPU 35W + GPU 10W)
  - 평균: 약 65W (CPU 45W + GPU 20W)
  - 최대: 약 110W (CPU 35W + GPU 75W 풀로드)

월간 전기료:
  - 65W × 24시간 × 30일 = 46.8kWh
  - 46.8kWh × 300원 = 약 14,040원/월
  - 연간: 약 168,480원

Unraid 라이선스:
  - Basic (6 드라이브): $59 (약 75,000원)
  - Plus (12 드라이브): $89 (약 115,000원) ← 추천
  - Pro (무제한): $129 (약 167,000원)
```

## 🎯 용도별 성능 예측

### 미디어 서버
```yaml
Plex/Jellyfin 트랜스코딩:
  - Intel Quick Sync: 4-6개 동시 1080p
  - NVIDIA NVENC (GTX 1050): 2개 동시 1080p (제한)
  - NVIDIA NVENC (Patch 적용): 10-15개 동시 1080p
  - CPU 트랜스코딩: 2-3개 동시 1080p
  - 다이렉트 플레이: 10+ 스트림
  - 권장: Quick Sync + NVENC 병행 사용

4K 지원:
  - 다이렉트 플레이: 지원
  - 트랜스코딩 (Quick Sync): 1-2개 스트림
  - 트랜스코딩 (NVENC): 1-2개 스트림
  - H.265/HEVC: 하드웨어 디코딩 지원
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
- [x] SSD: 128GB Samsung 830
- [x] NVMe: 1TB
- [x] GPU: NVIDIA GTX 1050 2GB

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

GPU (GTX 1050):
  - 유휴: 30-35°C
  - 트랜스코딩: 50-65°C
  - 최대: 80°C (안전)
  - 팬 속도: 자동 조절

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
- GPU: 팬 포함 모델 권장 (75W TDP)
- 케이스: 전면 흡기 1-2개, 후면 배기 1개
- HDD: 직접 공기 흐름 확보
- PCIe 슬롯: GPU 하단 여유 공간 확보

## 🚀 다음 단계

하드웨어가 준비되었다면:

1. **[하드웨어 테스트](../01-planning/hardware-testing.md)** - 사전 검증
2. **[BIOS 설정](../02-setup-guides/01-bios-configuration.md)** - ASRock 최적화
3. **[USB 생성](../02-setup-guides/02-usb-boot-drive.md)** - Unraid 설치 준비

---

💡 **팁**: i3-14100T는 저전력 고효율 CPU로 24/7 NAS 운영에 이상적입니다. Quick Sync 지원으로 미디어 서버 용도로도 훌륭합니다.

⚡ **성능**: 64GB RAM은 과할 수 있지만, Docker 컨테이너를 많이 운영하거나 VM을 사용한다면 충분히 활용 가능합니다.