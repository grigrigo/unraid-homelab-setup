# Unraid OS 가정용 NAS 구축 완벽 가이드 (4-HDD 구성)

> **2025년 1월 업데이트:** 
> - Unraid 라이선스 정책이 2024년 3월 27일부로 변경되었습니다 (Starter/Unleashed/Lifetime)
> - **모든 라이선스 티어에서 듀얼 패리티를 지원합니다** (Basic 포함)
> - 3TB HDD 4개 구성으로 싱글 패리티 9TB 또는 듀얼 패리티 6TB 선택 가능

Intel 저전력 CPU 기반 자체 조립 PC에 Unraid OS를 설치하여 가정용 NAS를 구축하는 것은 2025년 현재 가장 유연하고 확장 가능한 스토리지 솔루션입니다. **주어진 하드웨어 스펙(Intel 저전력 CPU, ASRock 메인보드, 64GB RAM, 3TB HDD 4개, 500GB SSD)은 Unraid와 완벽하게 호환**되며, 적절히 구성하면 전력 소비 45-80W의 효율적인 시스템을 구축할 수 있습니다. 이 가이드는 설치부터 보안 강화, 성능 최적화까지 가정용 NAS 구축에 필요한 모든 단계를 상세히 다룹니다.

Unraid는 기본적으로 보안 기능을 비활성화한 채로 출하되어 초기 설정을 쉽게 만들지만, 이는 곧 사용자가 직접 보안을 강화해야 함을 의미합니다. 3TB 드라이브 4개로 구성할 경우 **싱글 패리티로 9TB의 보호된 저장공간** 또는 **듀얼 패리티로 6TB의 강력하게 보호된 저장공간**을 확보할 수 있으며, 500GB SSD를 캐시로 활용하면 쓰기 속도가 2-3배 향상됩니다. 본 가이드는 공식 Unraid 문서와 2024-2025년 커뮤니티 모범 사례를 기반으로 작성되었습니다.

---

## 목차

