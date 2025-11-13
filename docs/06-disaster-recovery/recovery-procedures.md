# 🚨 재해 복구 절차

Unraid 시스템 장애 시 단계별 복구 가이드

---

## 📋 복구 시나리오 매트릭스

| 시나리오 | 심각도 | 예상 복구 시간 | 데이터 손실 |
|---------|--------|---------------|------------|
| USB 부팅 실패 | 낮음 | 30분 | 없음 |
| 캐시 드라이브 실패 | 중간 | 2-4시간 | 가능성 있음 |
| 데이터 디스크 실패 | 중간 | 6-24시간 | 없음 (패리티) |
| 패리티 디스크 실패 | 중간 | 6-24시간 | 없음 |
| 다중 디스크 실패 | 높음 | 1-3일 | 가능성 높음 |
| 메인보드/CPU 실패 | 중간 | 4-8시간 | 없음 |
| 전체 시스템 손실 | 매우 높음 | 3-7일 | 백업 의존 |

## 🔧 시나리오별 복구 절차

## 1. USB 부팅 드라이브 실패

### 증상
- Unraid 부팅 불가
- "Missing operating system" 오류
- USB 드라이브 인식 안 됨

### 복구 절차

#### Step 1: USB 백업 확인
```bash
# 백업 위치 확인
/mnt/user/backups/usb/
├── config/
├── bzroot
├── bzimage
└── flash_backup_YYYY-MM-DD.zip
```

#### Step 2: 새 USB 생성
1. 새 USB 드라이브 준비 (동일 GUID 유지)
2. Unraid USB Creator 실행
3. 백업에서 config 폴더 복원

```bash
# Linux/Mac에서 복원
# 1. 새 USB 마운트
mount /dev/sdX1 /mnt/usb

# 2. 백업 복원
unzip /path/to/flash_backup.zip -d /mnt/usb/

# 3. GUID 확인 (Plus.key 파일)
cat /mnt/usb/config/Plus.key
```

#### Step 3: 부팅 및 확인
- [ ] BIOS에서 USB 부팅 설정
- [ ] 정상 부팅 확인
- [ ] 어레이 자동 인식 확인
- [ ] Docker/VM 서비스 시작

### 예방 조치
```bash
# 자동 USB 백업 스크립트
#!/bin/bash
# /boot/config/plugins/user.scripts/scripts/backup_usb/script

BACKUP_DIR="/mnt/user/backups/usb"
DATE=$(date +%Y%m%d)

# USB 백업
zip -r ${BACKUP_DIR}/flash_backup_${DATE}.zip /boot/* \
  -x "/boot/previous/*" \
  -x "/boot/logs/*"

# 오래된 백업 삭제 (30일 이상)
find ${BACKUP_DIR} -name "flash_backup_*.zip" -mtime +30 -delete
```

## 2. 캐시 드라이브 실패

### 증상
- 캐시 풀 오류
- Docker/VM 시작 안 됨
- 쓰기 성능 저하

### 복구 절차

#### Step 1: 캐시 상태 확인
```bash
# Main → Cache Devices
# 상태 확인: unmountable, missing, disabled

# SMART 확인
smartctl -a /dev/sdX
```

#### Step 2: Mover 실행 (가능한 경우)
```bash
# Settings → Scheduler → Mover
# "Move Now" 클릭

# 또는 수동 실행
mover start

# 진행 상황 모니터링
tail -f /var/log/syslog | grep mover
```

#### Step 3: 캐시 교체

##### A. 단일 캐시 드라이브
1. 어레이 중지
2. 캐시 슬롯에서 디스크 제거
3. 새 SSD 할당
4. 어레이 시작
5. 포맷

##### B. 캐시 풀 (BTRFS RAID1)
```bash
# 정상 드라이브가 있는 경우
# 1. 어레이 시작 (degraded 모드)
# 2. 새 드라이브 추가
btrfs device add /dev/sdX /mnt/cache

# 3. 실패한 드라이브 제거
btrfs device delete missing /mnt/cache

# 4. 밸런싱
btrfs balance start /mnt/cache
```

#### Step 4: Docker/VM 복원

```bash
# appdata 복원 (백업에서)
rsync -avP /mnt/user/backups/appdata/ /mnt/cache/appdata/

# Docker 서비스 시작
/etc/rc.d/rc.docker start

# 컨테이너 확인
docker ps -a
```

