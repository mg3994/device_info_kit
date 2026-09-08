# device_info_kit

Native device information plugin for DartNative framework (iOS and Android).

## Publishing

I do not own a Mac, so I cannot publish this package to [dartpub.dev](https://dartpub.dev/plugins/device_info_kit). To use it, add the package directly from GitHub in your application's `pubspec.yaml`:
```bash
dn publish
▸ publishing mg3994/device_info_kit@0.1.0 → https://dartpub.dev
· community plugin — no companion push (your own repo is the public home; dartpub tabs update from the inline docs
upload)
`dn plugin build` needs macOS + Xcode (it compiles an iOS .xcframework).

```
# Try this or just clone it to your project and include using `path:`

```yaml
dependencies:
  device_info_kit:
    git:
      url: https://github.com/mg3994/device_info_kit.git
```

Repository: [mg3994/device_info_kit](https://github.com/mg3994/device_info_kit)

## Usage

```dart
import 'dart:io';

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