import 'dart:io' show Platform;

import 'package:dartnative/dartnative.dart';
import 'package:device_info_kit/device_info_kit.dart';

import 'dartnative_plugin_registrant.dart';

void main() async {
  // Platform bindings + (once you add plugins) their FFI symbols. Keep this
  // as the FIRST line of main() — see lib/dartnative_plugin_registrant.dart.
  DartNativePluginRegistrant.registerAll();
  // App-wide system chrome default for the white template: dark status-bar
  // icons over the light background, transparent strips. Screens can override
  // in initState; the navigator restores this default on pop.
  SystemChrome.defaultStyle = const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    statusBarBrightness: Brightness.light,
    statusBarIconBrightness: Brightness.dark,
    systemNavigationBarColor: Colors.transparent,
    systemNavigationBarIconBrightness: Brightness.dark,
  );
  final deviceInfo = DeviceInfoPlugin();

  String deviceDetails = 'Unknown device';
  if (Platform.isIOS) {
    final iosInfo = await deviceInfo.iosInfo;
    deviceDetails = '${iosInfo.name}, iOS ${iosInfo.systemVersion}';
  } else if (Platform.isAndroid) {
    final androidInfo = await deviceInfo.androidInfo;
    deviceDetails =
        '${androidInfo.model}, Android ${androidInfo.version.release}';
  }
  runApp(HomeScreen(deviceDetails: deviceDetails));
}

/// Starter screen — replace this with your own UI.
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key, required this.deviceDetails});

  final String deviceDetails;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // White-by-design screen: declare the light trait so system materials
      // (keyboard, glass) stay light even when the device is in Dark Mode.
      brightness: Brightness.light,
      appBar: AppBar(
        title: const Text(
          'DartNative',
          style: TextStyle(
            color: Color(0xFF111111),
            fontSize: 17,
            fontWeight: FontWeight.bold,
          ),
        ),
        // No backgroundColor: on iOS 26 this is the fully CLEAR glass bar
        // (the system scroll-edge ramp keeps it legible); elsewhere the
        // platform's default light bar over the white screen.
      ),
      backgroundColor: const Color(0xFFFFFFFF),
      body: Container(
        alignment: Alignment.center,
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              '👋  Welcome to dartnative',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Color(0xFF111111),
                fontSize: 20,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Device: $deviceDetails',
              textAlign: TextAlign.center,
              style: const TextStyle(color: Color(0xFF6B6B70), fontSize: 14),
            ),
            const SizedBox(height: 10),
            const Text(
              'Edit lib/main.dart to build your app. '
              'See README.md to swap the app icon / splash logo, '
              'and dartpub.dev for plugins.',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Color(0xFF6B6B70),
                fontSize: 14,
                height: 1.45,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
