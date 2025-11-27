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
- [ ] 시간대: Asia/Seoul
- [ ] 키보드: Korean
- [ ] 호스트명: Tower (또는 원하는 이름)

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

### 3.3 디스크 할당 옵션

#### ✅ 선택: 옵션 1 - 패리티 보호 구성 (권장)
```
패리티: Dev 4 - HDD 3TB (sdc) [S/N: 45BSKX7GS]
디스크 1: Dev 1 - HDD 3TB (sdd) [S/N: 45ATVRPGS]
디스크 2: Dev 2 - HDD 3TB (sde) [S/N: 45AU0V4GS]
캐시 1: Dev 3 - SSD 128GB (sdb)
캐시 2: Dev 5 - NVMe 1TB (nvme0n1)
```
- 총 용량: 6TB (보호됨)
- 패리티로 1개 디스크 실패 시 복구 가능
- **실제 구성**: 이 옵션으로 진행

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

#### 캐시 풀 구성

캐시 드라이브는 빠른 쓰기 성능과 Docker/VM 성능 향상을 위해 사용됩니다.

**보유 캐시 디바이스:**
- Dev 3: Samsung 830 SSD 128GB (SATA)
- Dev 5: XPG GAMMIX S11 Pro NVMe 1TB (PCIe 3.0)

**옵션 1: BTRFS RAID1 (미러링) - 안정성 우선**
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

---

**✅ 선택: 옵션 2 - 개별 캐시 사용 (용량 최대화)**
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

---

**옵션 3: NVMe 단독 캐시 - 성능 최우선**
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

---

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

### 3.4 어레이 시작
- [ ] Start Array 클릭
- [ ] Format 체크박스 선택 (새 디스크)
- [ ] Format 시작 (약 40-80분)
- [ ] 패리티 동기화 시작 (6-12시간)

## 4단계: 공유 폴더 생성

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