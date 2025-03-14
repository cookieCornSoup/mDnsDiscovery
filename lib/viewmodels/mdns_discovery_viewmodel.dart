import 'package:flutter/material.dart';
import 'package:bonsoir/bonsoir.dart';
import 'package:mdns_connection_test/helpers/network_helpers.dart';
import '../constants/network_constants.dart';

class MdnsDiscoveryViewModel extends ChangeNotifier {
  final Map<String, List<BonsoirService>> _discoveredServices = {};
  BonsoirDiscovery? _discovery;
  bool _isDiscovering = false;
  bool _isSearching = false;
  String _serviceType = NetworkConstants.mdnsTypeHttp;

  Map<String, List<BonsoirService>> get discoveredServices => _discoveredServices;
  bool get isDiscovering => _isDiscovering;
  bool get isSearching => _isSearching;
  String get serviceType => _serviceType;

  /// 🔥 TCP 타입 설정 (입력 시 자동 재검색)
  void setServiceType(String type) {
    _serviceType = type.isNotEmpty ? type : NetworkConstants.mdnsTypeHttp;
    if (_isDiscovering) {
      stopDiscovery();
      startDiscovery();
    }
    notifyListeners();
  }

  /// 🔥 mDNS 검색 시작 (기존 데이터 삭제 후 재검색)
  Future<void> startDiscovery() async {
    if (_isDiscovering) return;
    _isDiscovering = true;
    _isSearching = true;

    _discoveredServices.clear();
    notifyListeners();

    await _initializeDiscovery();
    _subscribeToDiscoveryEvents();
    await _discovery?.start();
  }

  Future<void> _initializeDiscovery() async {
    _discovery = BonsoirDiscovery(type: _serviceType);
    await _discovery!.ready;
  }

  void _subscribeToDiscoveryEvents() {
    _discovery?.eventStream?.listen((BonsoirDiscoveryEvent event) {
      _handleDiscoveryEvent(event);
    });
  }

  void _handleDiscoveryEvent(BonsoirDiscoveryEvent event) {
    if (event.service == null) return;
    final String serviceType = event.service!.type;

    _discoveredServices.putIfAbsent(serviceType, () => []);

    if (event.type == BonsoirDiscoveryEventType.discoveryServiceFound) {
      _addServiceIfNotDuplicate(serviceType, event.service!); // 🔥 중복 체크 후 추가
    } else if (event.type == BonsoirDiscoveryEventType.discoveryServiceResolved) {
      _resolveService(event);
    }

    _isSearching = false;
    notifyListeners();
  }

  /// 🔥 중복되지 않는 경우에만 리스트에 추가
  void _addServiceIfNotDuplicate(String serviceType, BonsoirService service) {
    final List<BonsoirService> services = _discoveredServices[serviceType]!;

    bool isDuplicate = services.any((existingService) =>
        existingService.name == service.name &&
        existingService.port == service.port &&
        existingService.attributes.toString() == service.attributes.toString());

    if (!isDuplicate) {
      services.add(service);
    }
  }

  void _resolveService(BonsoirDiscoveryEvent event) {
    if (event.service is! ResolvedBonsoirService) return;

    ResolvedBonsoirService service = event.service as ResolvedBonsoirService;
    final String serviceType = service.type;

    if (!_discoveredServices.containsKey(serviceType)) return;

    List<BonsoirService> services = _discoveredServices[serviceType]!;

    services.removeWhere((foundService) => foundService.name == service.name);

    if (NetworkHelper.isIPv4(service.host!)) {
      _addServiceIfNotDuplicate(serviceType, service);
      service.resolve(_discovery!.serviceResolver);
    }

    services.sort((a, b) => a.name.compareTo(b.name));
  }

  /// 🔥 mDNS 검색 중지 (리스트 유지)
  void stopDiscovery() {
    if (!_isDiscovering) return;
    _isDiscovering = false;
    _isSearching = false;
    _discovery?.stop();
    notifyListeners();
  }

  @override
  void dispose() {
    stopDiscovery();
    super.dispose();
  }
}
