# 💾 디스크 교체 절차

안전한 디스크 교체를 위한 상세 가이드

---

## 📋 교체 시나리오

| 시나리오 | 난이도 | 소요 시간 | 데이터 위험 |
|---------|--------|-----------|------------|
| 데이터 디스크 교체 (계획) | ⭐⭐ | 8-24시간 | 낮음 |
| 데이터 디스크 교체 (실패) | ⭐⭐⭐ | 8-24시간 | 중간 |
| 패리티 디스크 교체 | ⭐⭐ | 12-30시간 | 낮음 |
| 캐시 디스크 교체 | ⭐⭐ | 2-4시간 | 낮음 |
| 용량 증설 교체 | ⭐⭐⭐ | 24-48시간 | 낮음 |
| 다중 디스크 동시 교체 | ⭐⭐⭐⭐⭐ | 2-3일 | 높음 |

## 🔧 사전 준비

### 필수 확인 사항
```bash
[ ] 현재 패리티 상태: Valid
[ ] 모든 디스크 상태: Normal
[ ] 최근 패리티 체크 날짜: _______
[ ] 중요 데이터 백업 완료
[ ] 교체 디스크 준비 완료
```

### 교체 디스크 요구사항
```markdown
데이터 디스크 교체:
- 용량: 기존 디스크와 동일하거나 더 큰 용량
- 패리티 디스크보다 작거나 같은 용량

패리티 디스크 교체:
- 용량: 가장 큰 데이터 디스크와 같거나 더 큰 용량

캐시 디스크 교체:
- 용량: 제한 없음 (용도에 맞게 선택)
```

### 새 디스크 사전 테스트
```bash
# SMART 테스트
smartctl -t long /dev/sdX
# 4-8시간 대기 후
smartctl -a /dev/sdX

# Preclear (선택사항 but 권장)
# Preclear 플러그인 사용 또는
./preclear_disk.sh -c 1 /dev/sdX
```

## 📝 시나리오별 상세 절차

## 1. 데이터 디스크 교체 (계획된 교체)

### 상황
- 디스크는 작동하지만 SMART 경고
- 용량 증설 목적
- 예방적 교체

### Step 1: 현재 상태 기록
```bash
# 디스크 정보 저장
smartctl -a /dev/sdX > /boot/disk_info_$(date +%Y%m%d).txt

# 어레이 구성 백업
cp /boot/config/super.dat /boot/config/super.dat.bak

# 스크린샷
Main 페이지 스크린샷 저장
```

### Step 2: 디스크 준비
```bash
# 1. 어레이 중지
Main → Stop Array

# 2. 교체할 디스크 기록
Disk X: [모델명] [시리얼번호]
슬롯: _______
SATA 포트: _______
```

### Step 3: 물리적 교체
```markdown
1. 시스템 종료
   Main → Shutdown

2. 전원 차단
   - PSU 스위치 OFF
   - 전원 케이블 분리

3. 디스크 교체
   - 기존 디스크 제거
   - 새 디스크 장착
   - SATA/전원 케이블 연결

4. 시스템 부팅
```

### Step 4: 디스크 할당
```bash
# 1. 어레이 시작 전 확인
Main → Array Devices
- 교체된 슬롯 확인
- "Unassigned" 상태 확인

# 2. 새 디스크 할당
- 드롭다운에서 새 디스크 선택
- Serial 번호 확인

# 3. 어레이 시작
Main → Start
```

### Step 5: 재구성 시작
```markdown
⚠️ 중요: "Will bring the array on-line and start Data-Rebuild"

확인 사항:
- [ ] Parity-Sync/Data-Rebuild 시작
- [ ] 진행률 표시
- [ ] 예상 시간 확인
```

### Step 6: 재구성 모니터링
```bash
# 진행 상황 확인
Main 페이지에서 실시간 확인

# 속도 조절 (필요시)
Settings → Disk Settings
- Tunable (md_sync_window): 384 (기본)
- Tunable (md_num_stripes): 4096 (기본)
- Tunable (md_write_limit): 768 (안전) / 2048 (빠름)

# 로그 모니터링
tail -f /var/log/syslog | grep "md:"
```

### Step 7: 완료 확인
```bash
[ ] 재구성 100% 완료
[ ] Sync errors corrected: 0
[ ] 어레이 상태: Good
[ ] 새 디스크 상태: Normal
[ ] SMART 테스트 실행
```

## 2. 데이터 디스크 교체 (실패한 디스크)

### 상황
- 디스크 완전 실패 (빨간 X)
- 읽기/쓰기 오류
- 디스크 인식 안 됨

