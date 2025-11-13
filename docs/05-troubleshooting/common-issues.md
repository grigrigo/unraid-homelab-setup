# 🔧 일반적인 문제 해결

Unraid 운영 중 자주 발생하는 문제와 해결 방법

---

## 🚨 긴급도별 분류

### 🔴 긴급 (데이터 손실 위험)
- 다중 디스크 오류
- 패리티 + 데이터 디스크 실패
- 파일 시스템 손상
- 랜섬웨어 감염

### 🟡 중요 (서비스 중단)
- 웹 UI 접속 불가
- Docker 서비스 중단
- 네트워크 연결 끊김
- 어레이 시작 실패

### 🟢 일반 (성능/기능 문제)
- 느린 전송 속도
- Docker 컨테이너 오류
- 팬 소음 문제
- 알림 오작동

## 📝 문제 해결 체크리스트

### 문제 발생 시 첫 단계
1. **침착함 유지** - 성급한 조치는 상황 악화
2. **현상 기록** - 스크린샷, 에러 메시지
3. **로그 확인** - Tools → Diagnostics
4. **백업 확인** - 중요 데이터 안전 확보
5. **포럼 검색** - 유사 사례 찾기

## 🔍 주요 문제 및 해결법

## 1. 부팅 문제

### 1.1 Unraid가 부팅되지 않음

#### 증상
- 검은 화면
- "Missing operating system"
- 부팅 루프

#### 진단
```bash
# BIOS 설정 확인
- Boot Mode: UEFI
- Boot Device: USB
- Secure Boot: Disabled
- SATA Mode: AHCI
```

#### 해결 방법
```markdown
1. USB 드라이브 확인
   - 다른 USB 포트 시도
   - USB 2.0 포트 사용
   - 내부 USB 포트 사용

2. USB 재생성
   - 백업에서 config 복원
   - GUID 유지 중요

3. BIOS 초기화
   - Load Optimized Defaults
   - 필수 설정 재적용
```

### 1.2 부팅 후 IP 주소를 모름

#### 해결 방법
```bash
# 방법 1: 콘솔에서 확인
# 모니터 연결 후
ifconfig eth0

# 방법 2: 라우터에서 확인
# DHCP 클라이언트 목록에서 "Tower" 찾기

# 방법 3: 네트워크 스캔
nmap -sn 192.168.1.0/24
arp -a
```

## 2. 어레이 문제

### 2.1 어레이가 시작되지 않음

#### 증상
```
"Array Stopped. Missing disk(s)"
"Wrong or missing key"
```

#### 진단 스크립트
```bash
# 디스크 상태 확인
ls -la /dev/disk/by-id/

# 어레이 구성 확인
cat /boot/config/super.dat

# 디스크 할당 확인
cat /boot/config/disk.cfg
```

#### 해결 방법
```markdown
1. Tools → New Config
   - Preserve current assignments: All
   - 디스크 재할당
   - Trust Parity 주의!

2. 디스크 순서 문제
   - SATA 케이블 확인
   - 디스크 시리얼 번호 매칭
```

### 2.2 패리티 체크 오류

#### 증상
```
"Parity sync errors: 1234"
"Sync errors corrected"
```

#### 원인 분석
```bash
# 오류 위치 확인
cat /var/log/syslog | grep "parity"

# SMART 상태 확인
smartctl -a /dev/sdX | grep -E "Error|Reallocated|Pending"
```

#### 해결 방법
```markdown
1. 단일 오류 (< 100)
   - 정상 범위, 모니터링 지속

2. 다수 오류 (> 1000)
   - 메모리 테스트 실행
   - 케이블 교체
   - 디스크 SMART 확인

3. 지속적 증가
   - 디스크 교체 준비
   - 백업 우선 실행
```

## 3. 디스크 문제

### 3.1 디스크 SMART 경고

#### 중요 SMART 속성
```bash
# 위험 신호
ID 5: Reallocated_Sector_Ct > 0
ID 187: Reported_Uncorrect > 0
ID 197: Current_Pending_Sector > 0
ID 198: Offline_Uncorrectable > 0

# 확인 명령
smartctl -A /dev/sdX | grep -E "^  5|^187|^197|^198"
```

