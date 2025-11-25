# Unraid NAS 하드웨어 체크리스트

## 현재 보유 하드웨어 확인
- [x] CPU 모델 확인: Intel Core i3-14100T (4코어/8스레드, 35W TDP)
- [x] 메인보드 모델 확인: ASRock B760M Pro-A 7.03 (LGA1700)
- [x] RAM 용량 확인: 64GB (Team Group DDR5-5600 32GB × 2)
- [x] HDD 확인: TOSHIBA DT01ACA300 3TB × 3개
- [x] SSD 확인: SanDisk 500GB SATA
- [x] NVMe 확인: XPG GAMMIX S11 Pro 1TB (M.2 2280)
- [x] GPU (내장): Intel UHD Graphics 730 (Quick Sync 지원)
- [x] GPU (외장): NVIDIA GeForce GTX 1050 2GB (NVENC 지원)

## BIOS 설정 체크리스트 (ASRock B760M Pro-A)
- [ ] SATA 모드: AHCI 설정 (Advanced → Storage Configuration)
- [ ] Intel VT-d: 활성화 (Advanced → CPU Configuration)
- [ ] Intel VT-x: 활성화 (가상화 지원)
- [ ] C-States: 활성화 (저전력 35W TDP 활용)
- [ ] 부팅 우선순위: USB 첫번째 (Boot → Boot Priority)
- [ ] AC 전원 복구: 전원 켜기 (Advanced → ACPI Configuration)
- [ ] Wake-on-LAN: 활성화 (선택사항)

## 구매 필요 항목
- [ ] USB 드라이브 (4-32GB, SanDisk 제외 권장)
- [ ] 외장 HDD 9-12TB (백업용, 선택사항)
- [ ] SATA 케이블 추가 (필요시)
- [ ] 케이스 팬 (냉각 개선용, 선택사항)

## 네트워크 환경
- [ ] 기가비트 이더넷 확인
- [ ] 고정 IP 할당 계획: 192.168.___.___
- [ ] 포트포워딩 필요 포트 확인

## 전원 관리
- [ ] UPS 보유 여부: _______________
- [ ] 예상 전력 소비: 45-110W (CPU 35W + GPU 75W + 디스크)
  - 유휴: 약 45W
  - 평균: 약 65W
  - 최대: 약 110W (GPU 풀로드)
- [ ] 24시간 운영 가능 환경 확인
- [ ] 월 예상 전기료: 약 14,000원 (65W 평균 24/7 운영 시)