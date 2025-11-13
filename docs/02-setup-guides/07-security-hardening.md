# Unraid 보안 강화 가이드

## 1. 기본 보안 설정

### 1.1 계정 관리
- [ ] Root 비밀번호 설정 (16자 이상)
  - 대소문자 + 숫자 + 특수문자 조합
  - 설정 → 사용자 → root

- [ ] 일반 사용자 생성
  ```
  설정 → 사용자 → 사용자 추가
  - 사용자명: _______________
  - 비밀번호: _______________
  - SMB 접근: 예
  ```

### 1.2 SSH 보안
- [ ] SSH 키 생성
  ```bash
  ssh-keygen -t ed25519 -C "unraid@home"
  ```
- [ ] 설정 → SSH
  - SSH 키 사용: 예
  - Root 로그인 허용: 아니오
  - 비밀번호 인증: 아니오

## 2. 네트워크 보안

### 2.1 방화벽 설정 (UFW 플러그인)
```bash
# 필수 포트만 열기
ufw default deny incoming
ufw default allow outgoing
ufw allow 80/tcp    # 웹 UI
ufw allow 443/tcp   # SSL
ufw allow 445/tcp   # SMB
ufw allow 22/tcp    # SSH
ufw enable
```

### 2.2 SSL/TLS 설정
- [ ] Let's Encrypt 플러그인 설치
  ```
  앱 → "Let's Encrypt" 검색 → 설치
  ```
- [ ] 설정
  - 도메인: _______________
  - 이메일: _______________
  - 포트: 443

## 3. 접근 제어

### 3.1 2단계 인증 (2FA) 설정
- [ ] Google Authenticator 플러그인 설치
- [ ] 각 사용자별 2FA 활성화
  - 설정 → 사용자 → [사용자명] → 2FA

### 3.2 Fail2Ban 설치
```yaml
Docker 컨테이너 설정:
- 이름: fail2ban
- 리포지토리: crazymax/fail2ban
- 네트워크: 호스트
- 권한: 예
```

## 4. 외부 접속 솔루션

### 4.1 Tailscale (권장)
- [ ] Tailscale 앱 설치
  ```
  앱 → "Tailscale" 검색 → 설치
  ```
- [ ] 계정 연결
- [ ] 디바이스 승인

### 4.2 Cloudflare Tunnel (대안)
- [ ] Cloudflared 설치
- [ ] 터널 생성
- [ ] 도메인 연결

## 5. 모니터링

### 5.1 알림 설정
- [ ] 설정 → 알림
  - 방법: 이메일 / Discord / Telegram
  - 이벤트:
    - [x] 어레이 오류
    - [x] 디스크 오류
    - [x] 고온
    - [x] 패리티 체크 완료

### 5.2 로그 모니터링
- [ ] 정기적 로그 확인 일정
  - 도구 → 시스템 로그
  - 주간 점검 스케줄

## 보안 체크리스트

### 필수 (1주차)
- [ ] Root 비밀번호 변경
- [ ] 일반 사용자 생성
- [ ] 방화벽 활성화
- [ ] 알림 설정

### 권장 (2주차)
- [ ] SSL 인증서 적용
- [ ] 2FA 활성화
- [ ] SSH 키 인증
- [ ] VPN 설정 (Tailscale)

### 선택 (3주차)
- [ ] Fail2Ban 설정
- [ ] VLAN 분리
- [ ] IDS/IPS 구성