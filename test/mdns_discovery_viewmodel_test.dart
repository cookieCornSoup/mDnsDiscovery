import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mdns_connection_test/viewmodels/mdns_discovery_viewmodel.dart';
import 'package:bonsoir/bonsoir.dart';
import 'package:mdns_connection_test/constants/network_constants.dart';

@GenerateMocks([BonsoirDiscovery])
import 'mdns_discovery_viewmodel_test.mocks.dart';

void main() {
  late MdnsDiscoveryViewModel viewModel;

  setUp(() {
    TestWidgetsFlutterBinding.ensureInitialized(); // 🔥 Binding 초기화
    viewModel = MdnsDiscoveryViewModel();
  });

  test('초기 상태 확인', () {
    expect(viewModel.isDiscovering, false);
    expect(viewModel.isSearching, false);
    expect(viewModel.serviceType, NetworkConstants.mdnsTypeHttp);
    expect(viewModel.discoveredServices.isEmpty, true);
  });

  test('검색 시작 시 상태 변경 확인', () async {
    await viewModel.startDiscovery();

    expect(viewModel.isDiscovering, true);
    expect(viewModel.isSearching, true);
  });

  test('검색 중지 시 상태 변경 확인', () async {
    await viewModel.startDiscovery();
    viewModel.stopDiscovery();

    expect(viewModel.isDiscovering, false);
    expect(viewModel.isSearching, false);
  });

  test('중복 서비스가 추가되지 않는지 확인', () {
    final service1 = BonsoirService(name: "Test Service", type: "_http._tcp", port: 8080);
    final service2 = BonsoirService(name: "Test Service", type: "_http._tcp", port: 8080);

    viewModel.startDiscovery();
    viewModel.setServiceType("_http._tcp");

    viewModel.discoveredServices["_http._tcp"] = [service1];
    viewModel.discoveredServices["_http._tcp"]!.add(service2);

    expect(viewModel.discoveredServices["_http._tcp"]!.length, 1); // 🔥 중복 추가 방지 확인
  });

  test('TCP 타입 변경 시 자동 재검색', () {
    viewModel.setServiceType("_ipp._tcp");
    expect(viewModel.serviceType, "_ipp._tcp");
    expect(viewModel.isDiscovering, true);
  });
}
