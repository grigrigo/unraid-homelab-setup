# Unraid 백업 전략 가이드

## 3-2-1 백업 원칙
- **3개** 데이터 복사본 (원본 + 백업 2개)
- **2개** 다른 미디어 타입
- **1개** 오프사이트 보관

## 1. 로컬 백업 (외장 HDD)

### 1.1 하드웨어 준비
- [ ] 12TB 외장 HDD 구매
- [ ] USB 3.0 연결 확인
- [ ] Unassigned Devices 플러그인 설치

### 1.2 자동 백업 스크립트
```bash
#!/bin/bash
# /mnt/user/scripts/backup_to_usb.sh

# 백업 시작 알림
/usr/local/emhttp/webGui/scripts/notify \
  -s "Backup Started" \
  -d "USB backup started at $(date)"

# rsync 백업
rsync -av --progress --delete \
  --exclude 'downloads/*' \
  --exclude '.Recycle.Bin/*' \
  /mnt/user/Photos \
  /mnt/user/Documents \
  /mnt/user/Backups \
  /mnt/disks/External_12TB/

# 백업 완료 알림
if [ $? -eq 0 ]; then
  /usr/local/emhttp/webGui/scripts/notify \
    -s "Backup Complete" \
    -d "USB backup finished successfully"
else
  /usr/local/emhttp/webGui/scripts/notify \
    -s "Backup Failed" \
    -d "USB backup failed with errors"
fi
```

### 1.3 스케줄 설정
```
User Scripts 플러그인:
- Schedule: Weekly (Sunday 2AM)
- Run in background: Yes
```

## 2. 클라우드 백업 (Backblaze B2)

### 2.1 Backblaze B2 설정
- [ ] B2 계정 생성
- [ ] 버킷 생성: unraid-backup
- [ ] Application Key 생성

### 2.2 Duplicati 설정
```yaml
백업 작업 생성:
1. Destination:
   - Storage Type: B2 Cloud Storage
   - Bucket: unraid-backup
   - B2 Cloud Storage ID: [YOUR_ID]
   - B2 Application Key: [YOUR_KEY]

2. Source Data:
   - /mnt/user/Photos
   - /mnt/user/Documents
   - /mnt/user/appdata (선택)

3. Schedule:
   - Run: Weekly
   - Time: Monday 3AM

4. Options:
   - Encryption: AES-256
   - Backup retention: 30 days
   - Upload volume size: 50MB
```

### 2.3 비용 계산
```
싱글 패리티 (9TB):
- 저장: $0.006/GB/월 × 9000GB = $54/월
- 다운로드: $0.01/GB (복원 시에만)

듀얼 패리티 (6TB):
- 저장: $0.006/GB/월 × 6000GB = $36/월
- 다운로드: $0.01/GB (복원 시에만)
```

## 3. 데이터 우선순위

### 3.1 백업 우선순위 매트릭스
| 우선순위 | 데이터 유형 | 로컬 백업 | 클라우드 백업 | 빈도 |
|---------|------------|----------|------------|------|
| P1 | 가족 사진/동영상 | ✅ | ✅ | 일일 |
| P1 | 중요 문서 | ✅ | ✅ | 일일 |
| P2 | 프로젝트 파일 | ✅ | ✅ | 주간 |
| P3 | Docker appdata | ✅ | ⚪ | 주간 |
| P4 | 미디어 파일 | ✅ | ❌ | 월간 |
| P5 | 다운로드 | ❌ | ❌ | - |

### 3.2 예상 백업 크기
```
P1 데이터: ~500GB
P2 데이터: ~200GB
P3 데이터: ~50GB
P4 데이터: ~5TB
-------------------
총 클라우드 백업: ~750GB
총 로컬 백업: ~6TB
```

## 4. 스냅샷 백업 (BTRFS)

### 4.1 BTRFS 스냅샷 스크립트
```bash
#!/bin/bash
# /mnt/user/scripts/btrfs_snapshot.sh

DATE=$(date +%Y%m%d_%H%M%S)
SNAPSHOT_DIR="/mnt/cache/snapshots"

# 스냅샷 디렉토리 생성
mkdir -p $SNAPSHOT_DIR

# appdata 스냅샷
btrfs subvolume snapshot -r \
  /mnt/cache/appdata \
  $SNAPSHOT_DIR/appdata_$DATE

# 30일 이상된 스냅샷 삭제
find $SNAPSHOT_DIR -maxdepth 1 -mtime +30 -type d \
  -exec btrfs subvolume delete {} \;
```

### 4.2 스케줄
```
User Scripts:
- Schedule: Daily (4AM)
- Run in background: Yes
```

## 5. 백업 검증

### 5.1 월간 복원 테스트
```bash
#!/bin/bash
# /mnt/user/scripts/backup_verify.sh

# 테스트 복원 디렉토리
TEST_DIR="/mnt/user/test_restore"
mkdir -p $TEST_DIR

# 샘플 파일 복원
duplicati restore \
  --source=b2://unraid-backup \
  --target=$TEST_DIR \
  --sample-file=Photos/sample.jpg

# 체크섬 검증
ORIGINAL_MD5=$(md5sum /mnt/user/Photos/sample.jpg | cut -d' ' -f1)
RESTORED_MD5=$(md5sum $TEST_DIR/Photos/sample.jpg | cut -d' ' -f1)

if [ "$ORIGINAL_MD5" == "$RESTORED_MD5" ]; then
  echo "Backup verification successful"
  /usr/local/emhttp/webGui/scripts/notify \
    -s "Backup Verified" \
    -d "Monthly backup verification passed"
else
  echo "Backup verification failed"
  /usr/local/emhttp/webGui/scripts/notify \
    -s "Backup Verification Failed" \
    -d "Please check backup integrity"
fi

# 정리
rm -rf $TEST_DIR
```

## 6. 재해 복구 계획

### 6.1 복구 시나리오
| 시나리오 | 복구 방법 | 예상 시간 |
|---------|----------|----------|
| 단일 파일 삭제 | Recycle Bin | 즉시 |
| Docker 컨테이너 손상 | BTRFS 스냅샷 | 5분 |
| 단일 디스크 실패 | 패리티 재구축 | 6-12시간 |
| 2개 디스크 실패 (듀얼) | 패리티 재구축 | 12-24시간 |
| 전체 시스템 손실 | 클라우드 복원 | 1-3일 |

### 6.2 USB 부팅 드라이브 백업
```bash
# config 폴더 백업
cp -r /boot/config /mnt/user/Backups/unraid_config_$(date +%Y%m%d)

# 압축
tar -czf /mnt/user/Backups/unraid_config_$(date +%Y%m%d).tar.gz \
  /boot/config
```

## 7. 백업 체크리스트

### 일일
- [ ] 중요 데이터 자동 백업 확인
- [ ] BTRFS 스냅샷 생성

### 주간
- [ ] 외장 HDD 백업 실행
- [ ] 클라우드 백업 상태 확인

### 월간
- [ ] 백업 복원 테스트
- [ ] 백업 용량 확인
- [ ] 클라우드 비용 확인

### 분기별
- [ ] 전체 백업 전략 검토
- [ ] 재해 복구 시뮬레이션
- [ ] USB 부팅 드라이브 백업