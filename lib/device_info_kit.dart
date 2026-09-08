import 'dart:convert';
import 'dart:io';
import 'src/device_info_ffi_bindings.dart';

export 'src/device_info_ffi_bindings.dart' show DeviceInfoFFIBindings;

class IosDeviceInfo {
  final String name;
  final String systemName;
  final String systemVersion;
  final String model;
  final String localizedModel;
  final String identifierForVendor;
  final bool isPhysicalDevice;
  final String utsnameSysname;
  final String utsnameNodename;
  final String utsnameRelease;
  final String utsnameVersion;
  final String utsnameMachine;

  IosDeviceInfo({
    required this.name,
    required this.systemName,
    required this.systemVersion,
    required this.model,
    required this.localizedModel,
    required this.identifierForVendor,
    required this.isPhysicalDevice,
    required this.utsnameSysname,
    required this.utsnameNodename,
    required this.utsnameRelease,
    required this.utsnameVersion,
    required this.utsnameMachine,
  });

  factory IosDeviceInfo.fromMap(Map<String, dynamic> map) {
    final utsname = (map['utsname'] as Map<String, dynamic>?) ?? {};
    return IosDeviceInfo(
      name: map['name'] ?? '',
      systemName: map['systemName'] ?? '',
      systemVersion: map['systemVersion'] ?? '',
      model: map['model'] ?? '',
      localizedModel: map['localizedModel'] ?? '',
      identifierForVendor: map['identifierForVendor'] ?? '',
      isPhysicalDevice: map['isPhysicalDevice'] ?? true,
      utsnameSysname: utsname['sysname'] ?? '',
      utsnameNodename: utsname['nodename'] ?? '',
      utsnameRelease: utsname['release'] ?? '',
      utsnameVersion: utsname['version'] ?? '',
      utsnameMachine: utsname['machine'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'systemName': systemName,
      'systemVersion': systemVersion,
      'model': model,
      'localizedModel': localizedModel,
      'identifierForVendor': identifierForVendor,
      'isPhysicalDevice': isPhysicalDevice,
      'utsname': {
        'sysname': utsnameSysname,
        'nodename': utsnameNodename,
        'release': utsnameRelease,
        'version': utsnameVersion,
        'machine': utsnameMachine,
      },
    };
  }
}

class AndroidBuildVersion {
  final String baseOS;
  final int sdkInt;
  final String release;
  final String incremental;
  final String codename;
  final int previewSdkInt;
  final String securityPatch;

  AndroidBuildVersion({
    required this.baseOS,
    required this.sdkInt,
    required this.release,
    required this.incremental,
    required this.codename,
    required this.previewSdkInt,
    required this.securityPatch,
  });

  factory AndroidBuildVersion.fromMap(Map<String, dynamic> map) {
    return AndroidBuildVersion(
      baseOS: map['baseOS'] ?? '',
      sdkInt: map['sdkInt'] ?? 0,
      release: map['release'] ?? '',
      incremental: map['incremental'] ?? '',
      codename: map['codename'] ?? '',
      previewSdkInt: map['previewSdkInt'] ?? 0,
      securityPatch: map['securityPatch'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'baseOS': baseOS,
      'sdkInt': sdkInt,
      'release': release,
      'incremental': incremental,
      'codename': codename,
      'previewSdkInt': previewSdkInt,
      'securityPatch': securityPatch,
    };
  }
}

class AndroidDisplayMetrics {
  final int widthPixels;
  final int heightPixels;
  final int densityDpi;
  final double xdpi;
  final double ydpi;

  AndroidDisplayMetrics({
    required this.widthPixels,
    required this.heightPixels,
    required this.densityDpi,
    required this.xdpi,
    required this.ydpi,
  });

  factory AndroidDisplayMetrics.fromMap(Map<String, dynamic> map) {
    return AndroidDisplayMetrics(
      widthPixels: map['widthPixels'] ?? 0,
      heightPixels: map['heightPixels'] ?? 0,
      densityDpi: map['densityDpi'] ?? 0,
      xdpi: (map['xdpi'] as num?)?.toDouble() ?? 0.0,
      ydpi: (map['ydpi'] as num?)?.toDouble() ?? 0.0,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'widthPixels': widthPixels,
      'heightPixels': heightPixels,
      'densityDpi': densityDpi,
      'xdpi': xdpi,
      'ydpi': ydpi,
    };
  }
}

class AndroidDeviceInfo {
  final AndroidBuildVersion version;
  final String board;
  final String bootloader;
  final String brand;
  final String device;
  final String display;
  final String fingerprint;
  final String hardware;
  final String host;
  final String id;
  final String manufacturer;
  final String model;
  final String product;
  final String tags;
  final String type;
  final List<String> supportedAbis;
  final bool isPhysicalDevice;
  final String androidId;
  final int totalMemory;
  final bool isLowMemoryDevice;
  final int totalStorage;
  final int freeStorage;
  final AndroidDisplayMetrics displayMetrics;
  final String locale;
  final String timeZoneId;
  final List<String> systemFeatures;

