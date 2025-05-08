//
//  TBBaseManage.swift
//  TBBasicLib
//
//  Created by 陶博 on 2025/5/8.
//


import Foundation
import UIKit
import Contacts
import CoreLocation
import SystemConfiguration
import CoreTelephony
import AdSupport



public class TBBaseManage {
    public static let shared = TBBaseManage()
    required init() {}
    
    
    /// 获取时间戳
    /// - Returns: string
    public func getTimestamp() -> String {
        let date = Date()
        let timestamp = Int(date.timeIntervalSince1970) // 转换为整数时间戳
        return String(timestamp)
    }
    
    /// 获取通讯录
    public func fetchContacts(_  callBack: @escaping (([CNContact])->())) {
        Authority.requestContactsAccess { success in
            if success {
                //获取Fetch,并且指定要获取联系人中的什么属性
                let keys = [CNContactGivenNameKey,
                            CNContactFamilyNameKey,
                            CNContactPhoneNumbersKey] as [CNKeyDescriptor]
                //创建通讯录对象
                let store = CNContactStore()
                //创建请求对象
                //需要传入一个(keysToFetch: [CNKeyDescriptor]) 包含CNKeyDescriptor类型的数组
                let request = CNContactFetchRequest(keysToFetch: keys as [CNKeyDescriptor])
                
                var contactArr = [CNContact]()
                
                DispatchQueue.global(qos: .userInitiated).async {
                    debugPrint("异步获取")
                    //遍历所有联系人
                    do {
                        try store.enumerateContacts(with: request, usingBlock: {(contact : CNContact, stop :UnsafeMutablePointer<ObjCBool>)-> Void in
                            contactArr.append(contact)
                        })
                        callBack(contactArr)
                    } catch {
                        callBack([])
                        debugPrint(error.localizedDescription)
                    }
                }
            }
        }
    }
    
    /// 获取电池信息
    public func getBatteryInfo() -> Int {
        UIDevice.current.isBatteryMonitoringEnabled = true
        let batteryLevel = UIDevice.current.batteryLevel
        print("电池电量: \(batteryLevel * 100)%")
        return Int(batteryLevel * 100)
    }
    
    /// 获取电池信息
    public func getBatteryStatus() -> Bool {
        UIDevice.current.isBatteryMonitoringEnabled = true
        let batteryState = UIDevice.current.batteryState
        
        switch batteryState {
        case .unknown:
            print("未知的电池状态")
        case .unplugged:
            print("未充电")
        case .charging:
            print("充电中")
            return true
        case .full:
            print("满电")
        @unknown default:
            print("Unsupported battery state")
        }
        
        return false
    }
    
    
    /// 获取当前设备的时区
    public func getTimeZoneInfo() -> String {
        // 创建一个表示GMT+8时区的TimeZone对象
        let timeZone = TimeZone(identifier: "Asia/Shanghai") // 上海位于GMT+8时区
        if let timeZone = timeZone {
            // 打印时区名称
            print("Time Zone Name: \(timeZone.identifier)")
            // 获取时区相对于GMT的秒数偏移量
            let secondsFromGMT = timeZone.secondsFromGMT()
            // 将秒数偏移量转换为小时
            let hoursFromGMT = secondsFromGMT / 3600
            // 打印相对于GMT的偏移量
            print("Offset from GMT: \(hoursFromGMT) hours")
            // 如果需要打印为"GMT+8"这样的格式
            let gmtOffsetString = hoursFromGMT > 0 ? "GMT+\(hoursFromGMT)" : "GMT\(hoursFromGMT)"
            return gmtOffsetString
        }
        return "GMT+8"
    }
    /// 判断设备是否用代理
    public func isUsedProxy() -> Bool {
        guard let proxy = CFNetworkCopySystemProxySettings()?.takeUnretainedValue() else { return false }
        guard let dict = proxy as? [String: Any] else { return false }
        guard let HTTPProxy = dict["HTTPProxy"] as? String else { return false }
        if(HTTPProxy.count>0){
            return true;
        }
        return false;
    }
    
