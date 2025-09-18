//
//  DDUserDefaults.swift
//
//  Created by 陶博 on 2025/3/13.
//

import Foundation

public class DDUserDefaults {
    
    public static func set(value: Any, forKey key: String) {
        UserDefaults.standard.set(value, forKey: key)
        UserDefaults.standard.synchronize()
    }
    
    public static func getValue(forKey key: String) -> Any? {
        UserDefaults.standard.object(forKey: key)
    }
    
    public static func deleteValue(forKey key: String) {
        UserDefaults.standard.removeObject(forKey: key)
    }
    
}
