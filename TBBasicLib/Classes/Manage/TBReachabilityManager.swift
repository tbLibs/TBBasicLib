//
//  TBReachabilityManager.swift
//  TBBasicLib
//
//  Created by 陶博 on 2025/4/15.
//

import Foundation
import Network
import CoreTelephony
import SystemConfiguration.CaptiveNetwork

public enum NetworkType: String {
    case wifi = "wifi"
    case g2 = "2G"
    case g3 = "3G"
    case g4 = "4G"
    case g5 = "5G"
    case none = "noNet"
    case unknown = "unKnown"
}

public class TBReachabilityManager {
    public static let shared = TBReachabilityManager()
    
    private let monitor = NWPathMonitor()
    private let telephonyInfo = CTTelephonyNetworkInfo()
    private var currentNetworkType: NetworkType = .unknown
    
    private init() {
        monitor.pathUpdateHandler = { [weak self] path in
            self?.currentNetworkType = self?.determineNetworkType(path: path) ?? .unknown
            print("当前网络类型：\(self?.currentNetworkType.rawValue ?? "未知")")
        }
        monitor.start(queue: DispatchQueue.global(qos: .background))
    }
    
    public func getCurrentNetworkType() -> NetworkType {
        currentNetworkType
    }
    
    private func determineNetworkType(path: NWPath) -> NetworkType {
        guard path.status == .satisfied else { return .none }
        
        if path.usesInterfaceType(.wifi) {
            return .wifi
        } else if path.usesInterfaceType(.cellular) {
            return cellularType()
        } else {
            return .unknown
        }
    }
    
    private func cellularType() -> NetworkType {
        guard let radioType = telephonyInfo.serviceCurrentRadioAccessTechnology?.values.first else {
            return .unknown
        }
        
        if #available(iOS 14.1, *) {
            switch radioType {
            case CTRadioAccessTechnologyNRNSA,
                 CTRadioAccessTechnologyNR:
                return .g5
            case CTRadioAccessTechnologyLTE:
                return .g4
            case CTRadioAccessTechnologyWCDMA,
                 CTRadioAccessTechnologyHSDPA,
                 CTRadioAccessTechnologyHSUPA,
                 CTRadioAccessTechnologyCDMAEVDORev0,
                 CTRadioAccessTechnologyCDMAEVDORevA,
                 CTRadioAccessTechnologyCDMAEVDORevB,
                 CTRadioAccessTechnologyeHRPD:
                return .g3
            case CTRadioAccessTechnologyGPRS,
                 CTRadioAccessTechnologyEdge,
                 CTRadioAccessTechnologyCDMA1x:
                return .g2
            default:
                return .unknown
            }
        } else {
            switch radioType {
            case CTRadioAccessTechnologyLTE:
                return .g4
            case CTRadioAccessTechnologyWCDMA,
                 CTRadioAccessTechnologyHSDPA,
                 CTRadioAccessTechnologyHSUPA,
                 CTRadioAccessTechnologyCDMAEVDORev0,
                 CTRadioAccessTechnologyCDMAEVDORevA,
                 CTRadioAccessTechnologyCDMAEVDORevB,
                 CTRadioAccessTechnologyeHRPD:
                return .g3
            case CTRadioAccessTechnologyGPRS,
                 CTRadioAccessTechnologyEdge,
                 CTRadioAccessTechnologyCDMA1x:
                return .g2
            default:
                return .unknown
            }
        }
    }
}
