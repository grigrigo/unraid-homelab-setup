# 🔬 하드웨어 테스트 가이드

Unraid 설치 전 필수 하드웨어 검증 절차

---

## 📋 테스트 개요

하드웨어 문제는 데이터 손실의 주요 원인입니다. Unraid 설치 전 철저한 테스트로 문제를 사전에 발견하세요.

## 🧪 테스트 체크리스트

### Phase 1: 기본 점검 (1시간)
- [ ] 물리적 연결 확인
- [ ] POST 정상 부팅
- [ ] BIOS/UEFI 버전 확인
- [ ] 온도 모니터링

### Phase 2: 메모리 테스트 (8-24시간)
- [ ] Memtest86+ 실행
- [ ] 최소 2 pass 완료
- [ ] 오류 0개 확인

### Phase 3: 디스크 테스트 (24-48시간)
- [ ] SMART 상태 확인
- [ ] 배드블록 스캔
- [ ] 쓰기/읽기 테스트
- [ ] 온도 스트레스 테스트

### Phase 4: 시스템 안정성 (4-8시간)
- [ ] CPU 스트레스 테스트
- [ ] 전원 공급 안정성
- [ ] 네트워크 연결 테스트

## 1️⃣ 메모리 테스트 (Memtest86+)

### 준비물
- USB 드라이브 (512MB 이상)
- Memtest86+ 이미지

### 설치 및 실행

#### USB 생성
```bash
# Memtest86+ 다운로드
wget https://memtest.org/download/memtest86-usb.zip
unzip memtest86-usb.zip

# USB에 쓰기 (Linux/Mac)
sudo dd if=memtest86-usb.img of=/dev/sdX bs=4M status=progress

# Windows는 Rufus 사용
```

#### 테스트 실행
1. USB로 부팅
2. 기본 설정으로 시작
3. **최소 2 pass** 완료 대기 (8-12시간)
4. **Pass complete, no errors** 확인

### 🚨 실패 기준
- 오류 1개라도 발생 시 → RAM 교체
- 특정 슬롯에서만 오류 → 슬롯 또는 메인보드 문제
- 간헐적 오류 → 전원 또는 온도 문제 의심

## 2️⃣ 디스크 테스트

### A. SMART 정보 확인

#### Linux Live USB에서
```bash
# smartctl 설치
apt-get update && apt-get install smartmontools

# 디스크 목록 확인
lsblk

# SMART 정보 확인
smartctl -a /dev/sda

# 주요 체크 항목
smartctl -H /dev/sda  # 건강 상태
```

#### 주요 SMART 속성 확인
| ID | 속성 | 경고 기준 | 조치 |
|----|------|----------|------|
| 5 | Reallocated Sectors | > 0 | 주의 관찰 |
| 187 | Reported Uncorrectable | > 0 | 디스크 교체 고려 |
| 188 | Command Timeout | > 0 | 케이블/컨트롤러 확인 |
| 197 | Current Pending Sectors | > 0 | 배드블록 스캔 필요 |
| 198 | Offline Uncorrectable | > 0 | 디스크 교체 권장 |

### B. 배드블록 스캔

#### 읽기 전용 테스트 (안전)
```bash
# 진행 상황 표시와 함께 읽기 테스트
badblocks -sv /dev/sda

# 예상 시간: 3TB = 약 8-12시간
```

#### 쓰기 테스트 (데이터 삭제됨!)
```bash
# ⚠️ 경고: 모든 데이터가 삭제됩니다!
badblocks -wsv /dev/sda

# 4가지 패턴으로 전체 쓰기/읽기
# 예상 시간: 3TB = 약 24-36시간
```

### C. 디스크 스트레스 테스트

#### FIO를 사용한 성능 테스트
```bash
# FIO 설치
apt-get install fio

# 순차 쓰기 테스트
fio --name=sequential-write \
    --ioengine=posixaio \
    --rw=write \
    --bs=1M \
    --size=10G \
    --numjobs=1 \
    --runtime=1800 \
    --time_based \
    --filename=/dev/sda

# 랜덤 읽기/쓰기 테스트
fio --name=random-rw \
    --ioengine=posixaio \
    --rw=randrw \
    --bs=4k \
    --size=1G \
    --numjobs=4 \
    --runtime=1800 \
    --time_based \
    --filename=/dev/sda
```

### D. 온도 모니터링

테스트 중 온도 확인:
```bash
# HDD 온도 확인
smartctl -a /dev/sda | grep Temperature

# 또는 hddtemp 사용
apt-get install hddtemp
hddtemp /dev/sda

# 안전 온도 범위
# HDD: 25-45°C (권장)
# SSD: 0-70°C (최대)
```

⚠️ **경고 온도**:
- HDD > 50°C: 냉각 개선 필요
- HDD > 55°C: 즉시 중단
- SSD > 70°C: 히트싱크 필요

## 3️⃣ CPU 스트레스 테스트

