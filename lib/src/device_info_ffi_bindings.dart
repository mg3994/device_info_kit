import 'dart:ffi';
import 'dart:io';
import 'package:ffi/ffi.dart';

typedef _GetDeviceInfoC = Pointer<Utf8> Function();
typedef _GetDeviceInfoDart = Pointer<Utf8> Function();

typedef _FreeDeviceInfoStringC = Void Function(Pointer<Utf8>);
typedef _FreeDeviceInfoStringDart = void Function(Pointer<Utf8>);

class DeviceInfoFFIBindings {
  static _GetDeviceInfoDart? _getIosInfo;
  static _GetDeviceInfoDart? _getAndroidInfo;
  static _FreeDeviceInfoStringDart? _freeString;
  static bool _loaded = false;

  static bool get isLoaded => _loaded;

  static void loadSymbols() {
    if (_loaded) return;
    if (!Platform.isIOS && !Platform.isAndroid) return;

    try {
      final DynamicLibrary lib = Platform.isAndroid
          ? DynamicLibrary.open('libdevice_info_kit.so')
          : DynamicLibrary.process();

      if (Platform.isIOS) {
        _getIosInfo = lib.lookupFunction<_GetDeviceInfoC, _GetDeviceInfoDart>(
            'DNDeviceInfoGetIosInfo');
      } else if (Platform.isAndroid) {
        _getAndroidInfo =
            lib.lookupFunction<_GetDeviceInfoC, _GetDeviceInfoDart>(
                'DNDeviceInfoGetAndroidInfo');
      }

      _freeString = lib.lookupFunction<_FreeDeviceInfoStringC,
          _FreeDeviceInfoStringDart>('DNDeviceInfoFreeString');
      _loaded = true;
    } catch (e) {
      _loaded = false;
    }
  }

  static String? getIosInfoJson() {
    if (!_loaded || !Platform.isIOS || _getIosInfo == null) return null;
    final ptr = _getIosInfo!();
    if (ptr == nullptr) return null;
    try {
      return ptr.toDartString();
    } finally {
      if (_freeString != null) {
        _freeString!(ptr);
      }
    }
  }

  static String? getAndroidInfoJson() {
    if (!_loaded || !Platform.isAndroid || _getAndroidInfo == null) return null;
    final ptr = _getAndroidInfo!();
    if (ptr == nullptr) return null;
    try {
      return ptr.toDartString();
    } finally {
      if (_freeString != null) {
        _freeString!(ptr);
      }
    }
  }
}