## 3. 데이터 디스크 실패 (패리티 있음)

### 복구 절차

#### Step 1: 디스크 상태 확인
```bash
# Main → Array Devices
# 빨간색 X 표시 확인

# 시스템 로그 확인
grep "read error" /var/log/syslog
```

#### Step 2: 디스크 교체 준비
- [ ] 동일 용량 이상 디스크 준비
- [ ] SMART 테스트 완료
- [ ] Preclear 실행 (선택)

#### Step 3: 교체 프로세스

```markdown
1. 어레이 중지 (Main → Stop)
2. 실패 디스크 물리적 교체
3. 새 디스크 할당
   - Tools → New Config → Preserve current assignments: All
   - 실패한 슬롯에 새 디스크 할당
4. 어레이 시작
5. 재구성 시작 확인
```

#### Step 4: 재구성 모니터링
```bash
# 진행률 확인 (Main 페이지)
# 예상 시간: 3TB @ 150MB/s = ~6시간

# 속도 조절 (필요시)
# Settings → Disk Settings
# Tunable (md_write_limit): 2048 (빠름) / 768 (기본)
```

## 4. 패리티 디스크 실패

### 즉시 조치
⚠️ **경고**: 패리티 없는 상태에서 추가 디스크 실패 시 데이터 손실!

#### Step 1: 긴급 백업
```bash
# 중요 데이터 즉시 백업
rsync -avP /mnt/user/critical/ /backup/location/

# 어레이 읽기 전용 모드
# Settings → Global Share Settings → Enable disk shares: No
```

#### Step 2: 패리티 교체
1. 어레이 중지
2. 패리티 디스크 교체
3. 새 디스크를 패리티 슬롯에 할당
4. 어레이 시작
5. 패리티 동기화 시작

#### Step 3: 동기화 모니터링
```bash
# 12TB 패리티 = ~20시간 @ 170MB/s
# Main 페이지에서 진행률 확인

# 동기화 중 시스템 사용 최소화
# Docker/VM 중지 권장
```

## 5. 다중 디스크 실패

### ⚠️ 심각도: 매우 높음

#### 시나리오 A: 패리티 + 데이터 디스크
```bash
# 복구 불가능 - 백업에서 복원
# 1. 새 어레이 구성
# 2. 백업에서 데이터 복원
```

#### 시나리오 B: 2개 데이터 디스크 (듀얼 패리티)
```bash
# 복구 가능
# 1. 한 번에 하나씩 교체
# 2. 각 교체 후 재구성 완료 대기
```

#### 시나리오 C: 2개 데이터 디스크 (싱글 패리티)
```bash
# 부분 복구 시도
# 1. ddrescue로 데이터 추출 시도
ddrescue -f -r3 /dev/sdX /recovery/diskX.img /recovery/diskX.log

# 2. 이미지에서 파일 시스템 복구 시도
fsck -y /recovery/diskX.img

# 3. 마운트 및 데이터 추출
mount -o ro,loop /recovery/diskX.img /mnt/recovery
```

## 6. 메인보드/CPU 실패

### 복구 절차

#### Step 1: 하드웨어 교체
- [ ] 호환 가능한 메인보드 확보
- [ ] 동일 SATA 포트 수 확인
- [ ] ECC RAM 지원 확인 (사용 중인 경우)

#### Step 2: 시스템 재구성
1. 모든 디스크 동일 순서로 연결
2. USB 부팅 드라이브 연결
3. 네트워크 케이블 연결
4. 첫 부팅

#### Step 3: 설정 조정
```bash
# IP 주소 변경 가능성
# 콘솔에서 확인 또는 DHCP 확인

# 네트워크 재설정 (필요시)
/etc/rc.d/rc.inet1 restart

# 디스크 순서 확인
# Tools → New Config → Preserve: All
```

## 7. 전체 시스템 손실 (화재/홍수/도난)

### 복구 전략

#### Step 1: 오프사이트 백업 확인
```bash
# 클라우드 백업
# - Backblaze B2
# - AWS S3
# - Google Drive

# 원격 NAS 백업
# - 친구/가족 집 NAS
# - 콜로케이션 서버
```

#### Step 2: 새 하드웨어 구축
- [ ] 하드웨어 구매/조립
- [ ] Unraid 새로 설치
- [ ] 기본 설정

#### Step 3: 데이터 복원

