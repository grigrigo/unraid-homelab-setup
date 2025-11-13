# Unraid 보안 강화 가이드

## 1. 기본 보안 설정

### 1.1 계정 관리
- [ ] Root 비밀번호 설정 (16자 이상)
  - 대소문자 + 숫자 + 특수문자 조합
  - Settings → Users → root

- [ ] 일반 사용자 생성
  ```
  Settings → Users → Add User
  - Username: _______________
  - Password: _______________
  - SMB Access: Yes
  ```

### 1.2 SSH 보안
- [ ] SSH 키 생성
  ```bash
  ssh-keygen -t ed25519 -C "unraid@home"
  ```
- [ ] Settings → SSH
  - Use SSH Keys: Yes
  - Permit Root Login: No
  - Password Authentication: No

## 2. 네트워크 보안

### 2.1 방화벽 설정 (UFW 플러그인)
```bash
# 필수 포트만 열기
ufw default deny incoming
ufw default allow outgoing
ufw allow 80/tcp    # Web UI
ufw allow 443/tcp   # SSL
ufw allow 445/tcp   # SMB
ufw allow 22/tcp    # SSH
ufw enable
```

### 2.2 SSL/TLS 설정
- [ ] Let's Encrypt 플러그인 설치
  ```
  Apps → "Let's Encrypt" → Install
  ```
- [ ] 설정
  - Domain: _______________
  - Email: _______________
  - Port: 443

## 3. 접근 제어

### 3.1 2FA 설정
- [ ] Google Authenticator 플러그인 설치
- [ ] 각 사용자별 2FA 활성화
  - Settings → Users → [username] → 2FA

### 3.2 Fail2Ban 설치
```yaml
Docker 컨테이너 설정:
- Name: fail2ban
- Repository: crazymax/fail2ban
- Network: Host
- Privileged: Yes
```

## 4. 외부 접속 솔루션

### 4.1 Tailscale (권장)
- [ ] Tailscale 앱 설치
  ```
  Apps → "Tailscale" → Install
  ```
- [ ] 계정 연결
- [ ] 디바이스 승인

### 4.2 Cloudflare Tunnel (대안)
- [ ] Cloudflared 설치
- [ ] 터널 생성
- [ ] 도메인 연결

## 5. 모니터링

### 5.1 알림 설정
- [ ] Settings → Notifications
  - Method: Email / Discord / Telegram
  - Events:
    - [x] Array errors
    - [x] Disk errors
    - [x] High temperature
    - [x] Parity check complete

### 5.2 로그 모니터링
- [ ] 정기적 로그 확인 일정
  - Tools → System Log
  - 주간 점검 스케줄

## 보안 체크리스트

### 필수 (Week 1)
- [ ] Root 비밀번호 변경
- [ ] 일반 사용자 생성
- [ ] 방화벽 활성화
- [ ] 알림 설정

### 권장 (Week 2)
- [ ] SSL 인증서 적용
- [ ] 2FA 활성화
- [ ] SSH 키 인증
- [ ] VPN 설정 (Tailscale)

### 선택 (Week 3)
- [ ] Fail2Ban 설정
- [ ] VLAN 분리
- [ ] IDS/IPS 구성