    /// 是否使用VPN
    public func isVpnActive() -> Bool {
        let vpnProtocolsKeysIdentifiers = ["tap","tun","ppp","ipsec","utun"]
        guard let cfDict = CFNetworkCopySystemProxySettings() else { return false }
        let nsDict = cfDict.takeRetainedValue() as NSDictionary
        guard let keys = nsDict["__SCOPED__"] as? NSDictionary,
              let allKeys = keys.allKeys as? [String] else { return false }
        // Checking for tunneling protocols in the keys
        for key in allKeys {
            for protocolId in vpnProtocolsKeysIdentifiers
            where key.starts(with: protocolId) {
                // I use start(with:), so I can cover also `ipsec4`, `ppp0`, `utun0` etc...
                return true
            }
        }
        return false
    }
    
    
    ///获取运营商
    public func deviceSupplier() -> String {
        let info = CTTelephonyNetworkInfo()
        var supplier: String = ""
        if #available(iOS 12.0, *) {
            if let carriers = info.serviceSubscriberCellularProviders {
                if carriers.keys.count == 0 {
                    return "无手机卡"
                } else { //获取运营商信息
                    for (index, carrier) in carriers.values.enumerated() {
                        guard carrier.carrierName != nil else { return "无手机卡" }
                        //查看运营商信息 通过CTCarrier类
                        if index == 0 {
                            supplier = carrier.carrierName!
                        } else {
                            supplier = supplier + "," + carrier.carrierName!
                        }
                    }
                    return supplier
                }
            } else{
                return "无手机卡"
            }
        } else {
            if let carrier = info.subscriberCellularProvider {
                guard carrier.carrierName != nil else { return "无手机卡" }
                return carrier.carrierName!
            } else{
                return "无手机卡"
            }
        }
    }
    
    /// 获取当前设备IP
    public func deviceIP() -> String {
        var addresses = [String]()
        var ifaddr : UnsafeMutablePointer<ifaddrs>? = nil
        if getifaddrs(&ifaddr) == 0 {
            var ptr = ifaddr
            while (ptr != nil) {
                let flags = Int32(ptr!.pointee.ifa_flags)
                var addr = ptr!.pointee.ifa_addr.pointee
                if (flags & (IFF_UP|IFF_RUNNING|IFF_LOOPBACK)) == (IFF_UP|IFF_RUNNING) {
                    if addr.sa_family == UInt8(AF_INET) || addr.sa_family == UInt8(AF_INET6) {
                        var hostname = [CChar](repeating: 0, count: Int(NI_MAXHOST))
                        if (getnameinfo(&addr, socklen_t(addr.sa_len), &hostname, socklen_t(hostname.count),nil, socklen_t(0), NI_NUMERICHOST) == 0) {
                            if let address = String(validatingUTF8:hostname) {
                                addresses.append(address)
                            }
                        }
                    }
                }
                ptr = ptr!.pointee.ifa_next
            }
            freeifaddrs(ifaddr)
        }
        if let ipStr = addresses.first {
            return ipStr
        } else {
            return ""
        }
    }
    /// 获取设备名称
    public func getDeviceModel() -> String {
        return UIDevice.current.model
    }
    /// 获取设备的IDFV
    public func getIDFV() -> String {
        UIDevice.current.identifierForVendor?.uuidString ?? ""
    }
    
    /// 获取设备的IDFA
    public func getIDFA() -> String {
        ASIdentifierManager.shared().advertisingIdentifier.uuidString
    }
    /// 获取当前设备语言
    public func getCurrentLanguage() -> String {
        let languages: [String] = UserDefaults.standard.object(forKey: "AppleLanguages") as! [String]
        let currentLanguage = languages.first
        debugPrint("\(currentLanguage ?? "")")
        return currentLanguage ?? ""
    }
    
    /// 获取屏幕物理尺寸
    public func getDevicePhysicsSize() -> Double {
        var systemInfo = utsname()
        uname(&systemInfo)
        let machineMirror = Mirror(reflecting: systemInfo.machine)
        let identifier = machineMirror.children.reduce("") { identifier, element in
            guard let value = element.value as? Int8, value != 0 else { return identifier }
            return identifier + String(UnicodeScalar(UInt8(value)))
        }
        debugPrint(identifier)
        
        // iPhone 型号和屏幕尺寸的映射关系
        let iPhoneScreenSizes: [String: Double] = [
            "iPhone1,1": 3.5,   // iPhone 2G
            "iPhone1,2": 3.5,   // iPhone 3G
            "iPhone2,1": 3.5,   // iPhone 3GS
            "iPhone3,1": 3.5,   // iPhone 4
            "iPhone3,2": 3.5,   // iPhone 4 (CDMA)
            "iPhone3,3": 3.5,   // iPhone 4 (CDMA)
            "iPhone4,1": 3.5,   // iPhone 4S
            "iPhone5,1": 4.0,   // iPhone 5
            "iPhone5,2": 4.0,   // iPhone 5
            "iPhone5,3": 4.0,   // iPhone 5C
            "iPhone5,4": 4.0,   // iPhone 5C
            "iPhone6,1": 4.0,   // iPhone 5S
            "iPhone6,2": 4.0,   // iPhone 5S
            "iPhone7,1": 5.5,   // iPhone 6 Plus
            "iPhone7,2": 4.7,   // iPhone 6
            "iPhone8,1": 4.7,   // iPhone 6S
            "iPhone8,2": 5.5,   // iPhone 6S Plus
            "iPhone8,4": 4.0,   // iPhone SE (1st generation)
            "iPhone9,1": 4.7,   // iPhone 7
            "iPhone9,2": 5.5,   // iPhone 7 Plus
            "iPhone9,3": 4.7,   // iPhone 7
            "iPhone9,4": 5.5,   // iPhone 7 Plus
            "iPhone10,1": 4.7,  // iPhone 8
            "iPhone10,2": 5.5,  // iPhone 8 Plus
            "iPhone10,3": 5.8,  // iPhone X
            "iPhone10,4": 5.8,  // iPhone X
            "iPhone10,5": 5.8,  // iPhone X
            "iPhone10,6": 5.8,  // iPhone X
            "iPhone11,2": 5.8,  // iPhone XS
            "iPhone11,4": 6.5,  // iPhone XS Max
            "iPhone11,6": 6.5,  // iPhone XS Max
            "iPhone11,8": 6.1,  // iPhone XR
            "iPhone12,1": 6.1,  // iPhone 11
            "iPhone12,3": 5.8,  // iPhone 11 Pro
            "iPhone12,5": 6.7,  // iPhone 11 Pro Max
            "iPhone12,8": 5.4,  // iPhone 12 Mini
            "iPhone13,1": 6.1,  // iPhone 12
            "iPhone13,2": 6.1,  // iPhone 12 Pro
            "iPhone13,3": 6.7,  // iPhone 12 Pro Max
            "iPhone14,4": 5.4,  // iPhone 13 Mini
            "iPhone14,5": 6.1,  // iPhone 13
            "iPhone14,2": 6.1,  // iPhone 13 Pro
            "iPhone14,3": 6.7,  // iPhone 13 Pro Max
            "iPhone15,1": 6.1,  // iPhone 14
            "iPhone15,2": 6.7   // iPhone 14 Pro
        ]
        
        
        return iPhoneScreenSizes[identifier] ?? 6.7
    }
    
    /// 获取设备型号
    public func getAppleDeviceModel() -> String {
        var systemInfo = utsname()
        uname(&systemInfo)
        let machineMirror = Mirror(reflecting: systemInfo.machine)
        let identifier = machineMirror.children.reduce("") { identifier, element in
            guard let value = element.value as? Int8, value != 0 else { return identifier }
            return identifier + String(UnicodeScalar(UInt8(value)))
        }
        
        switch identifier {
        case "iPod1,1":  return "iPodTouch1"
        case "iPod2,1":  return "iPodTouch2"
        case "iPod3,1":  return "iPodTouch3"
        case "iPod4,1":  return "iPodTouch4"
        case "iPod5,1":  return "iPodTouch(5 Gen)"
        case "iPod7,1":   return "iPodTouch6"
        case "iPod9,1":   return "iPodTouch6"
            
        case "iPhone3,1", "iPhone3,2", "iPhone3,3":  return "iPhone4"
        case "iPhone4,1":  return "iPhone4s"
        case "iPhone5,1":   return "iPhone5"
        case "iPhone5,2":  return "iPhone5(GSM+CDMA)"
        case "iPhone5,3":  return "iPhone5c(GSM)"
        case "iPhone5,4":  return "iPhone5c(GSM+CDMA)"
        case "iPhone6,1":  return "iPhone5s(GSM)"
        case "iPhone6,2":  return "iPhone5s(GSM+CDMA)"
        case "iPhone7,2":  return "iPhone6"
        case "iPhone7,1":  return "iPhone6 Plus"
        case "iPhone8,1":  return "iPhone6s"
        case "iPhone8,2":  return "iPhone6s Plus"
        case "iPhone8,4":  return "iPhoneSE"
            
        case "iPhone9,1","iPhone9,3":  return "iPhone7"
        case "iPhone9,2","iPhone9,4":  return "iPhone7Plus"
        case "iPhone10,1","iPhone10,4":   return "iPhone8"
        case "iPhone10,2","iPhone10,5":   return "iPhone8Plus"
        case "iPhone10,3","iPhone10,6":   return "iPhoneX"
        case "iPhone11,2":  return "iPhone XS"
        case "iPhone11,4","iPhone11,6":  return "iPhoneXSMax"
        case "iPhone11,8":  return "iPhoneXR"
        case "iPhone12,1":  return "iPhone11"
        case "iPhone12,5":  return "iPhone11ProMax"
        case "iPhone12,8":  return "iPhoneSE2"
        case "iPhone13,1":  return "iPhone12mini"
        case "iPhone13,2":  return "iPhone12"
        case "iPhone13,3":  return "iPhone12Pro"
        case "iPhone13,4":  return "iPhone12Pro Max"
        case "iPhone14,4":  return "iPhone13 mini"
        case "iPhone14,5":  return "iPhone13"
        case "iPhone14,2":  return "iPhone13Pro"
        case "iPhone14,3":  return "iPhone13Pro Max"
        case "iPhone14,6":  return "iPhoneSE3"
        case "iPhone14,7":  return "iPhone14"
        case "iPhone14,8":  return "iPhone14Plus"
        case "iPhone15,2":  return "iPhone14Pro"
        case "iPhone15,3":  return "iPhone14Pro Max"
        case "iPhone15,4":  return "iPhone15"
        case "iPhone15,5":  return "iPhone15Plus"
        case "iPhone16,1":  return "iPhone15Pro"
        case "iPhone16,2":  return "iPhone15Pro Max"
            
        case "iPad1,1":   return "iPad"
        case "iPad1,2":   return "iPad 3G"
        case "iPad2,1", "iPad2,2", "iPad2,3", "iPad2,4":   return "iPad2"
        case "iPad3,1", "iPad3,2", "iPad3,3":  return "iPad3"
        case "iPad3,4", "iPad3,5", "iPad3,6":   return "iPad4"
        case "iPad6,11", "iPad6,12":  return "iPad5"
        case "iPad7,5", "iPad7,6":  return "iPad6"
        case "iPad7,11", "iPad7,12":  return "iPad7"
        case "iPad11,6", "iPad11,7": return "iPad8"
        case "iPad12,1", "iPad12,2": return "iPad9"
        case "iPad13,18", "iPad13,19": return "iPad10"
            
        case "iPad4,1", "iPad4,2", "iPad4,3":   return "iPadAir"
        case "iPad5,3", "iPad5,4":   return "iPadAir2"
        case "iPad11,3", "iPad11,4": return "iPadAir3"
        case "iPad13,1", "iPad13,2": return "iPadAir4"
        case "iPad13,16", "iPad13,17": return "iPadAir5"
            
        case "iPad2,5", "iPad2,6", "iPad2,7":  return "iPadMini"
        case "iPad4,4", "iPad4,5", "iPad4,6":  return "iPadMini2"
        case "iPad4,7", "iPad4,8", "iPad4,9":  return "iPadMini3"
        case "iPad5,1", "iPad5,2":  return "iPadMini4"
        case "iPad11,1", "iPad11,2":  return "iPadMini5"
        case "iPad14,1", "iPad14,2":  return "iPadMini6"
            
            
        case "iPad6,3", "iPad6,4":  return "iPadPro9.7"
        case "iPad6,7", "iPad6,8":  return "iPadPro12.9"
        case "iPad7,1", "iPad7,2":   return "iPadPro212.9"
        case "iPad7,3", "iPad7,4":  return "iPadPro10.5"
        case "iPad8,1", "iPad8,2", "iPad8,3", "iPad8,4":  return "iPadPro11"
        case "iPad8,5", "iPad8,6", "iPad8,7", "iPad8,8":  return "iPadPro312.9"
        case "iPad8,9", "iPad8,10":  return "iPadPro211"
        case "iPad8,11", "iPad8,12":  return "iPadPro412.9"
        case "iPad13,4", "iPad13,5", "iPad13,6", "iPad13,7":  return "iPadPro311"
        case "iPad13,8", "iPad13,9", "iPad13,10", "iPad13,11":  return "iPadPro512.9"
        case "iPad14,3", "iPad14,4":  return "iPadPro411"
        case "iPad14,5", "iPad14,6":  return "iPadPro612.9"
            
        default:  return identifier
        }
    }
    
    ///获取系统版本
    public func getDeviceSystemVersion() -> String {
        return UIDevice.current.systemVersion
    }
    
    /// 磁盘总大小
    public func getTotalDiskSize() -> Int64 {
        guard let systemAttributes = try? FileManager.default.attributesOfFileSystem(forPath: NSHomeDirectory() as String),
              let space = (systemAttributes[FileAttributeKey.systemSize] as? NSNumber)?.int64Value else { return 0 }
        return space
    }
    
    /// 磁盘可用大小
    public func getAvailableDiskSize() -> Int64 {
        if #available(iOS 11.0, *) {
            if let space = try? URL(fileURLWithPath: NSHomeDirectory() as String).resourceValues(forKeys: [URLResourceKey.volumeAvailableCapacityForImportantUsageKey]).volumeAvailableCapacityForImportantUsage {
                return space
            } else {
                return 0
            }
        } else {
            if let systemAttributes = try? FileManager.default.attributesOfFileSystem(forPath: NSHomeDirectory() as String),
               let freeSpace = (systemAttributes[FileAttributeKey.systemFreeSize] as? NSNumber)?.int64Value {
                return freeSpace
            } else {
                return 0
            }
        }
    }
    /// 总运行内存
    public func getTotalMemory() -> Int64 {
        let processInfo = ProcessInfo.processInfo
        // 获取物理内存大小
        let physicalMemory = processInfo.physicalMemory
        print("Physical Memory: \(physicalMemory)")
        return Int64(physicalMemory)
    }
    
    /// 可用运行内存
    public func getAvailableMemory() -> Int64 {
        var info = task_basic_info()
        var count = mach_msg_type_number_t(MemoryLayout<task_basic_info_data_t>.size) / 4
        let kerr = withUnsafeMutablePointer(to: &info) {
            $0.withMemoryRebound(to: integer_t.self, capacity: 1) {
                task_info(mach_task_self_, task_flavor_t(TASK_BASIC_INFO), $0, &count)
            }
        }
        if kerr == KERN_SUCCESS {
            return Int64(UInt64(info.resident_size))
        } else {
            return 0 // Failed to get memory info
        }
        
    }
    
    /// 获取APP版本号
    /// - Returns: 版本号
    public func getAppVersion() -> String {
        let infoDictionary = Bundle.main.infoDictionary
        let minorVersion = (infoDictionary?["CFBundleShortVersionString"] as? String) ?? "" //版本号
        return minorVersion
    }
    
    /// 是否越狱
    public func isJailBreak() -> Bool {
#if targetEnvironment(simulator)
        return false
#else
        let files = [
            "/private/var/lib/apt",
            "/Applications/Cydia.app",
            "/Applications/RockApp.app",
            "/Applications/Icy.app",
            "/Applications/WinterBoard.app",
            "/Applications/SBSetttings.app",
            "/Applications/blackra1n.app",
            "/Applications/IntelliScreen.app",
            "/Applications/Snoop-itConfig.app",
            "/bin/sh",
            "/usr/libexec/sftp-server",
            "/usr/libexec/ssh-keysign /Library/MobileSubstrate/MobileSubstrate.dylib",
            "/bin/bash",
            "/usr/sbin/sshd",
            "/etc/apt /System/Library/LaunchDaemons/com.saurik.Cydia.Startup.plist",
            "/System/Library/LaunchDaemons/com.ikey.bbot.plist",
            "/Library/MobileSubstrate/DynamicLibraries/LiveClock.plist",
            "/Library/MobileSubstrate/DynamicLibraries/Veency.plist"
        ]
        return files.contains(where: {
            return FileManager.default.fileExists(atPath: $0)
        })
#endif
        
    }
    
    /// 判断是否是模拟器
    public func isSimulator() -> Bool {
        #if targetEnvironment(simulator)
        return true
        #else
        return false
        #endif
    }
    
}


