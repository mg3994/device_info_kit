# device_info_kit

Native device information plugin for DartNative framework (iOS and Android).

<!-- ## Publishing

This package is published to [dartpub.dev](https://dartpub.dev/plugins/device_info_kit) through GitHub Actions. A local Mac is not required; the workflow can use a macOS runner when the iOS plugin build requires Xcode.

### GitHub Actions setup

1. Add the publishing token as a repository secret named `DN_PUBLISH_TOKEN`.
2. Increment the package version in `pubspec.yaml`.
3. Create a GitHub release or run the publishing workflow manually from the **Actions** tab.

The workflow should build and publish the package using the token stored in GitHub Secrets:

```yaml
- name: Build plugin
  run: dn plugin build

- name: Publish package
  env:
    DN_PUBLISH_TOKEN: ${{ secrets.DN_PUBLISH_TOKEN }}
  run: dn publish --token "$DN_PUBLISH_TOKEN"
```

Do not commit publishing tokens to the repository. After the workflow completes, verify the package and release details on dartpub.dev.

For local development, clone the repository and include it using `path:`, or use the Git dependency below: -->

```yaml
dependencies:
  device_info_kit: ^0.1.0
```

Repository: [mg3994/device_info_kit](https://github.com/mg3994/device_info_kit)

## Usage

```dart
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

```