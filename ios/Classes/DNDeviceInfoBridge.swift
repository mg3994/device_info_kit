import UIKit
import Foundation

@objc public class DartNativeDeviceInfoPlugin: NSObject {
    @objc public static func register() {
        // Keeps plugin symbols retained in static linking builds against dead-code elimination.
    }
}

@_cdecl("DNDeviceInfoGetIosInfo")
public func DNDeviceInfoGetIosInfo() -> UnsafeMutablePointer<CChar>? {
    let device = UIDevice.current

    var systemInfo = utsname()
    uname(&systemInfo)
    let machine = withUnsafePointer(to: &systemInfo.machine) {
        $0.withMemoryRebound(to: CChar.self, capacity: 1) {
            String(validatingUTF8: $0) ?? ""
        }
    }
    let sysname = withUnsafePointer(to: &systemInfo.sysname) {
        $0.withMemoryRebound(to: CChar.self, capacity: 1) {
            String(validatingUTF8: $0) ?? ""
        }
    }
    let nodename = withUnsafePointer(to: &systemInfo.nodename) {
        $0.withMemoryRebound(to: CChar.self, capacity: 1) {
            String(validatingUTF8: $0) ?? ""
        }
    }
    let release = withUnsafePointer(to: &systemInfo.release) {
        $0.withMemoryRebound(to: CChar.self, capacity: 1) {
            String(validatingUTF8: $0) ?? ""
        }
    }
    let version = withUnsafePointer(to: &systemInfo.version) {
        $0.withMemoryRebound(to: CChar.self, capacity: 1) {
            String(validatingUTF8: $0) ?? ""
        }
    }

    let isPhysicalDevice: Bool
    #if targetEnvironment(simulator)
    isPhysicalDevice = false
    #else
    isPhysicalDevice = true
    #endif

    let info: [String: Any] = [
        "name": device.name,
        "systemName": device.systemName,
        "systemVersion": device.systemVersion,
        "model": device.model,
        "localizedModel": device.localizedModel,
        "identifierForVendor": device.identifierForVendor?.uuidString ?? "",
        "isPhysicalDevice": isPhysicalDevice,
        "utsname": [
            "sysname": sysname,
            "nodename": nodename,
            "release": release,
            "version": version,
            "machine": machine
        ]
    ]

    guard let jsonData = try? JSONSerialization.data(withJSONObject: info, options: []),
          let jsonString = String(data: jsonData, encoding: .utf8) else {
        return nil
    }

    return strdup(jsonString)
}

@_cdecl("DNDeviceInfoFreeString")
public func DNDeviceInfoFreeString(_ ptr: UnsafeMutablePointer<CChar>?) {
    if let ptr = ptr {
        free(ptr)
    }
}