#### 조치 단계
```markdown
1. 즉시 백업
2. Extended SMART 테스트
   smartctl -t long /dev/sdX
3. 테스트 결과 확인 (4-8시간 후)
   smartctl -a /dev/sdX
4. 실패 시 디스크 교체
```

### 3.2 디스크 온도 높음

#### 임계 온도
- HDD: > 45°C 주의, > 50°C 위험
- SSD: > 70°C 주의

#### 냉각 개선
```bash
# 팬 설정 조정
# Settings → Fan Control (Dynamix plugin)

# 스크립트 예제
#!/bin/bash
TEMP=$(smartctl -A /dev/sda | grep Temperature | awk '{print $10}')
if [ $TEMP -gt 45 ]; then
    echo "100" > /sys/class/hwmon/hwmon2/pwm1
fi
```

## 4. Docker 문제

### 4.1 Docker 서비스 시작 안 됨

#### 진단
```bash
# Docker 로그 확인
tail -f /var/log/docker.log

# 이미지 위치 확인
ls -la /mnt/cache/appdata/
df -h /mnt/cache
```

#### 일반적인 원인 및 해결
```markdown
1. 캐시 드라이브 꽉 참
   - Mover 실행
   - 불필요한 파일 삭제
   - 캐시 용량 증설

2. docker.img 손상
   - Settings → Docker → Stop
   - docker.img 삭제
   - Docker 재시작 (재생성)
   - 컨테이너 재설치

3. 권한 문제
   chmod -R 777 /mnt/cache/appdata
```

### 4.2 컨테이너 시작 실패

#### 로그 확인
```bash
# 컨테이너 로그
docker logs [container_name]

# 전체 상태
docker ps -a

# 리소스 사용
docker stats
```

#### 일반적인 수정
```bash
# 컨테이너 재시작
docker restart [container_name]

# 이미지 재다운로드
docker pull [image_name]
docker stop [container_name]
docker rm [container_name]
# Community Apps에서 재설치

# 네트워크 재설정
docker network prune
```

## 5. 네트워크 문제

### 5.1 웹 UI 접속 불가

#### 진단 절차
```bash
# 1. Ping 테스트
ping [unraid_ip]

# 2. 포트 확인
nmap -p 80,443 [unraid_ip]

# 3. 서비스 상태 (콘솔에서)
/etc/rc.d/rc.nginx status
```

#### 해결 방법
```bash
# nginx 재시작
/etc/rc.d/rc.nginx restart

# 네트워크 재시작
/etc/rc.d/rc.inet1 restart

# 방화벽 확인
iptables -L -n
```

### 5.2 SMB 공유 접속 불가

#### Windows에서 확인
```cmd
# SMB 프로토콜 확인
Get-SmbServerConfiguration | Select EnableSMB2Protocol

# 자격 증명 초기화
net use * /delete
cmdkey /delete:unraid_ip
```

#### Unraid 설정
```bash
# SMB 설정 확인
cat /etc/samba/smb.conf

# SMB 재시작
/etc/rc.d/rc.samba restart

# 로그 확인
tail -f /var/log/samba/log.smbd
```

## 6. 성능 문제

### 6.1 느린 전송 속도

#### 진단 도구
```bash
# 네트워크 속도 테스트
iperf3 -s  # 서버 모드
iperf3 -c [unraid_ip] -t 30  # 클라이언트

# 디스크 속도 테스트
dd if=/dev/zero of=/mnt/disk1/test bs=1M count=10000

# 캐시 상태 확인
df -h /mnt/cache
```

#### 최적화
```markdown
1. Turbo Write 모드
   - Settings → Disk Settings
   - Tunable (md_write_method): reconstruct write

2. 네트워크 최적화
   - Jumbo Frames (MTU 9000)
   - Link Aggregation

3. 캐시 활용
   - Share Settings → Use cache: Yes
   - Mover 스케줄 조정
```

### 6.2 높은 CPU 사용률

