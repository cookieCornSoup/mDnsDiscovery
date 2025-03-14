import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'screens/mdns_discovery_screen.dart';
import 'viewmodels/mdns_discovery_viewmodel.dart';

Future<void> main() async {
  runZonedGuarded(() async {
    WidgetsFlutterBinding.ensureInitialized();
    runApp(const App());
  }, (Object error, StackTrace stackTrace) {
    debugPrint('runZonedGuarded Error: $error');
  });
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(375, 812), // iPhone X 기준 사이즈
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return MultiProvider(
          providers: [
            ChangeNotifierProvider(create: (_) => MdnsDiscoveryViewModel()),
          ],
          child: MaterialApp(
            title: 'mDNS Scanner',
            debugShowCheckedModeBanner: false,
            theme: ThemeData(primarySwatch: Colors.blue),
            home: const MdnsDiscoveryScreen(),
          ),
        );
      },
    );
  }
}