### Step 1: 긴급 조치
```bash
# 1. 추가 손상 방지
Settings → Global Share Settings
- Enable disk shares: No (읽기 전용)

# 2. Docker/VM 중지
Settings → Docker → Stop
Settings → VM Manager → Stop

# 3. 중요 데이터 백업 (가능한 경우)
rsync -avP /mnt/user/critical/ /backup/location/
```

### Step 2: 디스크 상태 확인
```bash
# 에뮬레이션 모드 확인
Main 페이지에서 Disk X 상태
- "Disabled, Contents emulated" 표시

# 재구성 가능 여부 확인
- 패리티 Valid: 재구성 가능
- 패리티 Invalid: 데이터 손실
```

### Step 3: 교체 절차
```markdown
싱글 패리티 + 1 디스크 실패:
1. 어레이 중지
2. 실패 디스크 물리적 교체
3. 새 디스크 할당
4. 어레이 시작 (재구성 시작)
5. 재구성 완료 대기

듀얼 패리티 + 1 디스크 실패:
- 싱글 패리티와 동일 절차
- 더 안전한 상태

듀얼 패리티 + 2 디스크 실패:
1. 첫 번째 디스크 교체/재구성
2. 완료 후 두 번째 디스크 교체
3. 순차적으로 진행 (동시 X)
```

## 3. 패리티 디스크 교체

### 상황
- 패리티 디스크 실패/경고
- 더 큰 용량으로 업그레이드

### ⚠️ 위험 경고
```markdown
패리티 없는 상태 = 데이터 보호 없음
이 기간 동안 디스크 실패 시 데이터 손실!
```

### Step 1: 사전 조치
```bash
# 1. 전체 패리티 체크 (권장)
Main → Check
- 오류 수정 없이 읽기만

# 2. 모든 디스크 SMART 확인
for disk in /dev/sd[b-z]; do
    echo "=== $disk ==="
    smartctl -H $disk
done

# 3. 중요 데이터 백업 필수
```

### Step 2: 패리티 교체
```bash
# 1. 어레이 중지
# 2. 패리티 디스크 물리적 교체
# 3. 새 패리티 디스크 할당
# 4. 어레이 시작

⚠️ "Will bring the array on-line and start Parity-Sync"
```

### Step 3: 패리티 동기화
```bash
# 예상 시간
12TB @ 150MB/s = ~22시간

# 동기화 중 주의사항
- 시스템 사용 최소화
- Docker/VM 중지 권장
- 쓰기 작업 자제
```

## 4. 캐시 디스크 교체

### 단일 캐시 디스크

#### Step 1: Mover 실행
```bash
# 캐시 → 어레이로 데이터 이동
Settings → Scheduler → Mover
"Move Now" 클릭

# 완료 확인
df -h /mnt/cache
(Used 최소화 확인)
```

#### Step 2: 교체
```bash
1. Settings → Docker → Stop
2. 어레이 중지
3. 캐시 디스크 제거 (슬롯에서)
4. 새 SSD 물리적 장착
5. 캐시 슬롯에 할당
6. 어레이 시작
7. 포맷
```

### 캐시 풀 (BTRFS RAID1)

#### Step 1: 풀 상태 확인
```bash
btrfs device stats /mnt/cache
btrfs fi show /mnt/cache
```

#### Step 2: 디스크 교체
```bash
# 방법 A: 실패 전 교체
1. 새 디스크 추가
   btrfs device add /dev/sdX /mnt/cache
2. 기존 디스크 제거
   btrfs device remove /dev/sdY /mnt/cache

# 방법 B: 실패 후 교체
1. 어레이 시작 (degraded)
2. 새 디스크 추가
3. 밸런싱 실행
   btrfs balance start /mnt/cache
```

## 5. 용량 증설 교체

### 패리티 크기 제한 이해
```markdown
규칙: 모든 데이터 디스크 ≤ 패리티 디스크

예시:
- 패리티: 12TB
- 데이터: 최대 12TB까지 가능
```

### 증설 전략

#### 옵션 1: 패리티 먼저 교체
```bash
1. 패리티를 더 큰 디스크로 교체
2. 패리티 동기화 완료
3. 데이터 디스크 순차 교체
```

#### 옵션 2: 데이터 디스크부터
```bash
1. 작은 데이터 디스크부터 교체
2. 모두 교체 후
3. 패리티를 가장 큰 디스크로 이동
4. 기존 패리티를 데이터로 전환
```

