//
//  Bundle+Ex.swift
//  TV Remote Control
//
//  Created by 陶博 on 2025/3/18.
//

import Foundation
import UIKit

public extension Bundle {
    
    var releaseVersionNumber: String? {
        return infoDictionary?["CFBundleShortVersionString"] as? String
    }
    var buildVersionNumber: String? {
        return infoDictionary?["CFBundleVersion"] as? String
    }
    
    /// 应用程序名称（显示在主屏幕下方）
    var applicationName: String? {
        if let displayName = object(forInfoDictionaryKey: "CFBundleDisplayName") as? String {
            return displayName
        } else if let name = object(forInfoDictionaryKey: "CFBundleName") as? String {
            return name
        } else {
            return nil
        }
    }
    
    /// 读取本地json文件
    func loadLocalJSON(_ jsonName: String) -> String? {
        guard let path = Bundle.main.path(forResource: jsonName, ofType: "json"),
              let data = try? Data(contentsOf: URL(fileURLWithPath: path)),
              let jsonString = String(data: data, encoding: .utf8) else {
            return nil
        }
        return jsonString
    }
    
}
