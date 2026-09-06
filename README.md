# device_info_kit

Get current device information for DartNative applications on iOS and Android without any Flutter dependencies.

## Usage

```dart
import 'package:device_info_kit/device_info_kit.dart';

void main() async {
  final deviceInfo = DeviceInfoPlugin();

  if (Platform.isIOS) {
    IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
    print('Device: ${iosInfo.name}, iOS ${iosInfo.systemVersion}');
  } else if (Platform.isAndroid) {
    AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
    print('Device: ${androidInfo.model}, Android ${androidInfo.version.release}');
  }
}
```
