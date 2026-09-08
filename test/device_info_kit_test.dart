import 'package:device_info_kit/device_info_kit.dart';
import 'package:test/test.dart';

void main() {
  group('IosDeviceInfo Model Tests', () {
    test('fromMap parses valid map correctly', () {
      final map = {
        'name': 'iPhone 15 Pro',
        'systemName': 'iOS',
        'systemVersion': '17.2',
        'model': 'iPhone',
        'localizedModel': 'iPhone',
        'identifierForVendor': '12345-abcde',
        'isPhysicalDevice': true,
        'utsname': {
          'sysname': 'Darwin',
          'nodename': 'iPhone',
          'release': '23.2.0',
          'version': 'Darwin Kernel Version 23.2.0',
          'machine': 'iPhone16,1',
        },
      };

      final info = IosDeviceInfo.fromMap(map);

      expect(info.name, equals('iPhone 15 Pro'));
      expect(info.systemName, equals('iOS'));
      expect(info.systemVersion, equals('17.2'));
      expect(info.model, equals('iPhone'));
      expect(info.identifierForVendor, equals('12345-abcde'));
      expect(info.isPhysicalDevice, isTrue);
      expect(info.utsnameMachine, equals('iPhone16,1'));
    });

    test('toMap serializes model correctly', () {
      final info = IosDeviceInfo(
        name: 'iPad Air',
        systemName: 'iPadOS',
        systemVersion: '16.5',
        model: 'iPad',
        localizedModel: 'iPad',
        identifierForVendor: 'vendor-id',
        isPhysicalDevice: false,
        utsnameSysname: 'Darwin',
        utsnameNodename: 'iPad',
        utsnameRelease: '22.0.0',
        utsnameVersion: 'Darwin Kernel Version 22.0.0',
        utsnameMachine: 'iPad13,1',
      );

      final map = info.toMap();
      expect(map['name'], equals('iPad Air'));
      expect(map['isPhysicalDevice'], isFalse);
      expect(map['utsname']['machine'], equals('iPad13,1'));
    });
  });

  group('AndroidDeviceInfo Model Tests', () {
    test('fromMap parses valid map correctly', () {
      final map = {
        'version': {
          'baseOS': '',
          'sdkInt': 34,
          'release': '14',
          'incremental': '1234567',
          'codename': 'REL',
          'previewSdkInt': 0,
          'securityPatch': '2024-01-01',
        },
        'board': 'tango',
        'bootloader': 'unknown',
        'brand': 'google',
        'device': 'husky',
        'display': 'UD1A.230803.022',
        'fingerprint': 'google/husky/husky:14/UD1A.230803.022/10822000:user/release-keys',
        'hardware': 'zuma',
        'host': 'abox1',
        'id': 'UD1A.230803.022',
        'manufacturer': 'Google',
        'model': 'Pixel 8 Pro',
        'product': 'husky',
        'tags': 'release-keys',
        'type': 'user',
        'supportedAbis': ['arm64-v8a', 'armeabi-v7a'],
        'isPhysicalDevice': true,
        'androidId': 'a1b2c3d4e5f6',
        'totalMemory': 12000000000,
        'isLowMemoryDevice': false,
        'totalStorage': 128000000000,
        'freeStorage': 64000000000,
        'displayMetrics': {
          'widthPixels': 1440,
          'heightPixels': 3120,
          'densityDpi': 560,
          'xdpi': 560.0,
          'ydpi': 560.0,
        },
        'locale': 'en_US',
        'timeZoneId': 'America/New_York',
        'systemFeatures': ['android.hardware.camera', 'android.hardware.bluetooth'],
      };

      final info = AndroidDeviceInfo.fromMap(map);

      expect(info.model, equals('Pixel 8 Pro'));
      expect(info.manufacturer, equals('Google'));
      expect(info.version.sdkInt, equals(34));
      expect(info.version.release, equals('14'));
      expect(info.version.securityPatch, equals('2024-01-01'));
      expect(info.supportedAbis, contains('arm64-v8a'));
      expect(info.androidId, equals('a1b2c3d4e5f6'));
      expect(info.isPhysicalDevice, isTrue);
      expect(info.totalMemory, equals(12000000000));
      expect(info.displayMetrics.widthPixels, equals(1440));
      expect(info.systemFeatures, contains('android.hardware.camera'));
    });
  });

  group('DeviceInfoPlugin Guards', () {
    test('loadSymbols safely guards desktop/Linux test environment', () {
      DeviceInfoFFIBindings.loadSymbols();
      expect(DeviceInfoFFIBindings.isLoaded, isFalse);
    });

    test('iosInfo throws UnsupportedError on desktop runner', () {
      final plugin = DeviceInfoPlugin();
      expect(() => plugin.iosInfo, throwsA(isA<UnsupportedError>()));
    });

    test('androidInfo throws UnsupportedError on desktop runner', () {
      final plugin = DeviceInfoPlugin();
      expect(() => plugin.androidInfo, throwsA(isA<UnsupportedError>()));
    });
  });
}
