# Unraid NAS 설치 가이드

## 1단계: USB 부팅 드라이브 생성

### 1.1 준비물
- [ ] USB 드라이브 (4-32GB)
- [ ] Unraid USB Creator
- [ ] Windows/Mac/Linux PC

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
- [ ] config 폴더 생성 확인
- [ ] GUID 할당 확인
- [ ] 트라이얼 키 자동 생성

## 2단계: 초기 부팅

### 2.1 부팅 준비
- [ ] USB 드라이브 삽입
- [ ] BIOS 부팅 순서 확인
- [ ] 네트워크 케이블 연결

### 2.2 첫 부팅
- [ ] Unraid 부팅 화면 확인
- [ ] IP 주소 메모: _______________
- [ ] 브라우저 접속: http://[IP주소]

## 3단계: 초기 설정

### 3.1 기본 설정
- [ ] 시간대: Asia/Seoul
- [ ] 키보드: Korean
- [ ] 호스트명: Tower (또는 원하는 이름)

### 3.2 디스크 할당 옵션

#### 옵션 1: 패리티 보호 구성 (권장)
```
패리티: TOSHIBA 3TB HDD #1
디스크 1: TOSHIBA 3TB HDD #2
디스크 2: TOSHIBA 3TB HDD #3
캐시 1: SanDisk 500GB SSD
캐시 2: XPG GAMMIX S11 Pro 1TB NVMe
```
- 총 용량: 6TB (보호됨)
- 패리티로 1개 디스크 실패 시 복구 가능

#### 옵션 2: 최대 용량 구성 (패리티 없음)
```
디스크 1: TOSHIBA 3TB HDD #1
디스크 2: TOSHIBA 3TB HDD #2
디스크 3: TOSHIBA 3TB HDD #3
캐시 1: SanDisk 500GB SSD
캐시 2: XPG GAMMIX S11 Pro 1TB NVMe
```
- 총 용량: 9TB (보호 없음)
- ⚠️ 디스크 실패 시 데이터 손실

#### 캐시 풀 구성
```
캐시 풀 옵션:
1. SSD + NVMe BTRFS RAID1 (미러링, 500GB 용량)
2. SSD + NVMe 개별 사용 (1.5TB 용량)
3. NVMe만 캐시로 사용 (SSD는 앱 전용)
```

### 3.3 어레이 시작
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