### Prime95 테스트
```bash
# Prime95 다운로드 및 실행
wget https://www.mersenne.org/ftp_root/gimps/p95v308b15.linux64.tar.gz
tar -xzf p95v308b15.linux64.tar.gz
cd linux64
./mprime -t

# 옵션 선택
# Option 1: Small FFTs (최대 열 발생)
# 실행 시간: 최소 4시간
```

### 온도 모니터링
```bash
# lm-sensors 설치
apt-get install lm-sensors
sensors-detect

# 실시간 모니터링
watch -n 1 sensors

# 안전 온도
# CPU: < 80°C (Intel)
# CPU: < 85°C (AMD)
```

## 4️⃣ 전원 공급 장치(PSU) 테스트

### 전압 모니터링
```bash
# BIOS에서 확인
# Hardware Monitor 섹션

# Linux에서 확인
sensors | grep -E "in[0-9]"

# 허용 오차: ±5%
# +12V: 11.4V - 12.6V
# +5V: 4.75V - 5.25V
# +3.3V: 3.14V - 3.47V
```

### 부하 테스트
```bash
# 모든 디스크 동시 액세스
parallel -j 4 dd if=/dev/sd{} of=/dev/null bs=1M ::: a b c d

# CPU + GPU 동시 부하
mprime -t &  # CPU
glmark2 &    # GPU (if available)

# 10분간 유지 후 전압 확인
```

## 5️⃣ 네트워크 테스트

### 연결 안정성
```bash
# 지속적 ping 테스트
ping -i 0.2 192.168.1.1 > ping_test.log

# 1시간 후 패킷 손실 확인
grep "packet loss" ping_test.log

# 0% packet loss가 정상
```

### 속도 테스트
```bash
# iperf3 설치
apt-get install iperf3

# 서버 모드 (다른 PC에서)
iperf3 -s

# 클라이언트 모드 (테스트 PC에서)
iperf3 -c 192.168.1.x -t 300

# 기대 속도
# Gigabit: 900+ Mbps
# 2.5G: 2.3+ Gbps
# 10G: 9.4+ Gbps
```

## 📊 테스트 결과 기록

### 테스트 로그 양식
```markdown
## 하드웨어 테스트 결과
날짜: 2025-01-XX

### 메모리 테스트
- Memtest86+ 버전: X.X
- 테스트 시간: XX시간
- Pass 횟수: X
- 오류: 없음/있음
- 결과: ✅ 통과 / ❌ 실패

### 디스크 테스트
#### Disk 1 (모델명)
- SMART 상태: PASSED
- 배드블록: 0
- 평균 온도: XX°C
- 순차 읽기: XXX MB/s
- 순차 쓰기: XXX MB/s

### CPU 테스트
- Prime95 실행 시간: X시간
- 최고 온도: XX°C
- 오류: 없음
- 결과: ✅ 통과

### 전원 테스트
- +12V: XX.XV (✅ 정상)
- +5V: X.XV (✅ 정상)
- +3.3V: X.XV (✅ 정상)
- 부하 테스트: 통과

### 네트워크 테스트
- 패킷 손실: 0%
- 평균 속도: XXX Mbps
- 지터: X.X ms
```

## ⚠️ 문제 발견 시 조치

### 메모리 오류
1. 슬롯 변경 후 재테스트
2. 개별 모듈 테스트
3. BIOS 메모리 설정 확인 (전압, 타이밍)
4. 불량 모듈 교체

### 디스크 오류
1. SATA 케이블 교체
2. 다른 SATA 포트 시도
3. 펌웨어 업데이트 확인
4. RMA 또는 교체

### CPU 오류
1. 쿨러 재장착
2. 써멀 구리스 재도포
3. BIOS 설정 초기화
4. 전압 설정 확인

### 전원 문제
1. 케이블 연결 재확인
2. 다른 콘센트 시도
3. UPS 상태 확인
4. PSU 교체 고려

## ✅ 최종 체크리스트

### 테스트 통과 기준
- [ ] Memtest86+: 2 pass, 0 errors
- [ ] 모든 디스크 SMART: PASSED
- [ ] 배드블록: 0개
- [ ] CPU 스트레스: 4시간 무오류
- [ ] 디스크 온도: < 45°C
- [ ] CPU 온도: < 80°C
- [ ] 전압 변동: ±5% 이내
- [ ] 네트워크: 0% 패킷 손실

### 문서화
- [ ] 모든 테스트 결과 기록
- [ ] 하드웨어 시리얼 번호 기록
- [ ] SMART 초기값 백업
- [ ] BIOS 설정 스크린샷

## 🚀 다음 단계

모든 테스트를 통과했다면:

1. **[BIOS 설정](../02-setup-guides/01-bios-configuration.md)** - 최적 설정
2. **[USB 부팅 드라이브](../02-setup-guides/02-usb-boot-drive.md)** - Unraid 설치 준비
3. **[초기 설치](../02-setup-guides/03-initial-installation.md)** - Unraid 설치

---

💡 **팁**: 테스트는 시간이 걸리지만, 데이터 손실을 예방하는 가장 효과적인 방법입니다. 서두르지 마세요!

⏱️ **예상 총 소요 시간**: 2-3일 (연속 실행 시)