### 실행 예시 (3TB → 12TB 증설)
```markdown
초기 상태:
- 패리티: 3TB
- 데이터1: 3TB
- 데이터2: 3TB
- 데이터3: 3TB

Step 1: 패리티를 12TB로 교체
- 패리티 동기화 (20시간)

Step 2: 데이터1을 12TB로 교체
- 재구성 (20시간)

Step 3: 데이터2를 12TB로 교체
- 재구성 (20시간)

최종 상태:
- 패리티: 12TB
- 데이터1: 12TB
- 데이터2: 12TB
- 데이터3: 3TB (나중에 교체)
```

## 📊 교체 시간 예측

### 재구성/동기화 속도
| 작업 | 평균 속도 | 3TB | 8TB | 12TB |
|------|-----------|-----|-----|------|
| 패리티 동기화 | 150 MB/s | 6시간 | 15시간 | 22시간 |
| 데이터 재구성 | 120 MB/s | 7시간 | 19시간 | 28시간 |
| Preclear | 100 MB/s | 8시간 | 22시간 | 34시간 |

### 속도 영향 요인
- CPU 성능
- 메모리 용량
- 디스크 수
- 동시 사용량
- 튜너블 설정

## ⚠️ 주의사항 및 금기

### 절대 하지 말아야 할 것
```markdown
❌ 패리티 동기화/재구성 중 전원 차단
❌ 다중 디스크 동시 교체 (순차적으로!)
❌ New Config 남용 (데이터 손실 위험)
❌ Trust Parity 잘못된 사용
❌ 패리티 없이 위험한 작업
```

### 안전 수칙
```markdown
✅ 교체 전 패리티 체크
✅ SMART 상태 확인
✅ 중요 데이터 백업
✅ 한 번에 한 디스크만
✅ 완료 후 검증
```

## 🛠️ 문제 해결

### 재구성 실패
```bash
# 원인 확인
dmesg | grep -i error
cat /var/log/syslog | grep "md:"

# 일반적인 원인
1. 추가 디스크 실패
2. 케이블 문제
3. 전원 문제
4. 과열
```

### 느린 재구성
```bash
# 튜너블 조정
Settings → Disk Settings
- md_write_limit: 2048 (최대 속도)
- md_sync_window: 768
- md_num_stripes: 8192

# 주의: 시스템 부하 증가
```

### 재구성 중 오류
```bash
# 일시 중지/재개
echo idle > /sys/block/md0/md/sync_action
echo recover > /sys/block/md0/md/sync_action

# 강제 재시작 (위험)
Main → Stop Array
Main → Start Array
```

## 📝 교체 로그 템플릿

```markdown
## 디스크 교체 기록

날짜: 2025-XX-XX
작업자: ___________

### 교체 정보
- 교체 사유: [실패/증설/예방]
- 기존 디스크: [모델] [용량] [시리얼]
- 새 디스크: [모델] [용량] [시리얼]
- 슬롯: Disk X / Parity / Cache

### 작업 타임라인
- HH:MM - 어레이 중지
- HH:MM - 디스크 교체
- HH:MM - 어레이 시작
- HH:MM - 재구성 시작
- HH:MM - 재구성 완료

### 재구성 통계
- 소요 시간: XX시간
- 평균 속도: XXX MB/s
- 오류 수: 0
- 최고 온도: XX°C

### 검증
- [ ] SMART 테스트 통과
- [ ] 파일 시스템 체크
- [ ] 읽기/쓰기 테스트
- [ ] 온도 정상

### 특이사항
[기록]

### 다음 점검
- 날짜: _______
- 작업: SMART 확인
```

## ✅ 교체 후 체크리스트

### 즉시 확인
```bash
[ ] 어레이 상태: Good
[ ] 모든 디스크: Normal
[ ] 패리티: Valid
[ ] SMART: PASSED
```

### 24시간 후
```bash
[ ] Extended SMART 테스트
[ ] 온도 모니터링
[ ] 성능 테스트
[ ] 로그 확인
```

### 1주일 후
```bash
[ ] 패리티 체크 실행
[ ] 전체 백업
[ ] 성능 벤치마크
```

## 🚀 모범 사례

### 예방적 교체
- SMART 경고 시 즉시 계획
- 3-5년 주기 교체 고려
- 예비 디스크 보유

### 교체 타이밍
- 주말/휴일 활용
- 사용량 적은 시간
- 날씨 좋은 날 (정전 위험 낮음)

### 문서화
- 모든 교체 기록
- SMART 데이터 보관
- 구성 변경 기록

---

💡 **골든 룰**: "의심스러우면 교체하라" - 데이터는 디스크보다 훨씬 가치있습니다.

⏰ **타이밍**: 재구성은 시간이 걸립니다. 서두르지 말고 안전하게 진행하세요.