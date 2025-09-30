//
//  UIColor+Ex.swift
//  TV Remote Control
//
//  Created by 陶博 on 2025/3/10.
//

import Foundation
import UIKit

/**
 颜色扩展（所有用到的颜色）
 */
public extension UIColor {
    
    // 颜色转rgb
    convenience init(r: CGFloat,
                     g: CGFloat,
                     b: CGFloat,
                     a: CGFloat) {
        self.init(red: r/255.0,
                  green: g/255.0,
                  blue: b/255.0,
                  alpha: a)
    }
    
    // 颜色转rgb
    convenience init(rgbHex hex: UInt32) {
        let r = CGFloat((hex >> 16) & 0xFF)
        let g = CGFloat((hex >> 8) & 0xFF)
        let b = CGFloat((hex) & 0xFF)
        self.init(r: r, g: g, b: b, a: 1)
    }
    
    /// 使用 16 进制字符串（支持 “#RRGGBB” 或 “#RRGGBBAA” 格式）初始化 UIColor
    convenience init(hex: String) {
        // 去除前后空格和换行符
        var hexSanitized = hex.trimmingCharacters(in: .whitespacesAndNewlines)
        
        // 如果有 "#"，则移除
        if hexSanitized.hasPrefix("#") {
            hexSanitized.remove(at: hexSanitized.startIndex)
        }
        
        // 根据 hex 字符串的长度判断是否包含 alpha 分量
        let length = hexSanitized.count
        var rgb: UInt64 = 0
        
        // 将 hex 字符串扫描成 UInt64 数值
        guard Scanner(string: hexSanitized).scanHexInt64(&rgb) else {
            self.init(red: 0, green: 0, blue: 0, alpha: 0)
            return
        }
        
        switch length {
        case 6:
            // RRGGBB 格式，默认 alpha 为 1.0
            let r = CGFloat((rgb & 0xFF0000) >> 16) / 255.0
            let g = CGFloat((rgb & 0x00FF00) >> 8) / 255.0
            let b = CGFloat(rgb & 0x0000FF) / 255.0
            self.init(red: r, green: g, blue: b, alpha: 1.0)
        case 8:
            // RRGGBBAA 格式，最后两位为 alpha
            let r = CGFloat((rgb & 0xFF000000) >> 24) / 255.0
            let g = CGFloat((rgb & 0x00FF0000) >> 16) / 255.0
            let b = CGFloat((rgb & 0x0000FF00) >> 8) / 255.0
            let a = CGFloat(rgb & 0x000000FF) / 255.0
            self.init(red: r, green: g, blue: b, alpha: a)
        default:
            // 格式错误时返回 nil
            self.init(red: 0, green: 0, blue: 0, alpha: 0)
        }
    }
    
    
    static var color696969: UIColor {
        UIColor(hex: "#696969")
    }
}
