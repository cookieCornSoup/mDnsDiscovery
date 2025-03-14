import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import '../viewmodels/mdns_discovery_viewmodel.dart';

class MdnsDiscoveryScreen extends StatefulWidget {
  const MdnsDiscoveryScreen({super.key});

  @override
  State<MdnsDiscoveryScreen> createState() => _MdnsDiscoveryScreenState();
}

class _MdnsDiscoveryScreenState extends State<MdnsDiscoveryScreen> {
  final TextEditingController _tcpController = TextEditingController();

  /// 🔥 TCP 입력 창 표시 (입력 시 자동 검색)
  void _showTcpInputDialog(BuildContext context, MdnsDiscoveryViewModel viewModel) {
    _tcpController.text = viewModel.serviceType;
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Enter TCP Type'),
          content: TextField(
            controller: _tcpController,
            decoration: const InputDecoration(hintText: '_http._tcp'),
          ),
          actions: [
            TextButton(
              onPressed: () {
                viewModel.setServiceType(_tcpController.text); // 🔥 TCP 변경 시 자동 검색
                Navigator.pop(context);
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('mDNS Browser', style: TextStyle(fontSize: 18.sp)),
        centerTitle: true,
        actions: [
          Consumer<MdnsDiscoveryViewModel>(
            builder: (context, viewModel, child) {
              return IconButton(
                icon: const Icon(Icons.settings),
                onPressed: () => _showTcpInputDialog(context, viewModel), // 🔥 TCP 입력 창
              );
            },
          ),
        ],
      ),
      body: Consumer<MdnsDiscoveryViewModel>(
        builder: (context, viewModel, child) {
          if (viewModel.isSearching) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 10),
                  Text('Searching...', style: TextStyle(fontSize: 16)),
                ],
              ),
            );
          }

          if (viewModel.discoveredServices.isEmpty) {
            return Center(
              child: Text(
                viewModel.isDiscovering ? 'Searching for services...' : 'Tap the button to start discovery',
                style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w500),
              ),
            );
          }

          return Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
            child: ListView(
              padding: EdgeInsets.only(bottom: 80.h), // 🔥 하단 패딩 추가 (버튼 높이 고려)
              children: viewModel.discoveredServices.entries.expand((entry) {
                final serviceType = entry.key;
                final services = entry.value;

                return [
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 8.h),
                    child: Text(
                      serviceType.toUpperCase(),
                      style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold, color: Colors.blue),
                    ),
                  ),
                  ...services.map((service) => Card(
                        elevation: 4,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                        margin: EdgeInsets.only(bottom: 12.h),
                        child: ListTile(
                          contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
                          leading: Icon(Icons.wifi_tethering, size: 30.w, color: Colors.blue),
                          title: Text(
                            service.name ?? 'Unknown',
                            style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold),
                          ),
                          subtitle: Text(
                            service.toJson().toString(),
                            style: TextStyle(fontSize: 14.sp, color: Colors.grey[600]),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      )),
                ];
              }).toList(),
            ),
          );
        },
      ),
      floatingActionButton: Consumer<MdnsDiscoveryViewModel>(
        builder: (context, viewModel, child) {
          return FloatingActionButton.extended(
            onPressed: viewModel.isDiscovering ? viewModel.stopDiscovery : viewModel.startDiscovery,
            backgroundColor: viewModel.isDiscovering ? Colors.red : Colors.blue,
            label: Text(viewModel.isDiscovering ? 'Stop Discovery' : 'Start Discovery'),
            icon: Icon(viewModel.isDiscovering ? Icons.stop : Icons.search),
          );
        },
      ),
    );
  }
}
