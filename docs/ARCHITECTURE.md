# DartNative Plugin Architecture & Development Guide

## Overview of DartNative Framework vs Flutter
DartNative is an independent framework written in Dart that renders using the platform's native views (UIKit / CoreText on iOS, Android Views / Canvas on Android) instead of Flutter's Impeller/Skia canvas engine.
Crucially, **DartNative does not import or use `package:flutter`**.

## Plugin Communication Architecture
DartNative plugins communicate using direct Dart FFI (`dart:ffi`) instead of Flutter's asynchronous MethodChannel / BinaryMessenger layer.

```
Dart API  (e.g., DeviceInfoPlugin.iosInfo)
   │
FFI Bindings (dart:ffi - direct C call)
   │
 ┌─┴────────────────────────────────────────┐
 │                                          │
 iOS (@_cdecl Swift function)    Android (C++ JNI -> Kotlin)
 statically linked in process     libdartnative_device_info.so
```

### Key Architectural Patterns

1. **Synchronous C Function Calls (Dart → Native)**:
   - Dynamic library resolution: `DynamicLibrary.process()` on iOS, `DynamicLibrary.open('lib<plugin>.so')` on Android.
   - Guard non-supported platforms (`Platform.isIOS || Platform.isAndroid`) before lookup.

2. **Memory Lifecycle & String Ownership**:
   - Strings passed from Dart to Native:
     - Dart converts `String` to UTF-8 C string (`text.toNativeUtf8()`).
     - Native code **copies** the string immediately during the call.
     - Dart frees memory in a `finally` block using `calloc.free(ptr)`.
   - Strings returned from Native to Dart:
     - Native returns a C string pointer `UnsafePointer<CChar>` / `const char*`.
     - Dart converts to Dart `String` via `.toDartString()`.
     - Memory allocated by native side for returned strings must be freed by Dart or native helper after conversion to prevent memory leaks.

3. **Hot-Restart-Safe Async Callback Dispatcher (Native → Dart)**:
   - Native code holds a single dispatcher slot or generation counter (`DNRegisterAsyncDispatcherSlot` / `nativeIsolateGen()`).
   - On Hot Restart in development, Dart isolate is torn down and function pointers are invalidated.
   - The framework zeroes the slot before old isolate destruction so stale callbacks drop safely without causing `SIGABRT` crashes.

4. **Package `pubspec.yaml` Registrant Block**:
   ```yaml
   dartnative:
     plugin:
       platforms:
         ios:
           ffiPlugin: true
         android:
           package: com.dartnative.deviceinfo
           pluginClass: DartNativeDeviceInfoPlugin
     registrant:
       imports:
         - package:dartnative_device_info/dartnative_device_info.dart
       calls:
         - DeviceInfoFFIBindings.loadSymbols();
   ```

## `dartnative_device_info` Plugin Specification
Port of popular `device_info_plus` for DartNative.
Provides detailed hardware, OS, and device metadata for iOS and Android devices without any Flutter dependencies.
