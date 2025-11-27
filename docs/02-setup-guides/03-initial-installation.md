# Unraid NAS 설치 가이드

## 1단계: USB 부팅 드라이브 생성

### 1.1 준비물
- [x] USB 드라이브 (4-32GB)
- [x] Unraid USB Creator
- [x] Windows/Mac/Linux PC

### 1.2 USB 생성 과정
```bash
1. https://unraid.net/download 접속
2. USB Creator 다운로드
3. 관리자 권한으로 실행
4. 설정:
   - Version: Stable
   - USB Drive: 선택
   - Download: Latest
5. Write 클릭
```

### 1.3 생성 확인
- [x] config 폴더 생성 확인
- [x] GUID 할당 확인
- [x] 트라이얼 키 자동 생성

## 2단계: 초기 부팅

### 2.1 부팅 준비
- [x] USB 드라이브 삽입
- [x] BIOS 부팅 순서 확인
- [x] 네트워크 케이블 연결

### 2.2 첫 부팅
- [x] Unraid 부팅 화면 확인
- [x] IP 주소 메모: 192.168.0.100
- [x] 브라우저 접속: http://192.168.0.100

## 3단계: 초기 설정

### 3.1 기본 설정

> 💻 **설정 위치**: Unraid WebUI → Settings 탭 (http://192.168.0.100)
>
> ⏰ **소요 시간**: 약 5분

Unraid OS 부팅 후 웹 브라우저에서 접속하여 기본 설정을 진행합니다.

#### 시간대 설정 (Timezone)

**경로**: Settings → Date and Time

```
1. Settings 탭 클릭
2. Date and Time 메뉴 선택
3. Time zone 드롭다운에서 "Asia/Seoul" 선택
4. Apply 버튼 클릭
```

**왜 중요한가?**
- 로그 파일의 정확한 타임스탬프
- Docker 컨테이너 시간 동기화
- 스케줄된 작업 (패리티 체크, Mover) 정확한 실행
- 백업 작업의 정확한 시간 기록

**설정 결과 확인**:
```bash
# Dashboard 상단에 현재 시간 표시 확인
# 또는 Tools → System Log에서 시간 확인
```

- [x] 시간대: Asia/Seoul 설정 완료

---

#### 키보드 레이아웃 (Keyboard Layout)

**경로**: Settings → User Preferences → Console Settings

```
1. Settings 탭 클릭
2. User Preferences 메뉴 선택
3. Console Settings 선택
4. Keyboard Layout 드롭다운에서 원하는 레이아웃 선택
   - 기본값: us (United States)
   - 다른 언어: de (German), fr (French), es (Spanish) 등
5. Apply 버튼 클릭
```

**⚠️ 한국어 키보드 제한사항**:
- Unraid 7.2 현재 **한글(Korean) 키보드 레이아웃은 기본 제공되지 않음**
- 한글 입력은 IME(Input Method Editor) 필요 (콘솔에서 지원 안 됨)
- 물리 콘솔에서는 US 키보드 레이아웃 사용 권장
- SSH 접속 시 클라이언트(터미널 앱)에서 한글 입력 가능

**왜 설정하는가?**
- 물리적 연결된 콘솔에서 특수문자 입력 시
- VM 콘솔 접근 시 키보드 매핑
- 시스템 복구 작업 시 (영문 입력만 필요)

**참고**:
- Unraid 7.2부터 Console Settings에서 설정
- 콘솔 작업은 대부분 명령어(영문)만 사용
- 웹 UI는 영어로만 제공됨
- 한글이 필요한 작업(파일명 등)은 SSH 클라이언트 사용 권장

**대안 (한글이 필요한 경우)**:
```bash
# SSH 클라이언트 사용 (권장)
# Windows: PuTTY, MobaXterm, Windows Terminal
# macOS: 기본 터미널, iTerm2
# Linux: 기본 터미널

# SSH 접속 후 클라이언트에서 한글 입력 가능
ssh root@192.168.0.100
```

- [x] 키보드: 설정 확인 (US 기본값 유지)

---

#### 호스트명 설정 (Server Name)

**경로**: Settings → Identification

```
1. Settings 탭 클릭
2. Identification 메뉴 선택
3. Server name: 원하는 이름 입력
   - 기본값: Tower
   - 추천: unraid-nas, homeserver, mediaserver 등
4. Server description: 서버 설명 (선택사항)
   - 예: "Home Media NAS Server"
5. Apply 버튼 클릭
```

**호스트명 명명 규칙**:
```yaml
허용:
  - 영문 소문자 (a-z)
  - 숫자 (0-9)
  - 하이픈 (-)
  - 최대 63자

불허:
  - 한글 또는 특수문자
  - 공백
  - 첫 글자나 마지막 글자에 하이픈
```

**왜 중요한가?**
- 네트워크에서 서버 식별: `\\tower` (Windows) 또는 `smb://tower` (macOS)
- 알림 메시지에 서버 이름 표시
- 여러 Unraid 서버 운영 시 구분

**설정 예시**:
```
Server name: tower
Server description: Intel i3-14100T Unraid NAS (6TB Protected)
```

**설정 후 접속 방법**:
```bash
# 설정 전
http://192.168.0.100

# 설정 후 (호스트명으로 접속 가능)
http://tower
http://tower.local
\\tower (Windows 파일 탐색기)
smb://tower (macOS Finder)
```

- [x] 호스트명: Tower (또는 원하는 이름) 설정 완료

---

#### 추가 권장 설정 (선택사항)

**1. 네트워크 설정 확인**
- Settings → Network Settings
- IPv4 고정 IP 확인: 192.168.0.100
- Enable bonding: No (NIC 1개만 사용)

**2. 알림 설정**
- Settings → Notifications
- Email 또는 Discord/Slack 웹훅 설정 (나중에 가능)

**3. 시스템 정보 확인**
- Tools → System Info
- CPU, RAM, 디스크 감지 확인

---

#### 검증 체크리스트

설정 완료 후 다음 사항을 확인하세요:

- [x] Dashboard에 현재 시간이 한국 시간으로 표시됨
- [x] 웹 터미널(Tools → Terminal)에서 한글 입력 가능
- [x] `http://tower` 또는 `http://tower.local`로 접속 가능
- [x] Settings → Identification에서 서버 이름 확인

---

#### 문제 해결

**시간이 맞지 않는 경우**:
```bash
# Tools → Terminal 또는 SSH 접속
date
# 출력: Thu Jan 16 10:30:00 KST 2025 (KST 확인)

# 시간이 틀린 경우
ntpdate pool.ntp.org
```

**호스트명으로 접속 안 되는 경우**:

> 💡 **원인**: Unraid는 mDNS(Avahi)를 사용하여 `tower.local` 호스트명을 로컬 네트워크에 브로드캐스트합니다.
> 호스트명 변경 후에는 mDNS 캐시 문제나 Avahi 서비스 재시작이 필요할 수 있습니다.

**1단계: Unraid 서버에서 Avahi 서비스 재시작**

```bash
# Unraid 콘솔 또는 SSH 접속
/etc/rc.d/rc.avahidaemon restart

# 서비스 상태 확인
/etc/rc.d/rc.avahidaemon status

# 또는 서버 재부팅 (간단한 방법)
# WebUI → Tools → Reboot
```

**2단계: 클라이언트 PC에서 DNS 캐시 초기화**

```bash
# Windows (관리자 권한 CMD/PowerShell)
ipconfig /flushdns
# 또는 네트워크 어댑터 재시작
ipconfig /release
ipconfig /renew

# macOS
sudo dscacheutil -flushcache
sudo killall -HUP mDNSResponder

# Linux
sudo systemd-resolve --flush-caches
# 또는
sudo service avahi-daemon restart
```

**3단계: 브라우저 캐시 초기화**

```
- Chrome/Edge: Ctrl+Shift+Delete → 캐시 삭제
- Firefox: Ctrl+Shift+Delete → 캐시 삭제
- Safari: Command+Option+E
```

**4단계: 호스트명 형식 확인**

```bash
# 다양한 형식으로 시도
http://tower              # 짧은 형식 (Windows에서 주로 작동)
http://tower.local        # mDNS 형식 (Mac/Linux에서 주로 작동)
http://192.168.0.100      # IP 주소 (항상 작동)
```

**5단계: mDNS 지원 확인**

| OS | 기본 지원 | 추가 소프트웨어 필요 |
|----|---------|---------------------|
| **macOS** | ✅ 내장 (Bonjour) | 없음 |
| **Linux** | ✅ 대부분 내장 (Avahi) | `avahi-daemon` 설치 확인 |
| **Windows 10+** | ⚠️ 부분 지원 | **Bonjour Print Services** 설치 권장 |

**Windows에서 Bonjour 설치** (권장):
```
1. Apple Bonjour Print Services 다운로드
   https://support.apple.com/kb/DL999

2. 설치 후 서비스 확인:
   - Win+R → services.msc
   - "Bonjour Service" 실행 중인지 확인

3. 방화벽 예외 추가 (필요시):
   - 포트 5353 UDP 허용 (mDNS)
```

**6단계: 네트워크 문제 진단**

```bash
# Windows에서 mDNS 쿼리 테스트 (PowerShell)
Resolve-DnsName -Name tower.local -Type A

# Mac/Linux에서
ping tower.local
avahi-browse -a -t  # Avahi 서비스 목록 확인
dns-sd -B _http._tcp  # mDNS 서비스 탐색

# Unraid 서버에서 자신의 mDNS 확인
avahi-browse -a -t
```

**문제 해결 체크리스트**:

- [ ] Unraid에서 Avahi 서비스 재시작
- [ ] 클라이언트 PC에서 DNS 캐시 플러시
- [ ] 방화벽에서 포트 5353 UDP 허용 확인
- [ ] Windows인 경우 Bonjour 설치
- [ ] 같은 서브넷에 있는지 확인 (192.168.0.x/24)
- [ ] 브라우저가 검색 엔진으로 리다이렉트하지 않는지 확인

**여전히 안 되는 경우**:

```bash
# 임시 해결: IP 주소로 접속
http://192.168.0.100

# 영구 해결: hosts 파일 편집 (권장하지 않음)
# Windows: C:\Windows\System32\drivers\etc\hosts
# Mac/Linux: /etc/hosts
192.168.0.100  tower tower.local
```

**⚠️ 알려진 제한사항**:
- mDNS는 **로컬 네트워크에서만** 작동 (VPN/WireGuard 사용 시 IP 필요)
- 서브넷이 다르면 mDNS 작동 안 함 (VLAN 환경)
- 일부 라우터는 mDNS 패킷 차단 (설정 확인 필요)

### 3.2 감지된 디바이스 확인

Unraid OS 부팅 후 확인된 스토리지 디바이스:

```
Dev 1: HDD 3TB (sdd) - TOSHIBA DT01ACA300 [S/N: 45ATVRPGS]
Dev 2: HDD 3TB (sde) - TOSHIBA DT01ACA300 [S/N: 45AU0V4GS]
Dev 3: SSD 128GB (sdb) - Samsung 830 Series
Dev 4: HDD 3TB (sdc) - TOSHIBA DT01ACA300 [S/N: 45BSKX7GS]
Dev 5: NVMe 1TB (nvme0n1) - XPG GAMMIX S11 Pro
```

**HDD 시리얼 번호 기록** (향후 디스크 교체 또는 문제 해결 시 참조):
- Dev 1 (sdd): 45ATVRPGS
- Dev 2 (sde): 45AU0V4GS
- Dev 4 (sdc): 45BSKX7GS

### 3.3 어레이 구성 전략 결정

> 📘 **상세 가이드 필수**: 디스크 할당 전에 먼저 **[어레이 구성 가이드](04-array-configuration.md)**를 읽고 전략을 결정하세요.
>
> 어레이 구성 가이드에서는:
> - 패리티 보호 vs 최대 용량 비교
> - 캐시 전략 (NVMe 단독 / RAID1 / 개별 사용)
> - 공유 폴더 설정 방법
> - 성능 최적화 팁
>
> 구성을 결정한 후 이 페이지로 돌아와 3.4 단계를 진행하세요.

---

#### ✅ 선택된 구성: 옵션 1 - 패리티 보호 구성 (권장)
```
패리티: Dev 4 - HDD 3TB (sdc) [S/N: 45BSKX7GS]
디스크 1: Dev 1 - HDD 3TB (sdd) [S/N: 45ATVRPGS]
디스크 2: Dev 2 - HDD 3TB (sde) [S/N: 45AU0V4GS]
캐시 1: Dev 3 - SSD 128GB (sdb)
캐시 2: Dev 5 - NVMe 1TB (nvme0n1)
```
- 총 용량: 6TB (보호됨)
- 패리티로 1개 디스크 실패 시 복구 가능
- **실제 선택**: 이 옵션으로 진행

<details>
<summary>📋 다른 옵션: 최대 용량 구성 (패리티 없음) - 클릭하여 보기</summary>

#### 옵션 2: 최대 용량 구성 (패리티 없음)
```
디스크 1: Dev 4 - HDD 3TB (sdc)
디스크 2: Dev 1 - HDD 3TB (sdd)
디스크 3: Dev 2 - HDD 3TB (sde)
캐시 1: Dev 3 - SSD 128GB (sdb)
캐시 2: Dev 5 - NVMe 1TB (nvme0n1)
```
- 총 용량: 9TB (보호 없음)
- ⚠️ 디스크 실패 시 데이터 손실

</details>

---

#### 선택된 캐시 풀 구성

캐시 드라이브는 빠른 쓰기 성능과 Docker/VM 성능 향상을 위해 사용됩니다.

> 💡 **캐시 전략**: 자세한 내용은 [어레이 구성 가이드 - 캐시 전략](04-array-configuration.md#-캐시-전략) 참조

**보유 캐시 디바이스:**
- Dev 3: Samsung 830 SSD 128GB (SATA)
- Dev 5: XPG GAMMIX S11 Pro NVMe 1TB (PCIe 3.0)

<details>
<summary>📋 옵션 1: BTRFS RAID1 (미러링) - 안정성 우선</summary>

**옵션 1: BTRFS RAID1 (미러링)**
```
구성: SSD 128GB + NVMe 1TB → RAID1 풀
실제 용량: 128GB (작은 쪽 용량에 맞춰짐)
파일시스템: BTRFS
중복도: 2x (모든 데이터 2벌 저장)
```
**장점:**
- 한 디스크 실패 시에도 데이터 보존
- Docker appdata 안정성 최고
- 자동 데이터 복구 (비트 부패 감지)

**단점:**
- NVMe 1TB 중 128GB만 활용 (낭비)
- 총 가용 용량 128GB로 제한
- 쓰기 성능 약간 감소 (2벌 저장)

**추천 대상:**
- Docker 데이터 안정성이 최우선
- 용량보다 신뢰성 중시
- VM을 거의 사용하지 않는 경우

</details>

---

**✅ 선택된 구성: 옵션 2 - 개별 캐시 사용 (용량 최대화)**
```
캐시 1: SSD 128GB (독립)
캐시 2: NVMe 1TB (독립)
총 용량: 1.128TB
파일시스템: XFS 또는 BTRFS (개별)
중복도: 없음
```
**실제 구성**: 이 옵션으로 진행
**장점:**
- 전체 용량 활용 (1.128TB)
- NVMe 고속 성능 그대로 활용
- 공유별로 캐시 선택 가능

**단점:**
- 중복 없음 (디스크 실패 시 데이터 손실)
- 수동 공유 할당 필요
- 관리 복잡도 증가

**사용 시나리오:**
```
캐시 1 (SSD 128GB):
  - appdata (Docker 설정)
  - system (시스템 파일)
  - downloads (다운로드 임시)

캐시 2 (NVMe 1TB):
  - domains (VM 디스크)
  - transcode (미디어 변환 임시)
  - 고성능 필요 작업
```

**추천 대상:**
- VM을 많이 사용하는 경우
- 다운로드 양이 많은 경우
- 캐시 용량이 부족한 경우

<details>
<summary>📋 옵션 3: NVMe 단독 캐시 - 성능 최우선</summary>

**옵션 3: NVMe 단독 캐시**
```
캐시: NVMe 1TB (단독)
SSD 128GB: Unassigned Devices로 마운트
총 캐시 용량: 1TB
파일시스템: XFS 또는 BTRFS
```
**장점:**
- NVMe 최고 성능 (3500MB/s 읽기)
- 충분한 캐시 용량 (1TB)
- SSD를 다른 용도로 활용

**SSD 128GB 활용 방안:**
```
1. 전용 앱 캐시:
   - Plex 메타데이터 저장
   - 데이터베이스 전용 (MariaDB 등)
   - 로그 파일 저장

2. 백업 스테이징:
   - 백업 전 임시 저장소
   - 스냅샷 저장

3. 개발/테스트:
   - 테스트용 Docker 컨테이너
   - 임시 작업 공간
```

**추천 대상:**
- Docker + VM 모두 사용
- 캐시 성능이 중요
- SSD를 특수 용도로 활용

</details>

<details>
<summary>📋 상황별 권장 구성 - 클릭하여 보기</summary>

**🎯 권장 구성 (상황별)**

**초보자 / 안정성 우선:**
→ **옵션 1 (RAID1)** 선택
- 설정 간단, 데이터 보호
- Docker만 주로 사용

**중급자 / 용량 필요:**
→ **옵션 2 (개별 사용)** 선택
- VM + Docker 동시 사용
- 다운로드 양 많음

**고급 / 성능 + 유연성:**
→ **옵션 3 (NVMe 단독)** 선택
- 최고 성능 필요
- SSD 특수 용도 활용

---

**⚠️ 중요 참고사항:**

1. **백업 필수**: 캐시는 어레이 패리티로 보호되지 않음
   - appdata는 CA Backup 플러그인으로 정기 백업
   - VM은 별도 백업 전략 필요

2. **Mover 설정**: 캐시 → 어레이 이동 일정
   - Cache-prefer: 야간에 어레이로 이동
   - Cache-only: 캐시에만 유지
   - Cache-yes: 캐시 거쳐 어레이로

3. **용량 모니터링**: 캐시 풀 여유 공간 확인
   - 80% 이상 시 경고
   - Mover 실행 주기 조정

</details>

---

### 3.4 어레이 시작 및 디스크 할당

> ⚠️ **중요**: [어레이 구성 가이드](04-array-configuration.md)에서 전략을 결정했다면 이제 실제로 디스크를 할당합니다.

#### WebUI에서 디스크 할당하기

**Main → Array Devices** 화면에서:

1. **패리티 디스크 할당** (옵션 1 선택 시)
   - [x] Parity 슬롯: Dev 4 (sdc) 선택

2. **데이터 디스크 할당**
   - [x] Disk 1: Dev 1 (sdd) 선택
   - [x] Disk 2: Dev 2 (sde) 선택
   - [ ] Disk 3: (옵션 2 선택 시) Dev 4 (sdc) 선택

3. **캐시 디스크 할당** (선택한 캐시 전략에 따라)
   - [x] Cache: Dev 5 (nvme0n1) 또는 Dev 3 (sdb) 선택
   - [x] Cache 2: (옵션 2 선택 시) 추가 캐시 디스크 선택

#### 어레이 시작

4. **어레이 포맷 및 시작**
   - [x] "Start Array" 버튼 클릭
   - [x] "Yes, I want to do this" 체크박스 선택 (새 디스크의 경우)
   - [x] 포맷 시작 (약 40-80분 소요)

5. **패리티 동기화 대기** (옵션 1 선택 시)
   - [x] 패리티 동기화 시작 확인
   - [x] 예상 소요 시간: 6-12시간 (3TB 기준)
   - [x] 진행률: Main 탭에서 확인 가능

> 💡 **팁**: 패리티 동기화 중에도 시스템 사용 가능하지만, 성능이 저하될 수 있습니다.
> 야간에 시작하여 완료 대기하는 것을 권장합니다.

## 4단계: 공유 폴더 생성

> 💡 **상세 설정**: 공유 폴더의 캐시 전략 및 성능 최적화는
> [어레이 구성 가이드 - 공유 폴더 설정](04-array-configuration.md#-공유-폴더-설정)을 참조하세요.

### 4.1 기본 공유 폴더
| 이름 | 캐시 사용 | 용도 |
|------|-----------|------|
| Media | 예 | 미디어 파일 |
| Photos | 예 | 사진 저장 |
| Backups | 아니오 | 백업 파일 |
| appdata | Prefer | Docker 데이터 |
| domains | Prefer | VM 디스크 |

### 4.2 SMB 설정
- [ ] 설정 → SMB → SMB 활성화: 예
- [ ] 작업 그룹: WORKGROUP
- [ ] 로컬 마스터: 예

## 완료 체크리스트
- [ ] 어레이 정상 작동
- [ ] 패리티 동기화 진행 중
- [ ] 웹 UI 접속 가능
- [ ] SMB 공유 접근 가능
- [ ] 기본 공유 폴더 생성 완료