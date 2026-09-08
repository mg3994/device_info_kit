import 'dart:io';
import 'package:dartnative/dartnative.dart';
import 'package:device_info_kit/device_info_kit.dart';

void main() async {
  final deviceInfo = DeviceInfoPlugin();

  if (Platform.isIOS) {
    IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
    dnLog('Device: ${iosInfo.name}, iOS ${iosInfo.systemVersion}');
  } else if (Platform.isAndroid) {
    AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
    dnLog(
      'Device: ${androidInfo.model}, Android ${androidInfo.version.release}',
    );
  }
}
