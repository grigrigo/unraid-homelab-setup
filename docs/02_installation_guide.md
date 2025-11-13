# Unraid NAS 설치 가이드

## Phase 1: USB 부팅 드라이브 생성

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

## Phase 2: 초기 부팅

### 2.1 부팅 준비
- [ ] USB 드라이브 삽입
- [ ] BIOS 부팅 순서 확인
- [ ] 네트워크 케이블 연결

### 2.2 첫 부팅
- [ ] Unraid 부팅 화면 확인
- [ ] IP 주소 메모: _______________
- [ ] 브라우저 접속: http://[IP주소]

## Phase 3: 초기 설정

### 3.1 기본 설정
- [ ] 시간대: Asia/Seoul
- [ ] 키보드: Korean
- [ ] 호스트명: Tower (또는 원하는 이름)

### 3.2 디스크 할당 (싱글 패리티)
```
Parity: 3TB HDD #1
Disk 1: 3TB HDD #2
Disk 2: 3TB HDD #3
Disk 3: 3TB HDD #4
Cache:  500GB SSD
```

### 3.3 Array 시작
- [ ] Start Array 클릭
- [ ] Format 체크박스 선택 (새 디스크)
- [ ] Format 시작 (약 40-80분)
- [ ] 패리티 동기화 시작 (6-12시간)

## Phase 4: 공유 폴더 생성

### 4.1 기본 공유 폴더
| 이름 | Cache 사용 | 용도 |
|------|-----------|------|
| Media | Yes | 미디어 파일 |
| Photos | Yes | 사진 저장 |
| Backups | No | 백업 파일 |
| appdata | Prefer | Docker 데이터 |
| domains | Prefer | VM 디스크 |

### 4.2 SMB 설정
- [ ] Settings → SMB → Enable SMB: Yes
- [ ] Workgroup: WORKGROUP
- [ ] Local Master: Yes

## 완료 체크리스트
- [ ] Array 정상 작동
- [ ] 패리티 동기화 진행 중
- [ ] 웹 UI 접속 가능
- [ ] SMB 공유 접근 가능
- [ ] 기본 공유 폴더 생성 완료