#### 프로세스 확인
```bash
# CPU 사용 Top 10
top -b -n 1 | head -20

# 특정 프로세스 추적
pidstat -u -p [PID] 1

# Docker 컨테이너별
docker stats --no-stream
```

#### 해결 방법
```bash
# CPU 제한 설정
docker update --cpus="2.0" [container]

# Nice 값 조정
renice -n 10 -p [PID]
```

## 7. 하드웨어 문제

### 7.1 갑작스런 재부팅/종료

#### 로그 분석
```bash
# 마지막 부팅 원인
last reboot
dmesg | grep -i "machine check"

# 온도 확인
sensors
cat /sys/class/thermal/thermal_zone*/temp
```

#### 일반적인 원인
```markdown
1. 과열
   - CPU/케이스 쿨러 점검
   - 써멀 구리스 재도포

2. 전원 문제
   - PSU 용량 확인
   - UPS 상태 확인
   - 전압 변동 모니터링

3. 메모리 오류
   - Memtest86+ 실행
   - 슬롯 변경 시도
```

## 8. 백업/복구 문제

### 8.1 백업 실패

#### 공통 원인
```bash
# 공간 부족
df -h /mnt/user/backups

# 권한 문제
ls -la /mnt/user/backups

# 프로세스 확인
ps aux | grep rsync
```

#### 스크립트 디버깅
```bash
#!/bin/bash
# 디버그 모드 실행
set -x  # 명령 출력
set -e  # 오류 시 중단

# 로그 파일 생성
exec 1>/tmp/backup.log 2>&1
```

## 🛠️ 진단 도구

### 시스템 진단 패키지 생성
```bash
# Tools → Diagnostics
# "Download" 클릭
# anonymize 옵션 (포럼 공유 시)
```

### 포함 내용
- 시스템 로그
- Docker 로그
- 설정 파일
- SMART 정보
- 네트워크 구성

## 📊 모니터링 명령 모음

### 실시간 모니터링
```bash
# 시스템 리소스
htop

# 디스크 I/O
iotop -o

# 네트워크
iftop

# 로그 추적
tail -f /var/log/syslog

# 온도
watch -n 1 sensors
```

### 상태 확인 스크립트
```bash
#!/bin/bash
echo "=== System Status ==="
echo "Uptime: $(uptime)"
echo "Memory: $(free -h | grep Mem)"
echo "Disk Usage:"
df -h | grep -E "mnt|cache"
echo "Docker Containers:"
docker ps --format "table {{.Names}}\t{{.Status}}"
echo "Array Status:"
mdcmd status | grep "DISK_OK"
echo "Temperature:"
sensors | grep -E "Core|temp"
```

## 📚 추가 리소스

### 로그 파일 위치
```
/var/log/syslog        # 시스템 로그
/var/log/docker.log    # Docker 로그
/var/log/libvirt/      # VM 로그
/var/log/nginx/        # 웹 서버 로그
/var/log/samba/        # SMB 로그
/boot/logs/            # 부팅 로그
```

### 유용한 포럼 스레드
- [Unraid OS Common Problems](https://forums.unraid.net/topic/87144-common-problems/)
- [Fix Common Problems Plugin](https://forums.unraid.net/topic/46802-fix-common-problems/)
- [Diagnostics Guide](https://forums.unraid.net/topic/46802-diagnostics/)

## ✅ 예방 조치

### 정기 점검 (주간)
- [ ] 디스크 SMART 상태
- [ ] 어레이 상태
- [ ] Docker 업데이트
- [ ] 로그 오류 확인

### 정기 작업 (월간)
- [ ] 패리티 체크
- [ ] 캐시 정리
- [ ] 백업 테스트
- [ ] 플러그인 업데이트

### 모니터링 설정
- [ ] 알림 이메일/Discord
- [ ] SMART 알림
- [ ] 온도 임계값
- [ ] 디스크 공간 경고

---

💡 **팁**: 문제가 발생하기 전에 예방이 최선입니다. 정기적인 모니터링과 백업이 핵심입니다.

🆘 **도움 요청 시**: 항상 진단 파일과 함께 정확한 오류 메시지, 발생 시점, 시도한 해결 방법을 포함하세요.