1. [Unraid OS 기본 설치 프로세스](#unraid-os-기본-설치-프로세스)
2. [USB 부팅 드라이브 생성과 주의사항](#usb-부팅-드라이브-생성과-주의사항)
3. [BIOS 설정 최적화 (ASRock 메인보드)](#bios-설정-최적화-asrock-메인보드)
4. [스토리지 아키텍처 설계 (4-HDD 전략)](#스토리지-아키텍처-설계-4-hdd-전략)
5. [초기 설치 및 어레이 구성](#초기-설치-및-어레이-구성)
6. [GTX 1050 GPU 추가 구성](#gtx-1050-gpu-추가-구성)
7. [NVMe SSD 추가 및 다중 풀 전략](#nvme-ssd-추가-및-다중-풀-전략)
8. [보안 강화 전략](#보안-강화-전략)
9. [Docker 컨테이너 환경 구축](#docker-컨테이너-환경-구축)
10. [VM(가상머신) 환경 구축](#vm가상머신-환경-구축)
11. [백업 전략 수립](#백업-전략-수립)
12. [성능 최적화](#성능-최적화)
13. [모니터링 및 유지보수](#모니터링-및-유지보수)
14. [문제 해결 가이드](#문제-해결-가이드)

---

## Unraid OS 기본 설치 프로세스

Unraid 설치는 놀랍도록 간단합니다. **전체 운영체제가 USB 플래시 드라이브에서 RAM으로 로드**되어 실행되므로, USB는 부팅과 설정 저장용으로만 사용됩니다. 시스템 요구사항은 매우 관대하여 기본 NAS용으로는 2GB RAM만 있어도 작동하지만, Docker와 VM을 실행하려면 8GB 이상이 권장됩니다. 64GB RAM 구성은 VM과 Docker 컨테이너를 동시에 여러 개 실행하기에 이상적입니다.

### 시스템 요구사항

**최소 요구사항:**
- 64비트 x86 프로세서 (Intel 또는 AMD)
- 2GB RAM
- USB 포트 (USB 부팅 드라이브용)
- 최소 1개의 스토리지 드라이브

**권장 사양 (우리 구성):**
- Intel 저전력 CPU (Celeron, Pentium, i3 등)
- 64GB RAM (VM 및 Docker 호스팅에 이상적)
- 기가비트 이더넷
- ECC RAM (선택사항이지만 데이터 무결성에 권장)
- **3TB HDD × 4개** (싱글 패리티 9TB 또는 듀얼 패리티 6TB)

---

## USB 부팅 드라이브 생성과 주의사항

USB 플래시 드라이브는 **4GB에서 32GB 사이의 고품질 제품**을 선택해야 합니다. SanDisk 제품은 GUID 문제와 가짜 제품이 많아 공식적으로 권장되지 않습니다. Unraid USB Flash Creator 도구를 사용하면 자동으로 부팅 가능한 드라이브를 만들 수 있으며, Windows, macOS, Linux 모두 지원됩니다.

### 단계별 USB 생성 과정

1. **Unraid USB Creator 다운로드**
   - https://unraid.net/download 방문
   - Windows, macOS, Linux용 USB Creator 다운로드

2. **USB 드라이브 준비**
   - 4-32GB 고품질 USB 드라이브 준비
   - 권장 브랜드: Lexar, Patriot, Kingston (SanDisk 제외)
   - **중요:** USB 드라이브의 모든 데이터가 삭제됩니다

3. **USB Creator 실행**
   ```
   Windows: 관리자 권한으로 실행
   macOS/Linux: sudo 권한 필요
   ```

4. **설정 선택**
   - 버전: Stable (최신 안정 버전)
   - USB 드라이브 선택
   - 로컬 Zip 또는 다운로드 선택

5. **생성 완료 후**
   - USB 드라이브에 `config` 폴더가 생성되었는지 확인
   - GUID가 할당되었는지 확인
   - 트라이얼 키 자동 생성 확인 (30일 무료)

### Unraid 라이선스 옵션

> **중요:** 2024년 3월 27일부터 Unraid는 새로운 라이선스 모델로 전환했습니다. 기존 Basic, Plus, Pro는 더 이상 판매되지 않으며, 새로운 Starter, Unleashed, Lifetime 라이선스가 판매됩니다.

#### 현재 판매 중인 라이선스 (2025년 기준)

**Starter ($49):**
- 최대 6개 스토리지 디바이스
- **듀얼 패리티 지원** (모든 라이선스에서 지원)
- 1년 업데이트 포함 (이후 연간 $36 연장 옵션)

**Unleashed ($109):**
- 무제한 스토리지 디바이스
- **듀얼 패리티 지원**
- 1년 업데이트 포함 (이후 연간 $36 연장 옵션)

**Lifetime ($249):**
- 무제한 스토리지 디바이스
- **듀얼 패리티 지원**
- 평생 업데이트 포함

#### 레거시 라이선스 (기존 사용자만 해당)

**Basic ($59 - 판매 종료):**
- 최대 6개 스토리지 디바이스
- **듀얼 패리티 지원**
- 평생 업데이트

**Plus ($89 - 판매 종료):**
- 최대 12개 스토리지 디바이스
- **듀얼 패리티 지원**
- 평생 업데이트

**Pro ($129 - 판매 종료):**
- 최대 30개 스토리지 디바이스
- **듀얼 패리티 지원**
- 평생 업데이트

**우리 구성의 경우:** 
- 3TB HDD 4개 + 500GB SSD + 1TB NVMe = 6개 디바이스
- **Starter 라이선스**로 충분 (싱글/듀얼 패리티 모두 지원)
- 장기 사용 시 Lifetime 고려 (연장 비용 없음)

---

## BIOS 설정 최적화 (ASRock 메인보드)

ASRock 메인보드는 Unraid와 호환성이 우수하지만, 최적의 성능과 안정성을 위해 몇 가지 BIOS 설정을 조정해야 합니다.

### 필수 BIOS 설정

1. **부팅 순서 (Boot Priority)**
   ```
   Advanced → Boot → Boot Option #1: USB Flash Drive
   ```

2. **SATA 모드**
   ```
   Advanced → Storage Configuration → SATA Mode: AHCI
   ```
   - RAID 모드가 아닌 AHCI로 설정 (필수)

3. **가상화 기술 활성화 (VM 사용 시)**
   ```
   Advanced → CPU Configuration
   - Intel Virtualization Technology: Enabled
   - VT-d: Enabled (VM GPU 패스스루용)
   ```

4. **전력 관리 (저전력 CPU 최적화)**
   ```
   Advanced → CPU Configuration
   - C-States: Enabled
   - EIST (SpeedStep): Enabled
   - Turbo Mode: Auto
   ```

5. **전원 복구 설정**
   ```
   Advanced → ACPI Configuration
   - Restore on AC/Power Loss: Power On
   ```
   - 정전 후 자동 재시작

6. **Wake-on-LAN 활성화**
   ```
   Advanced → Onboard Devices Configuration
   - Onboard LAN: Enabled
   - Wake-on-LAN: Enabled
   ```

7. **USB 설정**
   ```
   Advanced → USB Configuration
   - Legacy USB Support: Enabled
   - XHCI Hand-off: Enabled
   ```

### ASRock 특화 설정

**Fast Boot 비활성화:**
```
Boot → Fast Boot: Disabled
```
- USB 부팅 인식 문제 방지

**CSM (Compatibility Support Module):**
```
Boot → CSM: Enabled (레거시 부팅용)
또는
Boot → CSM: Disabled (UEFI 전용)
```
- Unraid는 둘 다 지원하지만, 최신 시스템은 UEFI 권장

---

## 스토리지 아키텍처 설계 (4-HDD 전략)

Unraid의 스토리지 시스템은 기존 RAID와 다른 독특한 구조를 가지고 있습니다. 각 드라이브가 독립적인 파일시스템을 유지하면서도 패리티로 보호받습니다. **4개의 HDD로 두 가지 구성 전략을 선택할 수 있습니다.**

> **참고:** 듀얼 패리티(2개의 parity disk) 기능은 **모든 Unraid 라이선스 티어에서 지원**됩니다. Starter, Unleashed, Lifetime은 물론 레거시 Basic, Plus, Pro 모두 듀얼 패리티를 사용할 수 있습니다. 라이선스 차이는 오직 연결 가능한 디바이스 수 제한에만 있습니다.

### 구성 옵션 1: 싱글 패리티 (최대 용량)

**Array 구성:**
```
Parity Disk:  HDD 3TB #1
Data Disk 1:  HDD 3TB #2
Data Disk 2:  HDD 3TB #3
Data Disk 3:  HDD 3TB #4
Cache Drive:  SSD 500GB
```

**저장 용량:**
- 사용 가능 공간: **9TB** (3TB × 3)
- 패리티 보호: 1개 드라이브 실패까지 복구 가능
- 캐시: 500GB (빠른 쓰기 작업용)
- **장점:** 최대 저장 공간, 일반적인 홈 사용에 충분한 보호
- **단점:** 동시에 2개 드라이브 실패 시 데이터 손실

### 구성 옵션 2: 듀얼 패리티 (최고 안정성)

**Array 구성:**
```
Parity 1:     HDD 3TB #1
Parity 2:     HDD 3TB #2
Data Disk 1:  HDD 3TB #3
Data Disk 2:  HDD 3TB #4
Cache Drive:  SSD 500GB
```

**저장 용량:**
- 사용 가능 공간: **6TB** (3TB × 2)
- 패리티 보호: **2개 드라이브 동시 실패까지 복구 가능**
- 캐시: 500GB (빠른 쓰기 작업용)
- **장점:** 매우 높은 데이터 안정성, 중요 데이터에 적합
- **단점:** 저장 공간 50% 사용 (RAID 10과 동일)

### 권장 선택 기준

| 시나리오 | 권장 구성 | 이유 |
|---------|---------|------|
| 일반 홈 미디어 서버 | 싱글 패리티 (9TB) | 충분한 보호, 최대 공간 |
| 가족 사진/중요 문서 | 듀얼 패리티 (6TB) | 최고 수준 보호 |
| 백업 시스템 있음 | 싱글 패리티 (9TB) | 외부 백업으로 보완 |
| 백업 없는 유일본 | 듀얼 패리티 (6TB) | 데이터 손실 위험 최소화 |

### 고급 구성 (NVMe 1TB 추가 시)

**Multiple Pools 전략:**
```
Array (느린 스토리지):
- Parity:   HDD 3TB #1
- Data 1:   HDD 3TB #2
- Data 2:   HDD 3TB #3
- Data 3:   HDD 3TB #4

Cache Pool (중간 속도):
- Cache:    SSD 500GB SATA

NVMe Pool (고속 스토리지):
- NVMe:     1TB M.2 NVMe
```

또는 듀얼 패리티:
```
Array (느린 스토리지):
- Parity 1: HDD 3TB #1
- Parity 2: HDD 3TB #2
- Data 1:   HDD 3TB #3
- Data 2:   HDD 3TB #4

Cache Pool: SSD 500GB SATA
NVMe Pool:  1TB M.2 NVMe
```

**사용 시나리오 별 배치:**

| 데이터 유형 | 권장 위치 | 이유 |
|------------|----------|------|
| 사진 원본 (RAW) | Array | 장기 보관, 패리티 보호 필요 |
| 사진 편집 중 | NVMe Pool | 빠른 I/O 필요 |
| 4K 영상 원본 | Array | 대용량, 스트리밍은 문제없음 |
| Plex/Jellyfin 메타데이터 | NVMe Pool | 빠른 탐색 필요 |
| Docker appdata | NVMe Pool | 랜덤 I/O 많음 |
| VM 디스크 | NVMe Pool | 고성능 필요 |
| 백업 데이터 | Array | 장기 보관 |
| 다운로드 임시 | Cache Pool | 빠른 쓰기 후 Array 이동 |

### 캐시 동작 방식

Unraid의 캐시는 두 가지 모드로 작동합니다:

**Yes (Cache 사용):**
```
파일 쓰기 → Cache에 즉시 저장 → 야간 Mover가 Array로 이동
```
- 빠른 쓰기 성능
- 대부분의 공유 폴더 권장

**Prefer (Cache 우선):**
```
파일 쓰기 → Cache에 저장 → Array로 이동 안 함
```
- Docker appdata, VM 디스크 권장
- 항상 SSD에 유지

**Only (Cache 전용):**
```
파일 쓰기 → Cache에만 저장 → Array 사용 안 함
```
- 임시 파일, 고속 필요 데이터

**No (Cache 미사용):**
```
파일 쓰기 → Array에 직접 저장
```
- 느리지만 즉시 패리티 보호

---

## 초기 설치 및 어레이 구성

### 첫 부팅 및 웹 UI 접속

1. **USB 드라이브로 부팅**
   - USB 삽입 후 BIOS에서 부팅 순서 확인
   - Unraid 부팅 화면 표시

2. **IP 주소 확인**
   - 부팅 완료 후 화면에 IP 주소 표시
   - 또는 라우터에서 "Tower" 호스트 이름 확인

3. **웹 UI 접속**
   ```
   브라우저에서: http://tower.local
   또는: http://192.168.x.x
   ```

4. **초기 설정 마법사**
   - 시간대 설정: Asia/Seoul
   - 키보드 레이아웃: Korean
   - 네트워크 설정 확인

### 어레이 구성

#### 1단계: 디스크 할당 (싱글 패리티 선택 시)

**Main 탭에서:**
```
Parity:       3TB HDD #1 (가장 큰 드라이브)
Disk 1:       3TB HDD #2
Disk 2:       3TB HDD #3
Disk 3:       3TB HDD #4
Cache:        500GB SSD
```

#### 1단계: 디스크 할당 (듀얼 패리티 선택 시)

**Main 탭에서:**
```
Parity:       3TB HDD #1
Parity 2:     3TB HDD #2  (모든 라이선스에서 지원)
Disk 1:       3TB HDD #3
Disk 2:       3TB HDD #4
Cache:        500GB SSD
```

**중요 원칙:**
- Parity는 가장 큰 디스크여야 함
- 듀얼 패리티 시 두 패리티 디스크는 같은 크기 권장
- 디스크 순서는 성능에 영향 없음

#### 2단계: 파일시스템 선택

**권장 파일시스템:**
- **XFS:** 안정적, 빠름, 크기 조정 불가
- **BTRFS:** 스냅샷 지원, 크기 조정 가능, 약간 느림

**우리 구성 권장:**
```
Array Disks:  XFS (안정성 우선)
Cache Disk:   BTRFS (스냅샷 활용 가능)
```

#### 3단계: 어레이 시작 및 포맷

1. **Start Array 클릭**
2. **Format 체크박스 선택** (새 디스크인 경우)
3. **확인 후 Format 시작**
   - 주의: 모든 데이터가 삭제됩니다
   - 3TB × 4개 포맷: 약 40-80분 소요

4. **패리티 동기화 시작**
   - 자동으로 시작
   - 싱글 패리티: 3TB 패리티 약 6-12시간 소요
   - 듀얼 패리티: 3TB × 2 패리티 약 12-24시간 소요
   - 속도: 30-60MB/s (디스크 성능에 따라)

#### 4단계: 공유 폴더 생성

**Shares 탭에서:**

**사진 저장용:**
```
Share name: Photos
Use cache: Yes
Split level: Automatically split
```

**미디어 파일용:**
```
Share name: Media
Use cache: Yes
Included disks: All
Excluded disks: None
```

**백업용:**
```
Share name: Backups
Use cache: No (Array에 직접 저장)
```

**Docker appdata용:**
```
Share name: appdata
Use cache: Prefer (항상 캐시에)
```

**VM 디스크용:**
```
Share name: domains
Use cache: Prefer (항상 캐시에)
```

---

## GTX 1050 GPU 추가 구성

GTX 1050을 추가하면 미디어 트랜스코딩, AI 작업, VM GPU 패스스루 등 다양한 고급 기능을 활용할 수 있습니다.

### 하드웨어 설치

1. **물리적 설치**
   - PCIe x16 슬롯에 GTX 1050 장착
   - 추가 전원 커넥터 연결 (필요시)
   - 디스플레이 출력 확인 (선택사항)

2. **BIOS 설정 확인**
   ```
   Advanced → PCI Configuration
   - Primary Graphics Adapter: PCIe (또는 Auto)
   
   Advanced → CPU Configuration
   - VT-d: Enabled (VM 패스스루용)
   - IOMMU: Enabled
   ```

### Unraid에서 GPU 설정

#### Nvidia 드라이버 플러그인 설치

1. **Apps 탭 → Search: "Nvidia-Driver"**
2. **"Nvidia-Driver" by ich777 설치**
3. **Settings → Nvidia Driver:**
   ```
   Driver Version: Latest (자동 선택)
   Install: Yes
   ```
4. **재부팅 후 확인:**
   ```
   Tools → System Devices
   - GPU가 "vfio-pci" 또는 "nvidia"로 표시되어야 함
   ```

#### GPU 활용 시나리오

**1. Plex/Jellyfin 하드웨어 트랜스코딩**

Plex Docker 설정:
```
Docker 템플릿 편집:
- Add another Path, Port, Variable: Device
- Name: GPU
- Value: /dev/dri
- Add
```

Plex 설정 내:
```
Settings → Transcoder
- Use hardware acceleration: NVIDIA NVENC
- 동시 트랜스코딩: GTX 1050은 기본 2개 제한
```

**2. Nvidia 2-Stream 제한 해제**

```bash
# nvidia-patch 설치
cd /tmp
git clone https://github.com/keylase/nvidia-patch.git
cd nvidia-patch
bash ./patch.sh

# 재부팅 후 확인
nvidia-smi
```

이제 무제한 동시 트랜스코딩 가능!

**3. Jellyfin 하드웨어 가속**

Jellyfin Docker 설정:
```
Docker 템플릿:
- Extra Parameters: --runtime=nvidia
- Device: /dev/dri
```

Jellyfin 설정:
```
Dashboard → Playback → Hardware Acceleration
- NVENC
- NVDEC
```

**4. VM GPU 패스스루**

Windows/Linux VM에 GPU 전달:
```
VM 템플릿 편집:
- Graphics Card: None (또는 VNC)
- Add: PCI Device
- Select: NVIDIA GTX 1050
- Start VM
```

VM 내부에서 Nvidia 드라이버 설치 필요.

### GPU 성능 벤치마크

**GTX 1050 (2GB) 기대 성능:**
- H.264 1080p → 720p: 약 5-8개 동시 스트림
- H.265 4K → 1080p: 약 2-3개 동시 스트림
- AI 이미지 처리: 중간 수준 (PhotoPrism)
- 전력 소비: 약 75W (최대 부하 시)

---

## NVMe SSD 추가 및 다중 풀 전략

1TB NVMe SSD를 추가하면 고성능 워크로드를 위한 별도의 스토리지 풀을 구성할 수 있습니다.

### NVMe 물리적 설치

1. **M.2 슬롯 확인**
   - ASRock 메인보드의 M.2 슬롯 위치 확인
   - NVMe 프로토콜 지원 확인 (SATA M.2 아님)

2. **히트싱크**
   - 메인보드 기본 히트싱크 사용
   - 또는 서드파티 히트싱크 장착

3. **설치**
   - M.2 슬롯에 45도 각도로 삽입
   - 나사로 고정

### Unraid에서 NVMe 풀 구성

#### 별도 풀 생성

1. **Main 탭 → Pool Devices**
2. **Add Pool → Name: "nvme"**
3. **Slots: 1 (단일 드라이브)**
4. **Device 할당: 1TB NVMe**
5. **File System: BTRFS**
6. **Start Pool**

#### NVMe 풀 활용 전략

**고성능 워크로드 배치:**

```
nvme 풀 (1TB):
├── appdata/       # Docker 컨테이너 데이터
├── domains/       # VM 디스크 이미지
├── downloads/     # 임시 다운로드
└── databases/     # 데이터베이스 파일
```

**Share 설정:**
```
Share name: nvme_appdata
Primary storage: nvme pool
Secondary storage: None
Use cache: Only
```

### 다중 풀 성능 최적화

**I/O 스케줄러 조정:**
```bash
# NVMe용 (none 스케줄러)
echo none > /sys/block/nvme0n1/queue/scheduler

# HDD용 (mq-deadline 스케줄러)
echo mq-deadline > /sys/block/sda/queue/scheduler
```

**트림(TRIM) 활성화:**
```
Settings → Scheduler
- SSD TRIM: Daily at 02:00
```

---

## 보안 강화 전략

### 기본 보안 설정

1. **강력한 루트 비밀번호 설정**
   ```
   Settings → Users → root
   - Password: 16자 이상, 대소문자+숫자+특수문자
   ```

2. **사용자 계정 생성**
   ```
   Settings → Users → Add User
   - 일반 사용자 계정 생성
   - SMB 접근만 허용
   ```

3. **SSH 보안 강화**
   ```
   Settings → SSH
   - Use SSH Keys: Yes
   - Permit Root Login: No
   - Password Authentication: No
   ```

4. **방화벽 설정 (UFW)**
   ```bash
   # UFW 플러그인 설치 후
   ufw default deny incoming
   ufw default allow outgoing
   ufw allow 80/tcp    # Web UI
   ufw allow 443/tcp   # SSL
   ufw allow 445/tcp   # SMB
   ufw allow 22/tcp    # SSH
   ufw enable
   ```

### SSL/TLS 설정

#### Let's Encrypt 인증서 (무료)

1. **Let's Encrypt 플러그인 설치**
   ```
   Apps → Search: "Let's Encrypt"
   Install: Let's Encrypt
   ```

2. **설정**
   ```
   Domain: your-domain.com
   Email: your@email.com
   Only Subdomains: No
   Extra Domains: nas.your-domain.com
   ```

3. **자동 갱신 설정**
   ```
   Renewal: Every 60 days
   ```

#### 자체 서명 인증서 (내부 전용)

```bash
# 인증서 생성
openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
  -keyout /boot/config/ssl/certs/unraid_key.pem \
  -out /boot/config/ssl/certs/unraid_certificate.pem
```

### 네트워크 보안

**VLAN 분리:**
```
Settings → Network Settings
- Enable VLANs: Yes
- VLAN 10: Management (Unraid UI)
- VLAN 20: Storage (SMB/NFS)
- VLAN 30: Docker containers
- VLAN 40: VMs
```

**역방향 프록시 (Nginx Proxy Manager):**
```
Docker 설치: Nginx Proxy Manager
- 외부 접속 단일 진입점
- SSL 종료점
- 접근 제어
```

### 2단계 인증 (2FA)

1. **Google Authenticator 플러그인**
   ```
   Apps → Search: "Google Authenticator"
   Install
   ```

2. **사용자별 2FA 활성화**
   ```
   Settings → Users → [username] → 2FA
   ```

### 침입 탐지 (Fail2Ban)

```bash
# Fail2Ban 도커 컨테이너
docker run -d \
  --name=fail2ban \
  --net=host \
  --cap-add=NET_ADMIN \
  --cap-add=NET_RAW \
  -v /mnt/user/appdata/fail2ban:/config \
  -v /var/log:/var/log:ro \
  crazymax/fail2ban
```

설정 파일 (`/mnt/user/appdata/fail2ban/jail.local`):
```ini
[unraid-webui]
enabled = true
port = 80,443
filter = unraid-webui
logpath = /var/log/nginx/access.log
maxretry = 5
bantime = 3600
```

---

## Docker 컨테이너 환경 구축

### Docker 기본 설정

1. **Docker 활성화**
   ```
   Settings → Docker
   - Enable Docker: Yes
   - Docker vDisk location: /mnt/nvme/docker.img
   - Default appdata: /mnt/nvme/appdata
   - Docker vDisk size: 20GB (필요시 확장)
   ```

2. **Community Applications 설치**
   ```
   Apps → Install Community Applications
   ```

### 필수 Docker 컨테이너

#### 미디어 서버 스택

**Plex Media Server:**
```
Apps → Search: "plex"
- Port: 32400
- /config: /mnt/nvme/appdata/plex
- /media: /mnt/user/Media
- GPU: /dev/dri (하드웨어 트랜스코딩)
```

**또는 Jellyfin (오픈소스):**
```
Apps → Search: "jellyfin"
- Port: 8096
- /config: /mnt/nvme/appdata/jellyfin
- /media: /mnt/user/Media
```

#### 다운로드 자동화

**qBittorrent:**
```
Apps → Search: "qbittorrent"
- Port: 8080
- /config: /mnt/nvme/appdata/qbittorrent
- /downloads: /mnt/user/downloads
```

**Sonarr (TV 프로그램):**
```
Apps → Search: "sonarr"
- Port: 8989
- /config: /mnt/nvme/appdata/sonarr
- /tv: /mnt/user/Media/TV
```

**Radarr (영화):**
```
Apps → Search: "radarr"
- Port: 7878
- /config: /mnt/nvme/appdata/radarr
- /movies: /mnt/user/Media/Movies
```

**Prowlarr (인덱서 관리):**
```
Apps → Search: "prowlarr"
- Port: 9696
- /config: /mnt/nvme/appdata/prowlarr
```

#### 사진 관리

**Immich (Google Photos 대체):**
```
Apps → Search: "immich"
- Port: 2283
- /config: /mnt/nvme/appdata/immich
- /photos: /mnt/user/Photos
- PostgreSQL 데이터베이스 필요
```

기능:
- 자동 백업 (모바일 앱)
- AI 얼굴 인식
- 지도 기반 탐색
- 공유 앨범

#### 백업 솔루션

**Duplicati:**
```
Apps → Search: "duplicati"
- Port: 8200
- /config: /mnt/nvme/appdata/duplicati
- /source: /mnt/user
```

클라우드 백업 지원:
- Backblaze B2
- Google Drive
- OneDrive
- Amazon S3

#### 파일 동기화

**Nextcloud:**
```
Apps → Search: "nextcloud"
- Port: 443
- /config: /mnt/nvme/appdata/nextcloud
- /data: /mnt/user/nextcloud
- MariaDB 데이터베이스 필요
```

**Syncthing:**
```
Apps → Search: "syncthing"
- Port: 8384
- /config: /mnt/nvme/appdata/syncthing
- /sync: /mnt/user/Sync
```

### Docker 네트워크 최적화

**커스텀 브리지 네트워크:**
```bash
docker network create \
  --driver bridge \
  --subnet=172.20.0.0/16 \
  --gateway=172.20.0.1 \
  media_net
```

**Macvlan 네트워크 (물리적 IP):**
```bash
docker network create \
  --driver macvlan \
  --subnet=192.168.1.0/24 \
  --gateway=192.168.1.1 \
  --parent=eth0 \
  macvlan_net
```

### Docker 컨테이너 관리

**Portainer (웹 UI):**
```
Apps → Search: "portainer"
- Port: 9000
- /var/run/docker.sock:/var/run/docker.sock
```

**Watchtower (자동 업데이트):**
```
Apps → Search: "watchtower"
- Schedule: Daily at 03:00
- Cleanup: Yes
```

---

## VM(가상머신) 환경 구축

### VM 기본 설정

1. **VM Manager 활성화**
   ```
   Settings → VM Manager
   - Enable VMs: Yes
   - Default VM storage: /mnt/nvme/domains
   - Default ISO storage: /mnt/user/isos
   ```

2. **VirtIO 드라이버 다운로드**
   ```
   https://github.com/virtio-win/virtio-win-pkg-scripts
   - virtio-win.iso 다운로드
   - /mnt/user/isos/ 폴더에 저장
   ```

### Windows 11 VM 생성

#### VM 템플릿 설정

```
Name: Windows11
CPUs: 4
Memory: 8192MB (8GB)
Machine: Q35-7.2
BIOS: OVMF (UEFI)
Primary vDisk: 100GB (NVMe 풀)
Graphics: VNC
Sound: None (또는 AC97)
Network: virtio
```

#### Windows 11 설치

1. **ISO 준비**
   - Windows 11 ISO 다운로드
   - TPM 체크 우회 레지스트리 준비

2. **설치 과정**
   ```
   1. VM 시작 → VNC 연결
   2. Windows 설치 시작
   3. Shift + F10 → 명령 프롬프트
   4. TPM 우회:
      reg add HKLM\SYSTEM\Setup\LabConfig /v BypassTPMCheck /t REG_DWORD /d 1
      reg add HKLM\SYSTEM\Setup\LabConfig /v BypassSecureBootCheck /t REG_DWORD /d 1
   5. 설치 계속 진행
   ```

3. **VirtIO 드라이버 설치**
   - 장치 관리자 → 미확인 장치
   - VirtIO ISO에서 드라이버 설치

### Ubuntu Server VM

```
Name: Ubuntu-Server
CPUs: 2
Memory: 4096MB
Primary vDisk: 50GB
Graphics: VNC
Network: virtio
```

용도:
- 개발 환경
- Docker 호스트
- 테스트 서버

### GPU 패스스루 설정

1. **VFIO 바인딩**
   ```
   Tools → System Devices
   - GTX 1050 체크
   - Bind to VFIO
   ```

2. **VM에 GPU 할당**
   ```
   VM 편집:
   - Graphics: None
   - Add PCI Device: GTX 1050
   ```

3. **게스트 OS 드라이버**
   - Windows: Nvidia 드라이버 설치
   - Linux: nouveau 또는 nvidia 드라이버

### VM 성능 최적화

**CPU 피닝:**
```xml
<vcpupin vcpu='0' cpuset='2'/>
<vcpupin vcpu='1' cpuset='3'/>
<vcpupin vcpu='2' cpuset='4'/>
<vcpupin vcpu='3' cpuset='5'/>
```

**Huge Pages:**
```
Settings → VM Manager
- Enable Huge Pages: Yes
```

**디스크 캐시:**
```xml
<driver name='qemu' type='raw' cache='writeback'/>
```

---

## 백업 전략 수립

### 3-2-1 백업 원칙

- **3개** 복사본 (원본 + 백업 2개)
- **2개** 다른 미디어
- **1개** 오프사이트

### 구현 전략

#### 1차 백업: 외장 HDD

**하드웨어:**
- 12TB 외장 HDD (4개 HDD 전체 백업용)
- USB 3.0 연결

**Unassigned Devices 플러그인:**
```
Apps → Search: "unassigned devices"
- 자동 마운트
- 자동 백업 스크립트
```

**백업 스크립트:**
```bash
#!/bin/bash
# /mnt/user/scripts/backup_to_usb.sh

rsync -av --progress \
  /mnt/user/Photos \
  /mnt/user/Documents \
  /mnt/user/Backups \
  /mnt/disks/External_12TB/

# 완료 알림
/usr/local/emhttp/webGui/scripts/notify \
  -s "Backup Complete" \
  -d "USB backup finished successfully"
```

#### 2차 백업: 클라우드

**Backblaze B2 설정:**
```
Duplicati 설정:
- Destination: Backblaze B2
- Bucket: unraid-backup
- Schedule: Weekly
- Retention: 30 days
```

**예상 비용 (9TB 데이터):**
```
저장: $0.006/GB/월 × 9000GB = $54/월
다운로드: $0.01/GB (복원 시에만)
```

#### 백업 우선순위

| 우선순위 | 데이터 유형 | 백업 빈도 | 보관 기간 |
|---------|-----------|----------|----------|
| 1 | 가족 사진/동영상 | 일일 | 영구 |
| 2 | 중요 문서 | 일일 | 영구 |
| 3 | 프로젝트 파일 | 주간 | 1년 |
| 4 | 미디어 파일 | 월간 | 6개월 |
| 5 | 다운로드 | 백업 안 함 | - |

### 백업 검증

**월간 복원 테스트:**
```bash
# 테스트 복원
duplicati restore \
  --source=b2://bucket/path \
  --target=/mnt/user/test_restore \
  --sample-file

# 체크섬 검증
md5sum /mnt/user/original/file
md5sum /mnt/user/test_restore/file
```

### 스냅샷 백업 (BTRFS)

**BTRFS 풀에서:**
```bash
# 스냅샷 생성
btrfs subvolume snapshot -r \
  /mnt/cache/appdata \
  /mnt/cache/snapshots/appdata_$(date +%Y%m%d)

# 스냅샷 목록
btrfs subvolume list /mnt/cache

# 스냅샷 삭제 (30일 이상)
find /mnt/cache/snapshots -maxdepth 1 -mtime +30 \
  -exec btrfs subvolume delete {} \;
```

---

## 성능 최적화

### 디스크 성능 튜닝

**어레이 디스크 설정:**
```
Settings → Disk Settings
- Default spin down delay: 30분 (전력 절약)
- Force NCQ disabled: No
- Tunable (md_write_method): reconstruct write
```

**캐시 설정:**
```
Settings → Global Share Settings
- Minimum free space: 10GB
- Split level: Automatic
```

### 네트워크 최적화

**Jumbo Frames (9000 MTU):**
```
Settings → Network Settings
- MTU: 9000
- 스위치도 Jumbo Frames 지원 필요
```

**SMB 최적화:**
```
Settings → SMB
- Enhanced macOS interoperability: No
- Case-sensitive names: Auto
```

**SMB 추가 설정 (`/boot/config/smb-extra.conf`):**
```ini
[global]
min protocol = SMB2
max protocol = SMB3
socket options = IPTOS_LOWDELAY TCP_NODELAY
read raw = Yes
write raw = Yes
use sendfile = Yes
aio read size = 16384
aio write size = 16384
```

### RAM 디스크 활용

**임시 파일용 RAM 디스크:**
```bash
# 10GB RAM 디스크 생성
mkdir /mnt/ramdisk
mount -t tmpfs -o size=10G tmpfs /mnt/ramdisk
```

용도:
- 동영상 트랜스코딩 임시 파일
- 컴파일 캐시
- 데이터베이스 임시 테이블

### CPU 거버너 설정

**성능 모드:**
```bash
# 모든 코어를 performance 모드로
for cpu in /sys/devices/system/cpu/cpu*/cpufreq/scaling_governor; do
  echo performance > $cpu
done
```

**절전 모드 (유휴 시):**
```bash
# powersave 모드
for cpu in /sys/devices/system/cpu/cpu*/cpufreq/scaling_governor; do
  echo powersave > $cpu
done
```

### Docker 성능 최적화

**Docker 설정:**
```json
{
  "storage-driver": "btrfs",
  "log-driver": "json-file",
  "log-opts": {
    "max-size": "10m",
    "max-file": "3"
  },
  "default-ulimits": {
    "nofile": {
      "Hard": 64000,
      "Soft": 64000
    }
  }
}
```

---

## 모니터링 및 유지보수

### 시스템 모니터링

**Netdata (실시간 모니터링):**
```
Apps → Search: "netdata"
- Port: 19999
- 실시간 CPU, RAM, 디스크, 네트워크 모니터링
```

**Grafana + Prometheus:**
```
# Prometheus (메트릭 수집)
Apps → Search: "prometheus"

# Grafana (시각화)
Apps → Search: "grafana"
- Port: 3000
```

**Glances (간단한 모니터링):**
```
Apps → Search: "glances"
- Port: 61208
- 웹 기반 시스템 모니터
```

### 디스크 상태 모니터링

**S.M.A.R.T. 모니터링:**
```
Main 탭:
- 각 디스크 클릭 → SMART Report
```

**주의할 항목:**
- Reallocated Sectors Count (5)
- Current Pending Sector Count (197)
- Temperature (온도 > 50°C 주의)

### 패리티 체크

**자동 스케줄:**
```
Settings → Scheduler:
- Parity Check: Monthly, 1st day, 02:00
- Write corrections: Yes
```

**수동 실행:**
```
Main 탭:
- Parity Check → Start
```

- 싱글 패리티 (3TB): 6-12시간 소요
- 듀얼 패리티 (3TB × 2): 12-24시간 소요

### 로그 확인

```
Tools → System Log:
- 오류 메시지 확인
- 디스크 I/O 오류 주의
```

### 알림 설정

```
Settings → Notifications:
- Notification method: Email, Pushover, Discord 등
- Events to notify:
  - Parity check complete
  - Disk errors
  - Array stopped
  - High temperature
  - Low disk space
```

### 유지보수 체크리스트

**일일:**
- [ ] 대시보드 확인 (온도, 사용량)

**주간:**
- [ ] Docker 로그 확인
- [ ] 디스크 사용량 확인

**월간:**
- [ ] 패리티 체크 실행
- [ ] 외장 HDD 백업
- [ ] Unraid 업데이트 확인

**분기별:**
- [ ] S.M.A.R.T 리포트 검토
- [ ] 백업 복원 테스트
- [ ] 플러그인 업데이트

**연간:**
- [ ] 디스크 교체 계획 (3-5년 주기)
- [ ] 라이선스 갱신 (해당 시)

---

## 문제 해결 가이드

### Array 시작 안 됨

**증상:** "Start Array" 버튼이 작동하지 않음.

**해결:**
1. 모든 디스크가 인식되는지 확인
2. Parity 디스크가 Data 디스크보다 크거나 같은지 확인
3. 파일시스템 오류 확인:
   ```bash
   xfs_repair -n /dev/sdX
   ```

### 디스크 에러

**증상:** Main 탭에서 디스크가 빨간색 또는 X 표시.

**해결:**
1. **즉시 Array 중지**
2. SMART 리포트 확인
3. 디스크 케이블 재연결
4. 다른 SATA 포트 시도
5. 디스크 교체 고려 (Reallocated Sectors > 100)

### 패리티 체크 실패

**증상:** 패리티 체크 후 "sync errors" 표시.

**해결:**
1. 다시 패리티 체크 실행
2. 여전히 오류 시:
   ```
   Tools → New Config → Preserve current assignments
   Array 시작 → Parity Sync
   ```
3. 패리티 디스크 교체 고려

### Docker 컨테이너 시작 안 됨

**증상:** 컨테이너가 시작되지 않거나 즉시 종료됨.

**해결:**
1. 로그 확인:
   ```
   Docker 탭 → 컨테이너 → Logs
   ```
2. appdata 폴더 권한 확인:
   ```bash
   chmod -R 777 /mnt/nvme/appdata/container-name
   ```
3. 이미지 재다운로드:
   ```
   Docker 탭 → 컨테이너 삭제 → 재설치
   ```

### VM이 느림

**증상:** VM 성능이 매우 낮음.

**해결:**
1. VirtIO 드라이버 설치 확인 (Windows)
2. CPU Pinning 설정
3. vDisk를 NVMe 풀로 이동
4. CPU Mode를 "host-passthrough"로 변경

### 네트워크 속도 느림

**증상:** 파일 전송 속도 < 100MB/s.

**해결:**
1. 기가비트 이더넷 확인
2. Jumbo Frames 활성화 (스위치 지원 시)
3. Docker 네트워크를 Host로 변경
4. SMB 설정 최적화:
   ```
   Settings → SMB:
   - Enhanced macOS interoperability: No
   - Fruit: Yes
   ```

### USB 부팅 드라이브 손상

**증상:** 부팅 시 멈춤 또는 설정 초기화.

**해결:**
1. 백업에서 복원:
   ```
   USB에 config 폴더 복사
   ```
2. 새 USB 드라이브에 재설치
3. 라이선스 재등록 (무료, GUID 변경 시)

### 높은 온도

**증상:** CPU/HDD 온도 > 70°C.

**해결:**
1. 케이스 팬 추가
2. 스핀다운 시간 감소 (HDD)
3. CPU 쿨러 업그레이드
4. 방 온도 낮추기

---

## 고급 활용 시나리오

### 원격 접속 최적화

**Tailscale (WireGuard 기반, 더 쉬움):**
```
Apps → Search: "tailscale"
Install: Tailscale

웹사이트에서 등록 → 자동 VPN 네트워크 구성
```

**Cloudflare Tunnel (포트 포워딩 없이):**
```
Apps → Search: "cloudflared"
Install: Cloudflared

Cloudflare 대시보드에서 터널 생성 → 외부 접속 가능
```

### 미디어 서버 고도화

**Tautulli (Plex 통계):**
```
Apps → Search: "tautulli"
- Port: 8181
```

**Ombi (미디어 요청 시스템):**
```
Apps → Search: "ombi"
- Port: 3579
```

가족이 영화/TV 프로그램 요청 가능 → Sonarr/Radarr 자동 다운로드.

### 홈 오토메이션

**Home Assistant:**
```
Apps → Search: "homeassistant"
- Port: 8123
```

Unraid를 스마트홈 허브로 활용.

### 개발 환경

**Code-Server (웹 기반 VS Code):**
```
Apps → Search: "code-server"
- Port: 8443
```

브라우저에서 코딩 가능.

**GitLab (자체 Git 서버):**
```
Apps → Search: "gitlab"
- Port: 8929
```

### 게임 서버 호스팅

**Minecraft:**
```
Apps → Search: "minecraft"
- Port: 25565
- RAM: 4GB
```

**Valheim, Terraria, 기타 게임 서버:**
Community Applications에 다양한 게임 서버 템플릿 있음.

---

## 비용 분석 및 확장 로드맵

### 초기 구축 비용 (2025년 기준)

| 항목 | 사양 | 가격 (KRW) |
|-----|------|-----------|
| CPU | Intel Celeron N5105 | 150,000 |
| 메인보드 | ASRock N100M | 100,000 |
| RAM | 32GB x 2 (64GB) | 150,000 |
| **HDD** | **3TB x 4 (WD Red)** | **600,000** |
| SSD | 500GB SATA | 60,000 |
| NVMe | 1TB M.2 | 80,000 |
| GPU | GTX 1050 2GB (중고) | 80,000 |
| 케이스 | Fractal Node 804 | 150,000 |
| PSU | 450W 80+ Bronze | 60,000 |
| USB | 부팅 드라이브 16GB | 10,000 |
| **Unraid** | **Starter 라이선스** | **60,000** |
| | *Lifetime 라이선스 (선택)* | *300,000* |
| **총계** | **Starter 라이선스** | **1,500,000** |
| | **Lifetime 라이선스** | **1,740,000** |

### 월간 운영 비용

**전력 소비:**
- 유휴 시: 45W (HDD 4개)
- 일반 사용: 65W
- 최대 부하: 130W

**월 전기료 (평균 65W):**
```
65W × 24h × 30일 = 46.8 kWh
46.8 kWh × 250원/kWh = 11,700원
```

**기타 비용:**
- 클라우드 백업 (Backblaze B2): 
  - 싱글 패리티 (9TB): 54,000원/월
  - 듀얼 패리티 (6TB): 36,000원/월
- Plex Pass: 없음 (무료) 또는 월 6,000원 (선택)
- **Starter/Unleashed 연장 비용**: 연 $36 (약 45,000원/년 = 3,750원/월)

**총 월 비용:** 
- 기본: 약 12,000원 (전기료만)
- 전체 백업 포함: 약 48,000-66,000원

### 확장 로드맵

#### 6개월 후

**추가 스토리지:**
- 3TB → 6TB HDD 교체 (1개씩)
- 싱글 패리티: 총 용량 12TB → 18TB
- 듀얼 패리티: 총 용량 6TB → 12TB

**예상 비용:** 200,000원 (6TB HDD x 1)

#### 1년 후

**NVMe Pool 확장:**
- 1TB NVMe → 2TB NVMe
- BTRFS RAID1 구성 (2개)

**예상 비용:** 200,000원 (2TB NVMe x 2)

#### 2년 후

**10GbE 네트워크:**
- 10GbE NIC 추가
- 10GbE 스위치

**예상 비용:** 300,000원

#### 3년 후

**디스크 전체 교체:**
- 3TB → 8TB (패리티 수명)
- 싱글 패리티: 24TB 가용
- 듀얼 패리티: 16TB 가용

**예상 비용:** 1,200,000원

### ROI (투자 대비 효과)

**대체 서비스 비용 (월간):**
- Google One 2TB: 11,900원
- iCloud+ 2TB: 11,900원
- Plex Pass: 6,000원
- Netflix 4K: 17,000원
- 클라우드 VM (Linode 4GB): 30,000원

**총 대체 비용:** 약 76,800원/월 = 921,600원/년

**Unraid 시스템 회수 기간:**
- Starter 라이선스: 1,500,000원 / 921,600원 = **약 19.5개월**
- Lifetime 라이선스: 1,740,000원 / 921,600원 = **약 23개월**

2년 후부터는 순수익!

---

## 최종 시스템 요약

### 달성한 기능

**스토리지 (싱글 패리티):**
- ✅ 9TB 보호된 스토리지 (패리티 1개)
- ✅ 500GB 빠른 캐시 (SATA SSD)
- ✅ 1TB 초고속 작업 공간 (NVMe)
- ✅ 총 10.5TB 활용 가능
- ✅ 1개 디스크 실패 복구 가능

**스토리지 (듀얼 패리티):**
- ✅ 6TB 강력하게 보호된 스토리지 (패리티 2개)
- ✅ 500GB 빠른 캐시 (SATA SSD)
- ✅ 1TB 초고속 작업 공간 (NVMe)
- ✅ 총 7.5TB 활용 가능
- ✅ 2개 디스크 동시 실패 복구 가능

**미디어:**
- ✅ Plex/Jellyfin 미디어 서버
- ✅ GTX 1050 하드웨어 트랜스코딩 (5-8개 동시 스트림)
- ✅ 4K 스트리밍 지원
- ✅ 모바일 앱 지원

**사진 관리:**
- ✅ Immich (Google Photos 대체)
- ✅ AI 얼굴 인식
- ✅ 자동 백업

**백업:**
- ✅ 3-2-1 백업 전략
- ✅ 클라우드 백업 (Backblaze B2)
- ✅ 오프라인 백업 (외장 HDD)

**보안:**
- ✅ SSL/TLS 암호화
- ✅ WireGuard VPN
- ✅ 2FA 인증
- ✅ 방화벽 (UFW)
- ✅ Fail2Ban

**성능:**
- ✅ 64GB RAM (VM/Docker 호스팅)
- ✅ NVMe 고속 작업
- ✅ GPU 가속
- ✅ 전력 효율: 45-80W

**확장성:**
- ✅ 50+ Docker 컨테이너 가능
- ✅ 다중 VM 호스팅
- ✅ 추가 디스크 확장 가능

### 구성 선택 가이드

**싱글 패리티 (9TB) 추천:**
- 미디어 서버 중심 사용
- 외부 백업 시스템 보유
- 최대 저장 공간 필요
- 일반적인 가정 사용

**듀얼 패리티 (6TB) 추천:**
- 중요 데이터 보관 (가족 사진, 문서)
- 백업 시스템 미비
- 최고 수준 안정성 요구
- 비즈니스 데이터 보관

> **팁:** 두 구성 모두 동일한 라이선스로 사용 가능하므로, 언제든지 싱글↔듀얼 패리티 전환이 가능합니다. 다만 전환 시 패리티 재구축에 시간이 소요됩니다.

### 다음 단계 제안

1. **첫 주:**
   - Unraid 설치 및 Array 구성
   - 패리티 방식 결정 (싱글/듀얼)
   - 기본 공유 폴더 생성
   - Plex/Jellyfin 설치

2. **첫 달:**
   - Docker 컨테이너 10개 설치
   - VPN 설정 및 테스트
   - 백업 자동화

3. **3개월:**
   - VM 환경 구축
   - 모니터링 시스템 완성
   - 가족 온보딩

4. **6개월:**
   - 스토리지 확장 고려
   - 성능 최적화 미세 조정

5. **1년:**
   - 시스템 안정화
   - 추가 기능 탐색
   - 커뮤니티 참여

---

## 결론

Intel 저전력 CPU, 64GB RAM, GTX 1050, NVMe SSD, 그리고 **3TB HDD 4개**의 조합으로 엔터프라이즈급 기능을 가정에서 구현할 수 있습니다.

**핵심 달성 사항:**
- ✅ 9TB (싱글) 또는 6TB (듀얼) 보호된 스토리지
- ✅ 1.5TB 고속 캐시
- ✅ 5-8개 동시 미디어 트랜스코딩
- ✅ 50+ Docker 컨테이너 운영
- ✅ 다중 VM 호스팅
- ✅ 월 전기료 12,000원 이하
- ✅ 엔터프라이즈급 보안
- ✅ 자동화된 백업 시스템
- ✅ **모든 라이선스에서 듀얼 패리티 지원**

**4개 HDD 구성의 장점:**
- 싱글/듀얼 패리티 선택 가능 (동일 라이선스)
- 더 높은 데이터 안정성 옵션
- 향상된 읽기 성능 (4개 디스크 병렬)
- 유연한 확장 경로
- 필요에 따른 패리티 레벨 조정 가능

이 시스템은 **확장성과 유연성**을 갖추고 있어, 향후 요구사항 변화에 따라 쉽게 업그레이드할 수 있습니다. 가장 중요한 것은 **데이터의 안전성**과 **접근성**을 동시에 보장한다는 점입니다.

**"Your data, your rules, your server"** - 이것이 Unraid의 철학이며, 이제 여러분의 현실이 되었습니다.

---

## 부록: 유용한 리소스

### 공식 문서
- [Unraid 공식 문서](https://docs.unraid.net)
- [Unraid 포럼](https://forums.unraid.net)
- [Unraid 위키](https://wiki.unraid.net)

### 커뮤니티 리소스
- [SpaceInvaderOne YouTube](https://www.youtube.com/channel/UCZDfnUn74N0WeAPvMqTOrtA)
- [Unraid Reddit](https://www.reddit.com/r/unraid)
- [TRaSH Guides](https://trash-guides.info)

### 추천 플러그인
1. **Community Applications** - 앱 스토어
2. **CA Fix Common Problems** - 문제 자동 감지
3. **CA Appdata Backup** - Docker 백업
4. **Tips and Tweaks** - 성능 최적화
5. **Dynamix System Temp** - 온도 모니터링
6. **User Scripts** - 자동화 스크립트
7. **Nvidia Driver** - GPU 지원
8. **Unassigned Devices** - 외부 드라이브 관리

### 추천 Docker 컨테이너
**미디어:**
- Plex/Jellyfin - 미디어 서버
- Sonarr/Radarr - 미디어 관리
- Prowlarr - 인덱서 관리
- qBittorrent - 토렌트

**생산성:**
- Nextcloud - 클라우드 스토리지
- Vaultwarden - 비밀번호 관리자
- Nginx Proxy Manager - 리버스 프록시
- Portainer - Docker 관리

**모니터링:**
- Grafana - 대시보드
- Prometheus - 메트릭 수집
- InfluxDB - 시계열 DB
- Glances - 시스템 모니터

---

*마지막 업데이트: 2025년 1월*
*작성자: Unraid 커뮤니티*
*버전: 3.0-4HDD (GTX 1050 + NVMe + 4×3TB HDD + 최신 라이선스 정보)*
