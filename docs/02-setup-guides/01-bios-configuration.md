# ⚙️ BIOS 구성 가이드

Unraid 최적 성능을 위한 BIOS/UEFI 설정 상세 가이드

---

## 📋 사전 확인 사항

### BIOS 접근 방법
| 제조사 | 키 | 참고 |
|-------|-----|------|
| ASUS | Del, F2 | UEFI BIOS |
| MSI | Del | Click BIOS |
| Gigabyte | Del, F2 | UEFI DualBIOS |
| ASRock | F2, Del | UEFI Setup |
| Intel NUC | F2 | Visual BIOS |

### BIOS 버전 확인
```bash
# Linux에서 확인
dmidecode -t bios

# Windows에서 확인
wmic bios get smbiosbiosversion
```

## 🔧 필수 설정

### 1. 부팅 설정 (Boot Configuration)

#### 부트 모드
```
Advanced → Boot → Boot Mode Select
├─ [X] UEFI Only (권장)
└─ [ ] Legacy Only
```

**이유**: UEFI는 더 빠른 부팅, GPT 지원, 보안 부팅 옵션 제공

#### 부트 순서
```
Boot Priority
1. USB Drive (Unraid USB)
2. Disabled/None
3. Disabled/None
```

**중요**: Unraid USB만 부팅 장치로 설정

#### Fast Boot
```
Boot → Fast Boot → [Disabled]
```

**이유**: 하드웨어 초기화 확실히 수행

#### CSM (Compatibility Support Module)
```
Boot → CSM → [Disabled]
```

**이유**: 순수 UEFI 환경 사용

### 2. 스토리지 설정

#### SATA 모드
```
Advanced → Storage Configuration
├─ SATA Mode → [AHCI] ⚠️ 필수
├─ Hot Plug → [Enabled]
└─ SMART → [Enabled]
```

**절대 RAID 모드 사용 금지!** Unraid는 AHCI 모드 필요

#### SATA 포트 설정
```
SATA Port 0-5 → [Enabled]
SATA Speed → [Auto] 또는 [6.0 Gbps]
```

#### NVMe 설정
```
Advanced → NVMe Configuration
├─ NVMe → [Enabled]
└─ M.2_1 Mode → [Auto]
```

### 3. CPU 설정

#### Intel CPU 설정
```
Advanced → CPU Configuration
├─ Intel SpeedStep → [Enabled] (전력 절약)
├─ Intel Turbo Boost → [Enabled]
├─ C-States → [Enabled]
│   ├─ C1E → [Enabled]
│   ├─ C3 → [Enabled]
│   ├─ C6/C7 → [Enabled]
│   └─ Package C-State → [C6]
├─ Hyper-Threading → [Enabled]
└─ Execute Disable Bit → [Enabled]
```

#### AMD CPU 설정
```
Advanced → CPU Configuration
├─ Core Performance Boost → [Enabled]
├─ SMT Mode → [Enabled] (Simultaneous Multi-Threading)
├─ Cool'n'Quiet → [Enabled]
├─ C-States → [Enabled]
└─ IOMMU → [Enabled] (가상화용)
```

#### 전력 관리
```
Advanced → Power Management
├─ Power Technology → [Energy Efficient]
├─ Energy Performance → [Balanced Performance]
└─ Power Limit (PL1/PL2) → [Auto]
```

### 4. 메모리 설정

#### 기본 설정
```
Advanced → Memory Configuration
├─ Memory Frequency → [Auto] 또는 [JEDEC]
├─ Memory Timing → [Auto]
└─ Memory Voltage → [Auto]
```

#### XMP/DOCP (선택사항)
```
Extreme Memory Profile
├─ XMP → [Profile 1] (Intel)
└─ DOCP → [Profile 1] (AMD)
```

**주의**: 안정성 우선시 Auto 사용, 성능 원하면 XMP/DOCP

#### ECC 메모리 (지원하는 경우)
```
Memory → ECC
├─ ECC Support → [Enabled]
└─ ECC Event Logging → [Enabled]
```

### 5. 가상화 설정 (VM 사용 시)

#### Intel VT 설정
```
Advanced → CPU Configuration
├─ Intel Virtualization Technology → [Enabled]
├─ VT-d → [Enabled]
└─ SR-IOV → [Enabled] (지원 시)
```

#### AMD-V 설정
```
Advanced → CPU Configuration
├─ SVM Mode → [Enabled]
├─ IOMMU → [Enabled]
└─ SR-IOV → [Enabled] (지원 시)
```

### 6. PCIe 설정

#### PCIe 슬롯 구성
```
Advanced → PCIe Configuration
├─ PCIe Slot 1 → [Gen3 x16] 또는 [Auto]
├─ PCIe Slot 2 → [Gen3 x4] 또는 [Auto]
└─ Above 4G Decoding → [Enabled] (대용량 GPU)
```

#### ASPM (Active State Power Management)
```
PCIe → ASPM
├─ ASPM → [Disabled] (안정성)
└─ 또는 → [L0s/L1] (전력 절약)
```

### 7. USB 설정

#### USB 구성
```
Advanced → USB Configuration
├─ USB Controller → [Enabled]
├─ Legacy USB Support → [Enabled]
├─ xHCI Hand-off → [Enabled]
├─ EHCI Hand-off → [Enabled]
└─ USB 3.0 Support → [Enabled]
```

#### USB 전원 관리
```
USB Power
├─ USB Power in S5 → [Disabled]
└─ USB Selective Suspend → [Disabled]
```