  AndroidDeviceInfo({
    required this.version,
    required this.board,
    required this.bootloader,
    required this.brand,
    required this.device,
    required this.display,
    required this.fingerprint,
    required this.hardware,
    required this.host,
    required this.id,
    required this.manufacturer,
    required this.model,
    required this.product,
    required this.tags,
    required this.type,
    required this.supportedAbis,
    required this.isPhysicalDevice,
    required this.androidId,
    required this.totalMemory,
    required this.isLowMemoryDevice,
    required this.totalStorage,
    required this.freeStorage,
    required this.displayMetrics,
    required this.locale,
    required this.timeZoneId,
    required this.systemFeatures,
  });

  factory AndroidDeviceInfo.fromMap(Map<String, dynamic> map) {
    return AndroidDeviceInfo(
      version: AndroidBuildVersion.fromMap(
        (map['version'] as Map<String, dynamic>?) ?? {},
      ),
      board: map['board'] ?? '',
      bootloader: map['bootloader'] ?? '',
      brand: map['brand'] ?? '',
      device: map['device'] ?? '',
      display: map['display'] ?? '',
      fingerprint: map['fingerprint'] ?? '',
      hardware: map['hardware'] ?? '',
      host: map['host'] ?? '',
      id: map['id'] ?? '',
      manufacturer: map['manufacturer'] ?? '',
      model: map['model'] ?? '',
      product: map['product'] ?? '',
      tags: map['tags'] ?? '',
      type: map['type'] ?? '',
      supportedAbis: List<String>.from(map['supportedAbis'] ?? []),
      isPhysicalDevice: map['isPhysicalDevice'] ?? true,
      androidId: map['androidId'] ?? '',
      totalMemory: map['totalMemory'] ?? 0,
      isLowMemoryDevice: map['isLowMemoryDevice'] ?? false,
      totalStorage: map['totalStorage'] ?? 0,
      freeStorage: map['freeStorage'] ?? 0,
      displayMetrics: AndroidDisplayMetrics.fromMap(
        (map['displayMetrics'] as Map<String, dynamic>?) ?? {},
      ),
      locale: map['locale'] ?? '',
      timeZoneId: map['timeZoneId'] ?? '',
      systemFeatures: List<String>.from(map['systemFeatures'] ?? []),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'version': version.toMap(),
      'board': board,
      'bootloader': bootloader,
      'brand': brand,
      'device': device,
      'display': display,
      'fingerprint': fingerprint,
      'hardware': hardware,
      'host': host,
      'id': id,
      'manufacturer': manufacturer,
      'model': model,
      'product': product,
      'tags': tags,
      'type': type,
      'supportedAbis': supportedAbis,
      'isPhysicalDevice': isPhysicalDevice,
      'androidId': androidId,
      'totalMemory': totalMemory,
      'isLowMemoryDevice': isLowMemoryDevice,
      'totalStorage': totalStorage,
      'freeStorage': freeStorage,
      'displayMetrics': displayMetrics.toMap(),
      'locale': locale,
      'timeZoneId': timeZoneId,
      'systemFeatures': systemFeatures,
    };
  }
}

class DeviceInfoPlugin {
  DeviceInfoPlugin() {
    DeviceInfoFFIBindings.loadSymbols();
  }

  Future<IosDeviceInfo> get iosInfo async {
    if (!Platform.isIOS) {
      throw UnsupportedError('iosInfo is only supported on iOS');
    }
    final jsonStr = DeviceInfoFFIBindings.getIosInfoJson();
    if (jsonStr == null) {
      throw StateError('Failed to retrieve iOS device information');
    }
    final Map<String, dynamic> map = json.decode(jsonStr);
    return IosDeviceInfo.fromMap(map);
  }

  Future<AndroidDeviceInfo> get androidInfo async {
    if (!Platform.isAndroid) {
      throw UnsupportedError('androidInfo is only supported on Android');
    }
    final jsonStr = DeviceInfoFFIBindings.getAndroidInfoJson();
    if (jsonStr == null) {
      throw StateError('Failed to retrieve Android device information');
    }
    final Map<String, dynamic> map = json.decode(jsonStr);
    return AndroidDeviceInfo.fromMap(map);
  }
}
