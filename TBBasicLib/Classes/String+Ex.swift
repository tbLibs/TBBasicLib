//
//  String+Ex.swift
//  TV Remote Control
//
//  Created by 陶博 on 2025/3/26.
//

import Foundation

extension String {
    
    func containsEnglishCharacters() -> Bool {
        let pattern = "[a-zA-Z]"
        do {
            let regex = try NSRegularExpression(pattern: pattern, options: [])
            let matches = regex.matches(in: self, options: [], range: NSRange(self.startIndex..., in: self))
            return !matches.isEmpty
        } catch {
            print("正则表达式匹配出错: \(error)")
            return false
        }
    }
    
    /// 字符转十进制（Unicode）
    /// - Parameter input: string
    func unicodeLookup() -> [UInt32] {
        var unicodeArr = [UInt32]()
        for character in self {
            for scalar in character.unicodeScalars {
                let unicodeDecimal = scalar.value
                unicodeArr.append(unicodeDecimal)
            }
        }
        return unicodeArr
    }
    
}