### 8. 네트워크 설정

#### 온보드 LAN
```
Advanced → Onboard Devices
├─ Onboard LAN → [Enabled]
├─ LAN Option ROM → [Disabled]
└─ Wake on LAN → [Disabled] (보안)
```

### 9. 보안 설정

#### 기본 보안
```
Security Tab
├─ Administrator Password → [설정]
├─ User Password → [미설정]
└─ Secure Boot → [Disabled] ⚠️ 필수
└─ TPM → [Disabled] (Unraid 미지원)
```

## 🎯 용도별 최적화

### A. 저전력 NAS (24/7 운영)

```
중점: 전력 효율
├─ CPU C-States → [모두 Enabled]
├─ Package C-State → [C6 이상]
├─ ASPM → [L0s/L1]
├─ CPU 주파수 → [Balanced]
└─ 팬 설정 → [Silent/Quiet]
```

### B. 고성능 미디어 서버

```
중점: 트랜스코딩 성능
├─ Turbo Boost → [Enabled]
├─ C-States → [Disabled]
├─ Memory → [XMP Enabled]
├─ PCIe → [Gen3/Gen4]
└─ GPU → [최대 성능]
```

### C. 가상화 호스트

```
중점: VM 성능
├─ VT-x/AMD-V → [Enabled]
├─ VT-d/IOMMU → [Enabled]
├─ SR-IOV → [Enabled]
├─ Memory → [최대 용량]
└─ NUMA → [Enabled]
```

## ⚠️ 일반적인 문제 해결

### 부팅 안 됨
```
확인 사항:
1. Boot Mode → UEFI
2. CSM → Disabled
3. Secure Boot → Disabled
4. USB Boot → Enabled
```

### 디스크 인식 안 됨
```
확인 사항:
1. SATA Mode → AHCI (NOT RAID!)
2. SATA Ports → Enabled
3. Hot Plug → Enabled
4. 케이블 연결 확인
```

### 성능 문제
```
확인 사항:
1. C-States 설정
2. Turbo Boost 활성화
3. Memory 속도
4. PCIe 링크 속도
```

### VM 문제
```
확인 사항:
1. VT-x/AMD-V → Enabled
2. VT-d/IOMMU → Enabled
3. 메모리 할당 충분
4. CPU 할당 적절
```

## 📊 BIOS 설정 체크리스트

### 필수 설정 (반드시 확인)
- [ ] SATA Mode: **AHCI**
- [ ] Secure Boot: **Disabled**
- [ ] Boot Mode: **UEFI**
- [ ] USB Boot: **Enabled**
- [ ] SMART: **Enabled**

### 권장 설정
- [ ] C-States: Enabled (전력 절약)
- [ ] Turbo Boost: Enabled
- [ ] VT-x/AMD-V: Enabled (VM용)
- [ ] VT-d/IOMMU: Enabled (PCIe 패스스루)
- [ ] XMP/DOCP: 안정성 테스트 후 적용

### 선택 설정
- [ ] Wake on LAN: 필요시만
- [ ] RGB LED: 개인 취향
- [ ] Fan Curves: 소음/냉각 균형

## 💾 설정 저장 및 백업

### 설정 저장
```
Exit Tab
├─ Save Changes and Exit → [Yes]
└─ 또는 F10 → Save and Exit
```

### 설정 백업
```
1. Save User Profile
   └─ 프로필 이름 입력 (예: Unraid_Optimized)
2. USB에 프로필 저장 (지원하는 경우)
3. 사진 촬영 (중요 설정 페이지)
```

### 설정 복원
```
1. Load User Profile
2. 또는 Load Optimized Defaults → 재설정
```

## 🔍 BIOS 업데이트

### 업데이트 전 확인
- [ ] 현재 버전 기록
- [ ] 설정 백업
- [ ] UPS 연결 (정전 대비)
- [ ] 안정적인 USB 사용

### 업데이트 방법
```
1. 제조사 웹사이트에서 최신 BIOS 다운로드
2. USB에 복사
3. BIOS → Tools → Flash Utility
4. 파일 선택 및 업데이트
5. 완료 후 설정 재적용
```

## 🎓 제조사별 특이사항

### ASUS
- AI Overclock: Auto
- Q-Fan Control: Standard
- Armory Crate: Disabled

### MSI
- Game Boost: Disabled (안정성)
- A-XMP: Profile 1
- MSI Fast Boot: Disabled

### Gigabyte
- Smart Fan 5: Balanced
- Q-Flash Plus: 백업용
- APP Center: 불필요

### ASRock
- XFast RAM: Disabled
- XFast LAN: Disabled
- UEFI Tech Service: Disabled

## ✅ 최종 점검

부팅 전 마지막 확인:
1. **SATA AHCI 모드** - 가장 중요!
2. **Secure Boot Disabled**
3. **Boot Priority USB**
4. **설정 저장됨**
5. **케이블 연결 확인**

## 🚀 다음 단계

BIOS 설정 완료 후:

1. **[USB 부팅 드라이브 생성](02-usb-boot-drive.md)**
2. **[초기 설치](03-initial-installation.md)**
3. **[어레이 구성](04-array-configuration.md)**

---

💡 **팁**: BIOS 설정은 한 번만 제대로 하면 됩니다. 스크린샷을 찍어두면 나중에 참고하기 좋습니다.

⚠️ **주의**: BIOS 설정 변경 후 부팅 문제가 생기면, "Load Optimized Defaults"로 초기화 후 다시 설정하세요.