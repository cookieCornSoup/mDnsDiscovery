🚀 이 프로젝트는 Bonsoir를 이용한 mDNS 검색 기능을 테스트하며, 네트워크에서 동적으로 추가/제거되는 서비스를 탐색하고 관리하는 기능을 구현합니다.

⸻

📖 프로젝트 개요

이 프로젝트는 Bonsoir 패키지를 활용하여 mDNS(Multicast DNS) 검색 기능을 테스트하고,
네트워크 내에서 실시간으로 서비스가 추가되거나 삭제되는 것을 감지하는 기능을 구현합니다.

또한, Flutter의 Provider 패턴과 flutter_screenutil을 사용하여 반응형 UI를 지원합니다.

⸻

🚀 주요 기능

🌐 네트워크 (network)
•	mDNS 검색 (Multicast DNS)
•	네트워크 내에서 동적으로 서비스가 추가되거나 사라지는 프로토콜
•	지속적인 네트워크 모니터링이 필요하여 이벤트 스트림 (eventStream) 방식으로 구현
•	BonsoirDiscovery를 활용하여 서비스 탐색
•	TCP 타입 검색 기능
•	기본 검색 타입은 _http._tcp (NetworkConstants.mdnsTypeHttp)
•	사용자가 직접 TCP 타입 입력 가능 (_ipp._tcp, _airplay._tcp 등)
•	입력 변경 시 자동으로 재검색

⸻

🖥️ UI (view)
•	flutter_screenutil을 활용한 반응형 디자인 적용
•	다양한 해상도에서 일관된 UI 유지 (ScreenUtilInit 사용)
•	리스트 아이템 및 버튼 크기를 반응형으로 조정
•	검색 상태에 따른 UI 변화
•	검색 중: CircularProgressIndicator() 표시
•	검색 결과 없음: "No services found" 메시지 출력
•	서비스 목록: ListView로 동적 업데이트
•	버튼 및 UX 개선
•	검색 시작/중지 버튼 (FloatingActionButton.extended)
•	상단 앱바에서 TCP 타입 변경 (IconButton → TextField 팝업)

⸻

🛠️ 상태 관리 (State Management)
•	Provider를 활용한 ViewModel 패턴 적용
•	MdnsDiscoveryViewModel을 ChangeNotifier로 관리
•	MultiProvider를 통해 전역 상태 관리
•	UI와 비즈니스 로직 분리 (View ↔ ViewModel ↔ Network)
•	검색 유지 & 재검색 지원
•	stopDiscovery()를 실행해도 기존 검색 결과 유지
•	TCP 타입을 변경하면 자동으로 startDiscovery() 재실행
•	중복 검색 방지
•	_discoveredServices를 Map<String, List<BonsoirService>> 형태로 저장하여
동일한 서비스가 중복 저장되지 않도록 관리 (_addServiceIfNotDuplicate)

⸻

📂 프로젝트 구조

lib/
├── constants/
│   ├── network_constants.dart   # 네트워크 관련 상수 (기본 TCP 타입 등)
├── helpers/
│   ├── network_helpers.dart     # 네트워크 관련 유틸 함수 (IP 체크 등)
├── viewmodels/
│   ├── mdns_discovery_viewmodel.dart  # Provider 기반 ViewModel
├── screens/
│   ├── mdns_discovery_screen.dart    # UI 화면
├── main.dart


📦 사용된 패키지
|패키지|설명|
|------|---|
|bonsoir|mDns 서비스 검색|
|provider|ViewModel 상태 관리|
|flutter_screenutil|반응형 UI 지원|




📌 TODO (향후 개선 예정 기능)
•	검색된 서비스 클릭 시 상세 정보 표시
•	서비스 연결 시도 및 연결 상태 표시
•	검색 서비스 테스트 기능 추가
•	연결 테스트 기능 추가



🚀 이 프로젝트는 Bonjour/mDNS 기술을 활용한 네트워크 탐색 기능을 테스트하는 목적으로 개발되었습니다.
