//
//  Toast_Swift+Ex.swift
//  TV Remote Control
//
//  Created by 陶博 on 2025/3/11.
//

import Foundation
import Toast_Swift


class ToastSwiftManage {
    
    /// 展示loading
    static func showLoading() {
        DispatchQueue.main.async {
            KWindow?.makeToastActivity(.center)
        }
    }
    
    /// 隐藏loading
    static func hiddenLoading() {
        DispatchQueue.main.async {
            KWindow?.hideToastActivity()
        }
    }
    
    /// 提示文字
    /// - Parameters:
    ///   - message: 文字
    ///   - duration: 显示时间
    ///   - position: 定位
    static func showMessage(_ message: String, duration: Double = 1.5, position: ToastPosition = .center, completion: ((_ didTap: Bool) -> Void)? = nil) {
        DispatchQueue.main.async {
            KWindow?.makeToast(message, duration: 1.5 , position: position, completion: { didTap in
                completion?(didTap)
            })
        }
    }
    
    
}