##### 클라우드에서 복원
```bash
# rclone 사용
rclone copy remote:backup /mnt/user/restore \
  --transfers 4 \
  --checkers 8 \
  --progress

# 예상 시간: 1TB @ 100Mbps = ~24시간
```

##### 백업 NAS에서 복원
```bash
# rsync over SSH
rsync -avP --bwlimit=10000 \
  user@backup-nas:/backup/ \
  /mnt/user/restore/
```

## 📊 복구 시간 목표 (RTO)

| 서비스 | 목표 RTO | 실제 예상 |
|--------|----------|----------|
| 파일 공유 (SMB) | 4시간 | 2-4시간 |
| Docker 앱 | 8시간 | 4-8시간 |
| 미디어 서버 | 24시간 | 12-24시간 |
| 전체 데이터 | 72시간 | 48-96시간 |

## 🔍 복구 후 검증

### 시스템 검증 체크리스트
```bash
# 1. 어레이 상태
[ ] 모든 디스크 정상
[ ] 패리티 유효
[ ] SMART 오류 없음

# 2. 네트워크
[ ] 웹 UI 접속
[ ] SMB 공유 접근
[ ] Docker 네트워크

# 3. 서비스
[ ] Docker 컨테이너 실행
[ ] VM 시작 (있는 경우)
[ ] 예약 작업 동작

# 4. 데이터 무결성
[ ] 샘플 파일 열기
[ ] 데이터베이스 체크
[ ] 미디어 파일 재생
```

### 데이터 검증 스크립트
```bash
#!/bin/bash
# /boot/config/plugins/user.scripts/scripts/verify_recovery/script

echo "=== 복구 검증 시작 ==="

# 1. 디스크 상태
echo "디스크 상태 확인..."
mdcmd status | grep "DISK_OK"

# 2. Docker 상태
echo "Docker 컨테이너 확인..."
docker ps --format "table {{.Names}}\t{{.Status}}"

# 3. 주요 폴더 확인
DIRS=("/mnt/user/Media" "/mnt/user/Photos" "/mnt/user/Backups")
for dir in "${DIRS[@]}"; do
  if [ -d "$dir" ]; then
    count=$(find "$dir" -type f | wc -l)
    echo "$dir: $count 파일"
  else
    echo "⚠️ $dir 없음!"
  fi
done

# 4. 네트워크 테스트
echo "네트워크 연결 확인..."
ping -c 4 google.com

echo "=== 검증 완료 ==="
```

## 📝 복구 로그 템플릿

```markdown
## 재해 복구 로그
날짜: 2025-XX-XX
시나리오: [디스크 실패/시스템 장애/etc]

### 타임라인
- HH:MM - 문제 발견
- HH:MM - 원인 파악
- HH:MM - 복구 시작
- HH:MM - 복구 완료

### 영향받은 구성요소
- [ ] 디스크:
- [ ] 서비스:
- [ ] 데이터:

### 복구 절차
1. [수행한 작업]
2. [수행한 작업]

### 데이터 손실
- 없음 / [손실 내역]

### 개선 사항
- [향후 예방 조치]
- [백업 전략 수정]

### 소요 시간
- 총 다운타임: XX시간
- 완전 복구: XX시간
```

## ⚡ 비상 연락처

### 하드웨어 지원
- WD 지원: 1588-6730
- Seagate 지원: 080-001-1004
- 로컬 컴퓨터 매장: XXX-XXXX

### 데이터 복구 서비스
- 전문 복구 업체 1: XXX-XXXX
- 전문 복구 업체 2: XXX-XXXX

### Unraid 지원
- 포럼: https://forums.unraid.net
- Discord: https://discord.gg/unraid
- Reddit: r/unraid

## ✅ 복구 준비 상태 체크리스트

### 백업
- [ ] USB 설정 백업 (주간)
- [ ] 중요 데이터 백업 (일일)
- [ ] 오프사이트 백업 (월간)

### 문서
- [ ] 하드웨어 구성 문서화
- [ ] 네트워크 설정 기록
- [ ] 복구 절차 인쇄본

### 예비 부품
- [ ] 예비 USB 드라이브
- [ ] SATA 케이블 여분
- [ ] 예비 디스크 (선택)

---

💡 **중요**: 복구 절차는 정기적으로 테스트하세요. 실제 재해 시에 처음 시도하면 실패할 가능성이 높습니다.

📅 **권장**: 분기별 복구 훈련 실시