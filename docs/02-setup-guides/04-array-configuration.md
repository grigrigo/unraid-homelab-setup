# 🗄️ 어레이 구성 가이드

Unraid 디스크 어레이 최적 구성 방법

---

## 📖 이 문서를 읽기 전에

> 🔙 **이전 단계**: [초기 설치 가이드 - 3.2 디바이스 확인](03-initial-installation.md#32-감지된-디바이스-확인)에서 오셨나요?
>
> 이 문서에서 어레이 구성 전략을 결정한 후, [초기 설치 가이드 - 3.4 어레이 시작](03-initial-installation.md#34-어레이-시작-및-디스크-할당)으로 돌아가서 실제 할당을 진행하세요.

### 이 가이드의 목적

이 문서는 다음을 결정하는 데 도움을 줍니다:
1. **어레이 구성**: 패리티 보호 vs 최대 용량
2. **캐시 전략**: NVMe 단독 / RAID1 / 개별 사용
3. **공유 폴더 설정**: 캐시 사용 정책
4. **성능 최적화**: Mover, Turbo Write 등

---

## 📊 현재 하드웨어 기반 구성 옵션

### 보유 디스크
- **HDD**: TOSHIBA DT01ACA300 3TB × 3개
- **SSD**: Samsung 830 Series 128GB SATA
- **NVMe**: XPG GAMMIX S11 Pro 1TB

## 🎯 구성 전략별 비교

| 구성 | 패리티 | 데이터 | 총 용량 | 보호 | 권장 사용 사례 |
|------|--------|--------|---------|------|--------------|
| **안전 우선** | 1 × 3TB | 2 × 3TB | 6TB | ✅ | 중요 데이터, 가족 사진 |
| **용량 우선** | 없음 | 3 × 3TB | 9TB | ❌ | 백업 있는 미디어 |
| **하이브리드** | 추후 추가 | 3 × 3TB | 9TB → 6TB | 일부 | 단계적 구축 |

## 🔧 구성 1: 안전 우선 (권장)

### 디스크 할당
```yaml
패리티 디스크:
  - Parity: TOSHIBA 3TB (디스크 #1)

데이터 디스크:
  - Disk 1: TOSHIBA 3TB (디스크 #2)
  - Disk 2: TOSHIBA 3TB (디스크 #3)

캐시 구성:
  - Cache: XPG NVMe 1TB (고속 캐시)
  - Unassigned: Samsung 830 SSD 128GB (앱 전용)
```

### 장점
- ✅ 1개 디스크 실패 시 완벽 복구
- ✅ 데이터 무결성 보장
- ✅ 안전한 24/7 운영
- ✅ SMART 경고 시 여유있는 교체

### 단점
- ❌ 총 용량 33% 감소 (9TB → 6TB)
- ❌ 쓰기 속도 약간 감소

### 설정 방법
```markdown
1. Main → Array Devices
2. Parity 슬롯: TOSHIBA 3TB 선택
3. Disk 1: TOSHIBA 3TB 선택
4. Disk 2: TOSHIBA 3TB 선택
5. Cache: XPG NVMe 선택
6. Start Array 클릭
7. 패리티 동기화 대기 (약 6-8시간)
```

## 💾 구성 2: 용량 우선

### 디스크 할당
```yaml
패리티 디스크:
  - Parity: 없음

데이터 디스크:
  - Disk 1: TOSHIBA 3TB (디스크 #1)
  - Disk 2: TOSHIBA 3TB (디스크 #2)
  - Disk 3: TOSHIBA 3TB (디스크 #3)

캐시 구성:
  - Cache Pool: SSD 128GB + NVMe 1TB
```

### 장점
- ✅ 최대 용량 활용 (9TB)
- ✅ 빠른 쓰기 속도
- ✅ 대용량 캐시 풀 (1.128TB)

### 단점
- ❌ 디스크 실패 시 데이터 손실
- ❌ 정기 백업 필수
- ❌ 위험한 운영

### ⚠️ 이 구성 선택 시 필수 사항
```bash
# 자동 백업 스크립트 설정
#!/bin/bash
# 중요 데이터를 외부로 백업
rsync -av /mnt/user/important/ /backup/external/
```

## 🔄 구성 3: 단계적 전환 (하이브리드)

### 초기 구성 (현재)
```yaml
Phase 1 (용량 확보):
  - Disk 1-3: TOSHIBA 3TB × 3
  - Cache: NVMe 1TB
  - 총 용량: 9TB (보호 없음)
```

### 추후 전환 (HDD 추가 시)
```yaml
Phase 2 (패리티 추가):
  - 새 HDD 구매 (3TB 이상)
  - 새 디스크를 패리티로 설정
  - 기존 3개는 데이터 디스크 유지
  - 총 용량: 9TB (보호됨)
```

### 전환 절차
```bash
# HDD 추가 구매 후
1. Tools → New Config
2. "Preserve current assignments" 선택
3. 새 디스크를 Parity 슬롯에 할당
4. Start Array
5. 패리티 구축 (약 8시간)
```

## 🚀 캐시 전략

### 옵션 A: NVMe 단독 캐시 (권장)
```yaml
구성:
  - Cache: XPG NVMe 1TB
  - 용도:
    - Docker appdata
    - 다운로드 임시
    - VM vdisk
    - 쓰기 캐시

장점:
  - 최고 속도 (3500MB/s 읽기)
  - 대용량 (1TB)
  - SSD는 별도 활용 가능
```

### 옵션 B: SSD + NVMe 풀
```yaml
구성:
  - Cache Pool: BTRFS RAID1
  - 멤버: SSD 128GB + NVMe 1TB
  - 유효 용량: 128GB (미러링)

장점:
  - 캐시 데이터 보호
  - 하나 실패해도 작동

단점:
  - 용량 손실 (1.128TB → 128GB)
  - 속도가 SSD로 제한
```

### 옵션 C: 용도별 분리
```yaml
구성:
  - Cache 1 (NVMe): 고속 필요 앱
  - Cache 2 (SSD): 일반 앱

할당 예시:
  NVMe (1TB):
    - Plex 트랜스코딩
    - 데이터베이스
    - 다운로드

  SSD (128GB):
    - Docker appdata
    - 로그 파일
    - 백업 스테이징
```

## 📁 공유 폴더 설정

### 필수 공유 폴더
```yaml
appdata:
  - Use cache: Prefer
  - Cache: NVMe
  - 용도: Docker 앱 데이터

system:
  - Use cache: Prefer
  - Cache: NVMe
  - 용도: Docker/VM 이미지

Media:
  - Use cache: Yes
  - Cache: NVMe
  - 용도: 영화, TV, 음악

Photos:
  - Use cache: No
  - 용도: 사진 (직접 어레이)

Backups:
  - Use cache: No
  - 용도: 백업 파일

Downloads:
  - Use cache: Only
  - Cache: NVMe
  - 용도: 임시 다운로드
```

### 캐시 설정 옵션 설명
- **No**: 캐시 사용 안 함 (어레이 직접 쓰기)
- **Yes**: 캐시 우선, Mover로 어레이 이동
- **Only**: 캐시에만 저장 (어레이 이동 안 함)
- **Prefer**: 캐시에 유지, 꽉 차면 어레이

## 🔄 Mover 설정

### 스케줄 설정
```yaml
Settings → Scheduler → Mover Settings:
  - Mover schedule: Daily
  - Time: 03:00 AM
  - Move if cache > 70%

Tunable:
  - Mover logging: Enabled
  - Move files off cache: Yes
  - Days old: 1
```

### 수동 실행
```bash
# 즉시 Mover 실행
mover start

# 진행 상황 확인
tail -f /var/log/syslog | grep mover
```

## 📊 성능 최적화

### Turbo Write 모드
```yaml
Settings → Disk Settings:
  - Enable auto start: Yes
  - Default spin down: 30분
  - Tunable (md_write_method):
    - Auto (기본)
    - Reconstruct write (Turbo)

Turbo Write:
  - 장점: 2-3배 빠른 쓰기
  - 단점: 모든 디스크 회전
  - 권장: 대용량 파일 전송 시
```

### 디스크 스핀다운
```yaml
개별 디스크 설정:
  - HDD: 30분 (전력 절약)
  - SSD: Never (스핀다운 불필요)
  - NVMe: Never
```

## ✅ 구성 확인 체크리스트

### 어레이 시작 전
- [ ] 디스크 시리얼 번호 기록
- [ ] SMART 상태 확인
- [ ] 케이블 연결 확인
- [ ] BIOS AHCI 모드 확인

### 어레이 시작 후
- [ ] 모든 디스크 Mounted
- [ ] 패리티 Valid 또는 Building
- [ ] 캐시 Formatted
- [ ] 온도 정상 (< 45°C)

### 첫 24시간
- [ ] 패리티 동기화 완료
- [ ] SMART 테스트 실행
- [ ] 읽기/쓰기 테스트
- [ ] Docker 앱 설치 테스트

## 🚨 문제 해결

### 디스크 인식 안 됨
```bash
# 디스크 목록 확인
ls -la /dev/disk/by-id/

# 수동 스캔
echo "- - -" > /sys/class/scsi_host/host0/scan
```

### 어레이 시작 실패
```markdown
1. Tools → Diagnostics 다운로드
2. 포럼에 로그 첨부
3. 일반적인 원인:
   - 잘못된 디스크 할당
   - 케이블 불량
   - BIOS 설정 오류
```

## 📈 향후 확장 계획

### 6개월 내
- [ ] 4번째 HDD 추가 (패리티용)
- [ ] 총 용량: 9TB 보호됨

### 1년 내
- [ ] 3TB → 8TB 디스크 교체
- [ ] 듀얼 패리티 검토
- [ ] 10Gb 네트워크

### 2년 내
- [ ] 전체 디스크 대용량 교체
- [ ] 별도 백업 NAS 구축

---

## 🎯 구성 완료 후 다음 단계

어레이 구성 전략을 결정하셨나요? 이제 실제 설치를 진행합니다!

### ✅ 결정 사항 체크리스트

다음 항목을 결정했는지 확인하세요:

- [ ] **어레이 구성 방식**
  - [ ] 구성 1: 패리티 보호 (6TB, 안전)
  - [ ] 구성 2: 최대 용량 (9TB, 위험)
  - [ ] 구성 3: 단계적 전환 (나중에 패리티 추가)

- [ ] **캐시 전략**
  - [ ] 옵션 A: NVMe 단독 캐시 (권장)
  - [ ] 옵션 B: SSD + NVMe RAID1 (안정성)
  - [ ] 옵션 C: 용도별 분리 (개별 사용)

- [ ] **공유 폴더 계획**
  - [ ] appdata → Cache 설정
  - [ ] Media → Cache 설정
  - [ ] Downloads → Cache 설정

### 🔄 다음으로 이동

1. **디스크 할당 실행**
   👉 [초기 설치 가이드 - 3.4 어레이 시작](03-initial-installation.md#34-어레이-시작-및-디스크-할당)로 이동

2. **어레이 시작 후**
   - 패리티 동기화 완료 대기 (6-12시간)
   - 공유 폴더 생성 및 캐시 설정
   - Mover 스케줄 구성

3. **추가 설정**
   - [보안 강화](07-security-hardening.md)
   - [Docker 앱 설치](../03-application-guides/docker-apps-overview.md)
   - [백업 전략 구현](../03-application-guides/backup-solutions/backup-strategy.md)

---

💡 **권장**: 처음에는 패리티 구성으로 시작하세요. 데이터 보호가 용량보다 중요합니다.

⚡ **팁**: NVMe는 캐시로, SSD는 앱 전용으로 분리하면 최적 성능을 얻을 수 있습니다.