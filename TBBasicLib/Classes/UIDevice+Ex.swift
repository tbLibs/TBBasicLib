//
//  UIDevice+Ex.swift
//  TV Remote Control
//
//  Created by 陶博 on 2025/3/27.
//

import Foundation
import UIKit

extension UIDevice {
    
    /// 是否是iPhone
    func deviceTypeIsIphone() -> Bool {
        self.userInterfaceIdiom == .phone
    }
    
}
